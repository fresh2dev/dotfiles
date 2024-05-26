from deploys.utils import link, link_directory_contents, test_command

test_command("act")

link(".config/act/actrc")

link_directory_contents(".config/act", is_secret=True)
