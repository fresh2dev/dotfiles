from deploys.utils import link, test_command

test_command("vim", "nvim")

link(".vimrc")
link(".vim/vimrc.d")

link(".config/nvim")
