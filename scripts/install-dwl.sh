#!/bin/sh
set -e

printf "sudo or doas? > "
read -r TOOL

deps="git make gcc pkgconf wayland-protocols wlroots0.19 libinput libxkbcommon fcft tllist grim slurp wl-clipboard xorg-xwayland xcb-util-wm terminus-font ttf-terminus-nerd wmenu awww"

$TOOL pacman -S --needed --noconfirm $deps

git clone https://github.com/larpingston/dwl dwl
cd dwl && $TOOL make clean install && cd ..

git clone https://github.com/sahaj-b/wayvibes.git wayvibes
cd wayvibes && $TOOL make clean install && cd ..
