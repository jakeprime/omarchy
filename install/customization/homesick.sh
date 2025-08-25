#!/bin/bash

MISE_SHIMS=~/.local/share/mise/shims

# We'll need ruby to install Homesick, so make sure we have it
$MISE_SHIMS/ruby -v 2>/dev/null || mise install ruby@latest && mise use -g ruby

$MISE_SHIMS/gem install homesick

$MISE_SHIMS/homesick clone https://github.com/jakeprime/dotfiles arch
pushd ~/.homesick/repos/arch && git checkout arch && popd

$MISE_SHIMS/homesick link arch --force
