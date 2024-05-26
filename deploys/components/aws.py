from deploys.utils import link, test_command

test_command("aws")

link(".aws", is_secret=True)
