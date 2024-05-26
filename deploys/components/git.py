from deploys.utils import link, test_command

test_command("git", "git-cliff")

link(".config/git-cliff")

link(".gitconfig")

link(".gitmailmap", is_secret=True)
link(".local/bin/git", is_secret=True)
