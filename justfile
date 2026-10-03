# The repo root. This justfile is usually run through a symlink, where `source_directory()`
# is the symlink's directory, not the repo.
repo_dir := parent_directory(canonicalize(source_file()))

# `mise` that reads only this repo's `mise.toml` (the bootstrap layer)
mise_local := "MISE_CONFIG_DIR=" + quote(repo_dir) + " mise"

# The global mise config dir. An inherited $MISE_CONFIG_DIR is ignored: during setup it
# points at this repo.
mise_config_dir := env('XDG_CONFIG_HOME', env('HOME') / '.config') / 'mise'

# `mise` that reads only the global config, run from ~ so no project config is picked up
mise_global := "MISE_CONFIG_DIR=" + quote(mise_config_dir) + " mise -C " + quote(env('HOME'))

# Run a tool from the global config, installing it first if needed
mise_exec := mise_global + " exec --"

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

# Format the repo with treefmt
[positional-arguments]
format *args:
    cd {{ quote(repo_dir) }} && treefmt "$@"

alias fmt := format

# Arguments reach every `mise` step except `self-update`, which has no `--dry-run`.
# Upgrade mise, tools, packages, zsh plugins, and agent skills
[positional-arguments]
upgrade *args: && _update-zsh-plugins _update-skills
    {{ just_executable() }} -f {{ quote(source_file()) }} prune "$@"
    {{ mise_global }} self-update
    {{ mise_global }} upgrade --bump --interactive "$@"
    {{ mise_global }} bootstrap packages upgrade -y "$@"

# Print the repo root (the justfile's resolved location)
dir:
    @echo {{ quote(repo_dir) }}

# Remove unused tool versions and undeclared Homebrew packages
[positional-arguments]
prune *args:
    {{ mise_global }} prune "$@"
    {{ mise_global }} bootstrap packages prune -m brew "$@"
    {{ mise_global }} bootstrap packages prune -m brew-cask "$@"

# Link the dotfiles and set up the machine; arguments go to `mise bootstrap`
[positional-arguments]
install *args: && _install-zsh-plugins _install-skills
    {{ mise_local }} dot apply
    {{ mise_global }} bootstrap "$@"

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
    ayghri/i-have-adhd:i-have-adhd
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
'''

# Install listed skills that aren't in the skills lock file yet
_install-skills:
    for entry in {{ replace(agent_skills, "\n", " ") }}; do \
        repo="${entry%%:*}" skill="${entry#*:}"; \
        {{ mise_exec }} jq -e --arg skill "$skill" '.skills | has($skill)' ~/.agents/.skill-lock.json >/dev/null 2>&1 \
            || {{ mise_exec }} skills add "$repo" -g -a claude-code -a zed -y --skill "$skill" \
            || exit; \
    done

# Update the named skills, or every installed skill
[positional-arguments]
_update-skills *skills:
    {{ mise_exec }} skills update -g "$@"
