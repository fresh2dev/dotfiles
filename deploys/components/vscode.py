from pyinfra import host
from pyinfra.facts.server import Home, Kernel

from deploys.utils import link, link_directory_contents, test_command

config_dir: str = (
    f"Library/Application Support"
    if host.get_fact(Kernel).lower() == "darwin"
    else ".config"
)

link_directory_contents(".config/Code", f"{config_dir}/Code")
link(".vim/snippets", f"{config_dir}/Code/User/snippets")

link_directory_contents(".config/Code", f"{config_dir}/VSCodium")
link(".vim/snippets", f"{config_dir}/VSCodium/User/snippets")
