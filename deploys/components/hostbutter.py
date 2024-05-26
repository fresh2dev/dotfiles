from deploys.utils import link, test_command

test_command("butter")

link(".config/hostbutter", is_secret=True)
