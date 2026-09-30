default:
    @ just -f "{{ source_file() }}" --choose

# Run `mise dot` against the bootstrap `[dotfiles]` table in this repo's `mise.toml`
[positional-arguments]
dot *args:
    MISE_CONFIG_DIR="{{ source_directory() }}" mise dot "$@"

# Link the bootstrap layer, then every entry in ~/.config/mise/config.toml. The file layer is
# read from ~/.config/mise explicitly, since a caller may still have MISE_CONFIG_DIR at the repo.
[positional-arguments]
bootstrap *args: (dot "apply")
    cd ~ && MISE_CONFIG_DIR="$HOME/.config/mise" mise bootstrap "$@"

[positional-arguments]
format *args:
    treefmt "$@"

alias fmt := format
