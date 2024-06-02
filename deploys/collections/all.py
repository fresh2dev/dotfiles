from pathlib import Path
from typing import List

from pyinfra import local

component_dir: Path = Path("deploys") / "components"

prereq_components: List[Path] = [component_dir / "eget.py"]

components: List[Path] = [
    x for x in component_dir.glob("*.py") if x not in prereq_components
]

for component in prereq_components:
    local.include(str(component))

for component in components:
    local.include(str(component))
