# Dotfiles

This is my personal collection of dotfiles. It contains curated configs for `vim`, `neovim`, `zsh`, `git`, `zellij`, and more. I primarily focus on Kubernetes and Python development on a Linux workstation (Debian-based distros and Fedora Silverblue).

I am proud of the dotfiles themselves, and the method I use to deploy them.

The project tree, explained:

```tree
.
├── deploys/
│   ├── collections/  // Contains logic used to setup collections of components.
│   │   ├── all.py
│   │   ├── server.py
│   │   └── terminal.py
│   ├── components/   // Contains logic used to setup specific components.
│   │   ├── alacritty.py
│   │   ├── ansible.py
│   │   ├── atuin.py
│   │   ├── bash.py
│   │   ├── docker.py
│   │   ├── git.py
│   │   ├── vim.py
│   │   ├── zellij.py
│   │   ├── zsh.py
│   │   └── ...
│   └── utils/     // Contains functions used in `pyinfra` deploy scripts.
│       └── ...
├── home/          // Public configs live here.
│   └── ...
├── home-secrets/  // Private configs live here.
│   └── ...
└── scripts/       // Here be undocumented dragons (namely, install scripts).
│   └── ...
```

My dotfiles deployment method introduces the concept of "components" and "collections". *Components* are the building blocks for *Collections.* *Components* are configs for specific programs (`zsh`, `vim`, etc.), where *Collections* are independent, whole sets of configurations ("all", "terminal"). You can confidently apply entire *collections*, but if you selectively apply only specific *components*, you may run into issues with missing dependencies.

You can apply them to your local workstation, or to a remote server.

When applying to the local workstation, configs from the local `./home/` directory are ***symlinked*** to your `$HOME` directory.

When applying to a remote workstation over SSH, configs from the local `./home/` directory are ***mirrored*** to the `$HOME` directory of the remote user.

> Note: this repo contains configuration files ("dotiles") for various programs. It does not take care of installing the programs -- only the configuration files.

The deployment mechanism is powered by [pyinfra](https://github.com/pyinfra-dev/pyinfra).

> For managing my dotfiles, I tried each of shell scripts, ansible, and dotbot before settling on *pyinfra*. I am most happy with pyinfra.

Install `pyinfra` with [`pipx`](https://github.com/pypa/pipx):

```sh
$ pipx install pyinfra
```

Apply configs to the local workstation:

```sh
# Apply Collections:
$ pyinfra @local deploys/collections/all.py
$ pyinfra @local deploys/collections/terminal.py

# Apply Components:
$ pyinfra @local deploys/components/vim.py
```

Or apply to a remote SSH server:

```sh
$ pyinfra @ssh/192.168.1.123 --user <username> deploys/collections/server.py
```
