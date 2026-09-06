# Recipes run under `/usr/bin/env bash`, which is bash 3.2 on macOS: no `mapfile`, and an
# empty array must be expanded as `${arr[@]+"${arr[@]}"}` or `set -u` aborts.
# Stow packages: `home/` everywhere, plus one OS-specific package. On Linux the distro
# family is detected by package manager: pacman -> `home-arch/`, apt -> `home-debian/`.
linux_package := shell('if command -v pacman >/dev/null; then echo home-arch; elif command -v apt >/dev/null; then echo home-debian; fi')
os_package := if os() == "macos" { "home-macos" } else if os() == "linux" { linux_package } else { "" }
packages := trim("home " + os_package)

# Directory the packages are linked into. Defaults to $HOME; export DOTFILES_TARGET to override.
export DOTFILES_TARGET := env("DOTFILES_TARGET", env("HOME"))

# Every linkable file, as `<package>/<path>` lines (READMEs are ignored by `.stowrc`).
list_files := "rg --files --hidden --glob '!README.md' " + packages + " | sort"

# fzf flags shared by every picker: preview the highlighted file with `bat`.
fzf_preview := "--preview 'bat --color=always --line-range :200 {}' --preview-window 'right,60%,border-left'"

default:
    @ just -f "{{ source_file() }}" --choose

_remove_broken_symlinks depth:
    # Remove broken symlinks
    find "$DOTFILES_TARGET" -mindepth 1 -maxdepth {{ depth }} -type l | while read link; do [ -e "$link" ] || (rm "$link" && echo "$link"); done
    find "$DOTFILES_TARGET/.config" -mindepth 1 -maxdepth $(({{ depth }}+1)) -type l | while read link; do [ -e "$link" ] || (rm "$link" && echo "$link"); done
    find "$DOTFILES_TARGET/.local/bin" -mindepth 1 -maxdepth $(({{ depth }}+1)) -type l | while read link; do [ -e "$link" ] || (rm "$link" && echo "$link"); done

_remove_empty_dirs depth:
    # Remove empty directories
    find "$DOTFILES_TARGET" -mindepth 1 -maxdepth {{ depth }} -type d -empty -delete;
    find "$DOTFILES_TARGET/.config" -mindepth 1 -maxdepth $(({{ depth }}+1)) -type d -empty -delete;

clean depth='1': (_remove_broken_symlinks depth) (_remove_empty_dirs depth)


# Given a directory (or nothing), pick files interactively with `rg --files | fzf --multi`;
# with no argument the search root is the cwd, or $DOTFILES_TARGET/.config when run from inside this repo.
# Move a file from $DOTFILES_TARGET into a stow package (chosen via `gum choose`), then link just that file
[no-cd]  # Allow for adopting relative paths (e.g., `just -f <this-justfile> adopt ./someFile.txt`)
adopt path="":
    #!/usr/bin/env bash
    set -euo pipefail
    repo="{{ source_directory() }}"
    arg="{{ path }}"

    paths=()
    search_root=""
    if [ -z "$arg" ]; then
        if [ "$(pwd)" = "$repo" ]; then
            search_root="$DOTFILES_TARGET/.config"
        else
            search_root="$(pwd)"
        fi
    elif [ -f "$arg" ]; then
        paths=("$arg")
    elif [ -d "$arg" ]; then
        search_root="$arg"
    elif [ -e "$arg" ]; then
        echo "Path is neither a file nor a directory: $arg" >&2
        exit 1
    else
        echo "Path does not exist: $arg" >&2
        exit 1
    fi

    if [ -n "$search_root" ]; then
        search_root=$(realpath "$search_root")
        # `rg --files` skips symlinks, so already-stowed files never show up.
        paths=()
        while IFS= read -r p || [ -n "$p" ]; do paths+=("$p"); done < <(
            cd "$search_root" && rg --files --hidden --no-messages --glob '!.git/' \
            | fzf --multi --prompt "adopt> " --header "$search_root" {{ fzf_preview }} \
            | sed "s|^|$search_root/|"
        )
        [ ${#paths[@]} -gt 0 ] || { echo "No files selected" >&2; exit 1; }
    fi

    # Pick the destination package (`home` sorts first, then the OS-specific ones).
    cd "$repo"
    pkg=$(ls -d home*/ | sed 's|/$||' | sort | gum choose --header "Stow package to adopt into:")
    [ -n "$pkg" ] || { echo "No package selected" >&2; exit 1; }
    cd - >/dev/null

    # Validate every path before moving anything.
    rels=()
    abs=()
    for path in "${paths[@]}"; do
        if [ ! -f "$path" ]; then
            echo "Path is not a file: $path" >&2
            exit 1
        fi
        path=$(realpath "$path")
        if [ "${path##"$repo"/}" != "$path" ] || [ "$path" = "$repo" ]; then
            echo "Refusing to adopt path within this repo: $path" >&2
            exit 1
        fi
        rel="${path#"$DOTFILES_TARGET"/}"
        if [ "$rel" = "$path" ]; then
            echo "Refusing to adopt path not within \$DOTFILES_TARGET ($DOTFILES_TARGET): $path" >&2
            exit 1
        fi
        if [ -e "$repo/$pkg/$rel" ] || [ -L "$repo/$pkg/$rel" ]; then
            echo "Refusing to adopt, already exists in repo: $repo/$pkg/$rel" >&2
            exit 1
        fi
        abs+=("$path")
        rels+=("$rel")
    done

    printf 'Adopting into %s/%s/:\n' "$repo" "$pkg"
    printf '  %s\n' "${rels[@]}"
    gum confirm "Adopt ${#abs[@]} file(s)?"

    for i in "${!abs[@]}"; do
        dest="$repo/$pkg/${rels[$i]}"
        mkdir -p "$(dirname "$dest")"
        mv "${abs[$i]}" "$dest"
    done

    # Link only the adopted files back into place.
    printf "$pkg/%s\n" "${rels[@]}" | just -f "{{ source_file() }}" _stow-picks

# Refuse stow's `--target` / `-t`: the link target is always $DOTFILES_TARGET.
[positional-arguments]
_reject-target *args:
    #!/usr/bin/env bash
    for arg in "$@"; do
        case "$arg" in
            --target|--target=*|-t|-t?*)
                echo "error: '$arg' is not accepted; the link target is \$DOTFILES_TARGET (currently: $DOTFILES_TARGET)." >&2
                echo "       Export DOTFILES_TARGET=/path/to/dir instead, e.g. DOTFILES_TARGET=~/.donald just link" >&2
                exit 1 ;;
        esac
    done

# Shared picker: `<prompt>` labels fzf. Non-flag args are files to act on (`home/.zshrc`,
# `./home/.zshrc`, or an absolute path inside a package); with none, fzf prompts. Flags
# (`-...`) go to stow via `_stow-picks`; use the `--flag=value` form for flags with values.
[no-cd, positional-arguments]
_stow-choices prompt *args:
    #!/usr/bin/env bash
    set -euo pipefail
    prompt="$1"; shift
    repo="{{ source_directory() }}"
    just -f "{{ source_file() }}" _reject-target "$@"

    flags=(); picks=()
    for arg in "$@"; do
        case "$arg" in
            -*) flags+=("$arg"); continue ;;
        esac
        # BSD realpath (macOS) has no `-m`; a path that does not resolve is an error below.
        abs=$(realpath "$arg" 2>/dev/null) || abs=""
        rel="${abs#"$repo"/}"
        if [ -z "$abs" ] || [ "$rel" = "$abs" ] || [ ! -f "$abs" ] || ! (cd "$repo" && {{ list_files }} | grep -qxF "$rel"); then
            echo "error: '$arg' is not a linkable file in the stow packages ({{ packages }})" >&2
            echo "       Expected e.g. 'home/.zshrc'; run without arguments to pick interactively." >&2
            exit 1
        fi
        picks+=("$rel")
    done

    cd "$repo"
    if [ ${#picks[@]} -gt 0 ]; then
        printf '%s\n' "${picks[@]}"
    else
        {{ list_files }} | fzf --multi --prompt "$prompt> " {{ fzf_preview }}
    fi | just -f "{{ source_file() }}" _stow-picks ${flags[@]+"${flags[@]}"}

# Shared stow driver: reads `<package>/<path>` lines on stdin and stows only those; args go
# to stow. `--target` is always $DOTFILES_TARGET (overriding `.stowrc`) and may not be passed.
# If every linkable file is selected, the packages are stowed whole.
[positional-arguments]
_stow-picks *args:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ source_directory() }}"
    just -f "{{ source_file() }}" _reject-target "$@"
    # Echo a shell-quoted command line prefixed with `$ `, then run it.
    run() { printf '$'; printf ' %q' "$@"; echo; "$@"; }
    picks=()
    while IFS= read -r pick || [ -n "$pick" ]; do picks+=("$pick"); done
    [ ${#picks[@]} -gt 0 ] || { echo "No files selected" >&2; exit 1; }

    # Picks in a package that is not active on this OS cannot be linked here.
    for pick in "${picks[@]}"; do
        case " {{ packages }} " in
            *" ${pick%%/*} "*) ;;
            *) echo "Skipping $pick: package '${pick%%/*}' is not linked on this OS ({{ packages }})" >&2 ;;
        esac
    done

    # After stow runs, say what state each pick ended up in. Stow itself is silent when
    # there is nothing to do (already linked / already absent), which reads as "nothing
    # happened". Skipped with -n/--simulate, since nothing changes.
    expect=link; simulate=false
    for arg in "$@"; do
        case "$arg" in
            -D|--delete) expect=absent ;;
            -n|--no|--simulate) simulate=true ;;
        esac
    done
    report() {
        $simulate && return 0
        for pick in "${picks[@]}"; do
            case " {{ packages }} " in *" ${pick%%/*} "*) ;; *) continue ;; esac
            target="$DOTFILES_TARGET/${pick#*/}"
            # Plain `realpath` (no GNU `-m`) fails on a dangling link, which then reads as CONFLICT.
            if [ -L "$target" ] && [ "$(realpath "$target" 2>/dev/null)" = "$(realpath "$pick")" ]; then
                state=linked
            elif [ -e "$target" ] || [ -L "$target" ]; then
                state=CONFLICT   # something else sits at the target path
            else
                state=absent
            fi
            if { [ "$expect" = link ] && [ "$state" = linked ]; } || { [ "$expect" = absent ] && [ "$state" = absent ]; }; then
                printf '  ok    %-8s %s\n' "$state" "$target"
            else
                printf '  FAIL  %-8s %s\n' "$state" "$target" >&2
            fi
        done
    }
    trap report EXIT

    # Everything selected: no --ignore needed, stow the packages whole.
    if [ ${#picks[@]} -eq "$({{ list_files }} | wc -l)" ]; then
        run stow --target "$DOTFILES_TARGET" "$@" {{ packages }}
        exit 0
    fi

    # Stow's --ignore is a Perl regex compiled as `($regex)\z` and matched against each
    # package-relative path, directories included. Ignore everything except the picked
    # files and their ancestor directories, so stow still descends to reach them.
    for pkg in {{ packages }}; do
        allow=()
        for pick in "${picks[@]}"; do
            [ "${pick%%/*}" = "$pkg" ] || continue
            rel="${pick#*/}"
            while :; do
                allow+=("$(printf '%s' "$rel" | sed 's|[^A-Za-z0-9/_-]|\\&|g')")
                [ "$rel" = "${rel%/*}" ] && break
                rel="${rel%/*}"
            done
        done
        [ ${#allow[@]} -gt 0 ] || continue
        alt=$(IFS='|'; printf '%s' "${allow[*]}")
        run stow --target "$DOTFILES_TARGET" "$@" --ignore="^(?!(?:$alt)\$).*" "$pkg"
    done

# Link the given files (e.g. `home/.zshrc`), or pick them with `rg --files | fzf --multi`; extra args pass through to stow
[no-cd, positional-arguments]
link *args:
    @ just -f "{{ source_file() }}" _stow-choices link "$@"

# Unlink the given files, or pick them with `rg --files | fzf --multi`
[no-cd, positional-arguments]
unlink *args:
    @ just -f "{{ source_file() }}" _stow-choices unlink --delete "$@"

# Restow the given files, or pick them with `rg --files | fzf --multi`
[no-cd, positional-arguments]
relink *args:
    @ just -f "{{ source_file() }}" _stow-choices relink --restow "$@"
