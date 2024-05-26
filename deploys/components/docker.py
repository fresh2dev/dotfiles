from deploys.utils import link, link_directory_contents, test_command

test_command("docker", "helm")

link_directory_contents(".docker", is_secret=True)

link(
    ".docker/config.json",
    ".config/helm/registry/config.json",
    is_secret=True,
)
