from uuid import uuid4

from pyinfra import host
from pyinfra.facts.server import Arch, Home, Kernel
from pyinfra.operations import files, server

from deploys.utils import link, test_command

EGET_VERSION: str = "1.3.4"

os_type: str = host.get_fact(Kernel).lower()
os_arch: str = host.get_fact(Arch).lower()

test_command("tar")

if os_type not in ("linux", "darwin"):
    raise RuntimeWarning(f"Unsupported OS: {os_type}")

if os_arch == "x86_64":
    os_arch = "amd64"
elif "arm" in os_arch:
    os_arch = "arm64"
else:
    raise RuntimeWarning(f"Unsupported CPU architecture: {os_arch}")

file_name: str = "eget"
download_file: str = f"/tmp/{file_name}.tgz"
stage_dir: str = f"/tmp/{uuid4()}"
stage_file: str = f"{stage_dir}/eget-{EGET_VERSION}-{os_type}_{os_arch}/{file_name}"
dest_dir: str = f"{host.get_fact(Home)}/.local/bin"
dest_file: str = f"{dest_dir}/{file_name}"

for d in (stage_dir, dest_dir):
    files.directory(d, present=True)

files.download(
    f"https://github.com/zyedidia/eget/releases/download/v{EGET_VERSION}/eget-{EGET_VERSION}-{os_type}_{os_arch}.tar.gz",
    download_file,
)

server.shell(
    [
        f"tar -xzf {download_file} -C {stage_dir}",
        f"mv {stage_file} {dest_file}",
    ]
)

files.file(download_file, present=False)
files.directory(stage_dir, present=False)

link(".config/eget")

# TODO: enable this when we're able to perform a
# non-interactive execution across platforms.
# server.shell("eget --download-all")
