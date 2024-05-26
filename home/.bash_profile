# .bash_profile

if [ -f ~/.profile ]; then
  . ~/.profile
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# User specific environment and startup programs

if [ -e /home/d/.nix-profile/etc/profile.d/nix.sh ]; then . /home/d/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
