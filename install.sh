#!/bin/sh
#
# DESCRIPTION
# Very simple script to 'install' this ugly and beautiful coco manager

CONFIG_DIR="${HOME}/.config/coco-settings-manager"
BIN_DIR="${HOME}/.local/bin"

# Create config folder
echo "Install coco-settings-manager"
mkdir -v $CONFIG_DIR

# Place script executable path
echo "Place scripts in ${BIN_DIR} (Add it in path if not)"

ln -fsv "${PWD}/scripts/settings-check.sh"  "${BIN_DIR}/coco-settings-check"
ln -fsv "${PWD}/scripts/settings-gen.sh"    "${BIN_DIR}/coco-settings-gen"

echo "coco-settings-manager installed"
