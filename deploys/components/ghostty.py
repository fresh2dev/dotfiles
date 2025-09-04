from pyinfra import host
from pyinfra.facts.server import Home, Kernel

from deploys.utils import link, test_command

test_command("ghostty")

ghostty_dir: str = ".config/ghostty"

link(ghostty_dir)

if host.get_fact(Kernel).lower() == "darwin":
    link(
        ghostty_dir,
        f"{host.get_fact(Home)}/Library/Application Support/com.mitchellh.ghostty",
    )
