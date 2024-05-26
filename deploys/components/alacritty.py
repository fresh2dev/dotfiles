from deploys.utils import git_clone_or_pull, link, test_command

test_command("alacritty")

app_config_root = ".config/alacritty"

git_clone_or_pull(
    src="https://github.com/alacritty/alacritty-theme.git",
    dest=f"{app_config_root}/themes",
    branch="94e1dc0b9511969a426208fbba24bd7448493785",
    pull=False,
)

link(f"{app_config_root}/alacritty.toml")
