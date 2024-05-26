from deploys.utils import link_directory_contents, test_command

test_command("faas-cli")

link_directory_contents(".openfaas", is_secret=True)
