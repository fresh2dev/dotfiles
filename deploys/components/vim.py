from deploys.utils import link, test_command

test_command("vim", "nvim")

link(".vimrc")
link(".vim/vimrc.d")
link(".vim/snippets")

link(".config/nvim")

link(".scratch.md", is_secret=True)
