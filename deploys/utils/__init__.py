from contextlib import suppress
from pathlib import Path
from typing import Union

from pyinfra import host
from pyinfra.facts.files import File
from pyinfra.facts.server import Home, Which
from pyinfra.operations import files, git

CONFIGS_ROOT = Path.cwd() / "home"
CONFIGS_ROOT_SECRET = Path.cwd() / "home-secrets"


def test_command(*args: str) -> None:
    for x in args:
        if not host.get_fact(Which, x):
            pass


def _derive_destination_path(src: Union[str, Path], is_secret: bool = False) -> Path:
    src = Path(src)
    with suppress(ValueError):
        src = src.relative_to(CONFIGS_ROOT_SECRET if is_secret else CONFIGS_ROOT)
    return Path(host.get_fact(Home)) / src


def git_clone_or_pull(dest: Union[str, Path], pull: bool = False, **kwargs) -> None:
    git.repo(dest=str(_derive_destination_path(dest)), pull=pull, **kwargs)


def _link(
    src: Union[str, Path],
    tgt: Union[None, str, Path] = None,
    is_secret: bool = False,
) -> None:
    src = Path(src)
    assert src.exists()
    assert not src.is_symlink()

    tgt = _derive_destination_path(tgt if tgt else src, is_secret=is_secret)
    assert not tgt.exists() or tgt.is_symlink() or not tgt.samefile(src)

    if host.get_fact(File, str(src)) is None:
        if src.is_dir():
            files.sync(
                src=str(src),
                dest=str(tgt),
                delete=True,
                add_deploy_dir=False,
            )
        else:
            files.put(
                src=str(src),
                dest=str(tgt),
                mode=True,
                add_deploy_dir=False,
                create_remote_dir=True,
                # force=True,
            )
    else:
        files.link(
            path=str(tgt),
            target=str(src),
            force=True,
            force_backup=False,
        )


def link(
    src: Union[str, Path],
    tgt: Union[None, str, Path] = None,
    is_secret: bool = False,
) -> None:
    src = (CONFIGS_ROOT_SECRET if is_secret else CONFIGS_ROOT) / src
    assert src.exists()
    if src.is_dir():
        link_directory(src, tgt=tgt, is_secret=is_secret)
    else:
        link_file(src, tgt=tgt, is_secret=is_secret)


def link_directory(
    src: Union[str, Path],
    tgt: Union[None, str, Path] = None,
    is_secret: bool = False,
) -> None:
    src = (CONFIGS_ROOT_SECRET if is_secret else CONFIGS_ROOT) / src
    assert src.is_dir()
    _link(src, tgt=tgt, is_secret=is_secret)


def link_file(
    src: Union[str, Path],
    tgt: Union[None, str, Path] = None,
    is_secret: bool = False,
) -> None:
    src = (CONFIGS_ROOT_SECRET if is_secret else CONFIGS_ROOT) / src
    assert src.is_file()
    _link(src, tgt=tgt, is_secret=is_secret)


def link_directory_contents(
    src: Union[str, Path],
    tgt: Union[None, str, Path] = None,
    is_secret: bool = False,
) -> None:
    src = (CONFIGS_ROOT_SECRET if is_secret else CONFIGS_ROOT) / src
    assert src.is_dir()

    configs = [x for x in src.rglob("*") if x.is_file()]

    assert configs

    for x in configs:
        _link(
            x,
            tgt=Path(tgt) / x.name if tgt else None,
            is_secret=is_secret,
        )
