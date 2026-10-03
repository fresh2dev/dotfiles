# Login shells activate mise here rather than in .zshenv: /etc/zprofile (macOS
# path_helper) runs in between and would move the system dirs back in front of mise's
# tools and `_.path`. This runs before .zshrc, so its setup sees the final PATH.
eval "$(~/.local/bin/mise activate zsh)"
