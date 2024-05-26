from deploys.utils import link, test_command

test_command("python", "pip")

link(".config/pip")

link(".pypirc", is_secret=True)
