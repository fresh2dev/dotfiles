from pyinfra import host
from pyinfra.facts.files import File
from pyinfra.facts.server import Home
from pyinfra.operations import files, server

from deploys.utils import link, test_command

link(".ssh/config", is_secret=True)

dest_file: str = f"{host.get_fact(Home)}/.ssh/id_ed25519"

if not host.get_fact(File, dest_file):
    server.shell([f'ssh-keygen -t ed25519 -q -f "{dest_file}" -N ""'])
