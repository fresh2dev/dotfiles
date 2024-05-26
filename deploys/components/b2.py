from deploys.utils import link, test_command

test_command("b2")

link(".b2_account_info", is_secret=True)
