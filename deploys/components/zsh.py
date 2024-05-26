from deploys.utils import git_clone_or_pull, link

app_config_root = ".zsh"

git_clone_or_pull(
    src="https://www.github.com/zsh-users/zsh-autosuggestions.git",
    dest=f"{app_config_root}/zsh-autosuggestions",
    branch="c3d4e576c9c86eac62884bd47c01f6faed043fc5",
    pull=False,
)

git_clone_or_pull(
    src="https://github.com/jeffreytse/zsh-vi-mode.git",
    dest=f"{app_config_root}/zsh-vi-mode",
    branch="287efa19ec492b2f24bb93d1f4eaac3049743a63",
    pull=False,
)

git_clone_or_pull(
    src="https://www.github.com/Aloxaf/fzf-tab.git",
    dest=f"{app_config_root}/fzf-tab",
    branch="c7fb028ec0bbc1056c51508602dbd61b0f475ac3",
    pull=False,
)

link(".profile")

link(".zprofile")

link(".zshrc")

link(".zshenv", is_secret=True)
