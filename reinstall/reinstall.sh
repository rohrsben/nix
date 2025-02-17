#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
    echo "Must be run as root."
    exit
fi

nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest -- -m disko ../machines/shared/disko/autherror.nix && nixos-install --flake github:rohrsben/nix#minimal && systemctl reboot
