if [ -f ~/.profile ]; then
  emulate sh
  . ~/.profile
  emulate zsh
fi
