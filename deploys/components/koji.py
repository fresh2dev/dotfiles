from deploys.utils import link, test_command

test_command("koji")

link(".config/koji/config.toml")
