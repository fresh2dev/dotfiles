# The repo root. This justfile is usually run through a symlink, where `source_directory()`
# is the symlink's directory, not the repo.
repo_dir := parent_directory(canonicalize(source_file()))

# `mise` that reads only `bootstrap/mise.toml` (the bootstrap layer)
mise_local := "MISE_CONFIG_DIR=" + quote(repo_dir / 'bootstrap') + " mise"

# The global mise config dir. Plain `mise` calls rely on the inherited $MISE_CONFIG_DIR
# (set by `.zshenv`) to read it, including `config.macos.toml`.
mise_config_dir := env('XDG_CONFIG_HOME', env('HOME') / '.config') / 'mise'

# Pick a recipe interactively
default:
    @ just -f "{{ source_file() }}" --choose

editor := quote(env('EDITOR', 'nvim'))

# Edit this justfile
edit:
    {{ editor }} {{ source_file() }}

# Edit the global mise config
edit-mise:
    {{ editor }} {{ quote(mise_config_dir / "config.toml") }}

# Edit the macOS-only mise config
edit-mise-macos:
    {{ editor }} {{ quote(mise_config_dir / "config.macos.toml") }}

# Format the repo with dprint, using the repo's copy of the global dprint config, then
# prek's whitespace fixers
format-dotfiles:
    mise exec -- dprint fmt -c {{ quote(repo_dir / "home/.config/dprint/dprint.jsonc") }} {{ quote(repo_dir) }}
    mise exec -- prek -C {{ quote(repo_dir) }} run -q --all-files trailing-whitespace end-of-file-fixer

# Arguments reach every `mise` step except `self-update`, which has no `--dry-run`.
# Upgrade mise, tools, packages, zsh plugins, and agent skills
[positional-arguments]
upgrade *args: && _update-zsh-plugins _update-skills _update-claude-plugins
    {{ just_executable() }} -f {{ quote(source_file()) }} prune "$@"
    mise self-update
    mise upgrade --bump --interactive "$@"
    mise bootstrap packages upgrade -y "$@"

# Print the repo root (the justfile's resolved location)
dir:
    @echo {{ quote(repo_dir) }}

# Remove unused tool versions and undeclared Homebrew packages
[positional-arguments]
prune *args:
    mise prune "$@"
    mise bootstrap packages prune -m brew "$@"
    mise bootstrap packages prune -m brew-cask "$@"
    mise exec -- uv cache clean
    mise exec -- go clean -cache -testcache -modcache

# Link the dotfiles and set up the machine; arguments go to `mise bootstrap`
[positional-arguments]
bootstrap *args: && _install-zsh-plugins _install-skills _install-claude-plugins
    {{ mise_local }} dot apply
    mise bootstrap "$@"

zsh_config_dir := quote(env('ZDOTDIR', env('HOME')) / '.zsh')

# GitHub repos, each cloned into $ZDOTDIR/.zsh/<repo name>
zsh_plugins := '''
    Aloxaf/fzf-tab
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting
'''

# Clone plugins that aren't present yet
_install-zsh-plugins:
    for repo in {{ replace(zsh_plugins, "\n", " ") }}; do \
        dest={{ zsh_config_dir }}/"${repo#*/}"; \
        [ -d "$dest" ] || git clone "https://github.com/$repo.git" "$dest"; \
    done

# Pull every cloned plugin, including ones no longer listed
_update-zsh-plugins: _install-zsh-plugins
    find {{ zsh_config_dir }} -type d -mindepth 1 -maxdepth 1 -exec sh -c 'cd "{}" && git pull' \;

##################################################
# agent skills (installed from upstream by the `skills` CLI)
##################################################

# One <GitHub repo>:<skill name> per line
agent_skills := '''
    Dicklesworthstone/beads_rust:br
    vercel-labs/skills:find-skills
    github/awesome-copilot:github-issues
    mattpocock/skills:codebase-design
    mattpocock/skills:domain-modeling
    mattpocock/skills:grill-me
    mattpocock/skills:grill-with-docs
    mattpocock/skills:grilling
    mattpocock/skills:to-spec
    mattpocock/skills:improve-codebase-architecture
    softaworks/agent-toolkit:agent-md-refactor
    softaworks/agent-toolkit:commit-work
    softaworks/agent-toolkit:crafting-effective-readmes
    softaworks/agent-toolkit:dependency-updater
    softaworks/agent-toolkit:excalidraw
    softaworks/agent-toolkit:game-changing-features
    softaworks/agent-toolkit:lesson-learned
    softaworks/agent-toolkit:reducing-entropy
    softaworks/agent-toolkit:session-handoff
    softaworks/agent-toolkit:writing-clearly-and-concisely
    delorenj/skills:zellij-plugin-dev
    dashed/claude-marketplace:ai-friendly-cli
    dashed/claude-marketplace:comment-slop
    dashed/claude-marketplace:fd
    dashed/claude-marketplace:fzf
    dashed/claude-marketplace:git
    dashed/claude-marketplace:git-absorb
    dashed/claude-marketplace:jq
    dashed/claude-marketplace:kubernetes
    dashed/claude-marketplace:pytest
    dashed/claude-marketplace:python-complexity
    dashed/claude-marketplace:ripgrep
    dashed/claude-marketplace:ruff
    dashed/claude-marketplace:ty
    dashed/claude-marketplace:uv
    dashed/claude-marketplace:zellij
    thesmart/repo-copier:repo-copier
'''

# Install listed skills that aren't in the skills lock file yet
_install-skills:
    for entry in {{ replace(agent_skills, "\n", " ") }}; do \
        repo="${entry%%:*}" skill="${entry#*:}"; \
        mise exec -- jq -e --arg skill "$skill" '.skills | has($skill)' ~/.agents/.skill-lock.json >/dev/null 2>&1 \
            || mise exec -- skills add "$repo" -g -a claude-code -a zed -y --skill "$skill" \
            || exit; \
    done

# Update the named skills, or every installed skill
[positional-arguments]
_update-skills *skills:
    mise exec -- skills update -g "$@"

##################################################
# Claude Code plugins
##################################################

# One <GitHub repo>:<plugin>@<marketplace> per line
claude_plugins := '''
    ayghri/i-have-adhd:i-have-adhd@i-have-adhd
    DietrichGebert/ponytail:ponytail@ponytail
    jarrodwatts/claude-hud:claude-hud@claude-hud
    max-sixty/worktrunk:worktrunk@worktrunk
'''

# Add marketplaces and install listed plugins that aren't installed yet
_install-claude-plugins:
    for entry in {{ replace(claude_plugins, "\n", " ") }}; do \
        repo="${entry%%:*}" plugin="${entry#*:}"; \
        mise exec -- claude plugin list --json | mise exec -- jq -e --arg id "$plugin" 'any(.[]; .id == $id)' >/dev/null \
            || { mise exec -- claude plugin marketplace add "$repo" \
                && mise exec -- claude plugin install "$plugin"; } \
            || exit; \
    done

# Update every marketplace, then the listed plugins
_update-claude-plugins: _install-claude-plugins
    mise exec -- claude plugin marketplace update
    for entry in {{ replace(claude_plugins, "\n", " ") }}; do \
        mise exec -- claude plugin update "${entry#*:}" || exit; \
    done
