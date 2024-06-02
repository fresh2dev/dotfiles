from deploys.utils import git_clone_or_pull, link, test_command
from pyinfra import host
from pyinfra.facts.server import Home, Kernel

test_command("mods")

mods_dir: str = ".config/mods"

link(f"{mods_dir}/mods.yml")

git_clone_or_pull(
    src="https://github.com/danielmiessler/fabric",
    dest=f"{mods_dir}/fabric",
    pull=True,
)

if host.get_fact(Kernel).lower() == "darwin":
    link(
        f"{mods_dir}/mods.yml",
        f"{host.get_fact(Home)}/Library/Application Support/mods/mods.yml",
    )
