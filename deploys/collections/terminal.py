from pyinfra import local

for component in [
    "alacritty",
    "atuin",
    "bash",
    "bat",
    "devbox",
    "direnv",
    "fd",
    "git",
    "ripgrep",
    "starship",
    "vim",
    "zellij",
    "zsh",
]:
    local.include(f"deploys/components/{component}.py")
