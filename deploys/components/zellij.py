from pathlib import Path

from pyinfra import host
from pyinfra.facts.server import Home
from pyinfra.operations import files

from deploys.utils import link, test_command

test_command("zellij")

link(".config/zellij")

dest_dir: Path = Path(f"{host.get_fact(Home)}/.config/zellij/plugins")

dest_dir.mkdir(exist_ok=True)

for url in (
    "https://github.com/dj95/zjstatus/releases/download/v0.20.2/zjstatus.wasm",
    "https://github.com/dj95/zjstatus/releases/download/v0.20.2/zjframes.wasm",
    "https://github.com/karimould/zellij-forgot/releases/download/0.4.1/zellij_forgot.wasm",
    "https://github.com/rvcas/room/releases/download/v1.2.0/room.wasm",
    # "https://github.com/fresh2dev/zellij-autolock/releases/download/0.1.0/zellij-autolock.wasm",
):
    files.download(url, str(dest_dir / Path(url).name), force=False)
