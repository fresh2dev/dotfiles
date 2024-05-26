from deploys.utils import link_directory_contents, test_command

test_command("kubectl")

link_directory_contents(".kube", is_secret=True)
