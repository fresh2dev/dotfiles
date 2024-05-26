from pathlib import Path

from pyinfra import local

for component in (Path("deploys") / "components").glob("*.py"):
    local.include(str(component))
