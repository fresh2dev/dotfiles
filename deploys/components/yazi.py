from deploys.utils import link, test_command, git_clone_or_pull

test_command("yazi")

yazi_dir: str = ".config/yazi"

link(yazi_dir)

git_clone_or_pull(
    src="https://github.com/yazi-rs/plugins",
    dest=f"{yazi_dir}/plugins",
    pull=True,
)
