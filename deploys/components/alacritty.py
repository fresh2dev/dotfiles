from deploys.utils import git_clone_or_pull, link, test_command

test_command("alacritty")

app_config_root = ".config/alacritty"

link(f"{app_config_root}/alacritty.toml")

git_clone_or_pull(
    src="https://github.com/alacritty/alacritty-theme.git",
    dest=f"{app_config_root}/themes",
    # branch="4091fddff8da892d5594e94116927c7445620867",
    # pull=False,
)
