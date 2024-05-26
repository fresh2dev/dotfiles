#!/usr/bin/env bash

[ -d /tmp/nerd-fonts ] || git clone --depth=1 https://www.github.com/ryanoasis/nerd-fonts.git /tmp/nerd-fonts

/tmp/nerd-fonts/install.sh \
  FiraCode \
  FiraMono \
  Go-Mono \
  Hack \
  IBMPlexMono \
  IntelOneMono \
  JetBrainsMono \
  RobotoMono \
  SourceCodePro \
  Ubuntu \
  UbuntuMono \
  iA-Writer
