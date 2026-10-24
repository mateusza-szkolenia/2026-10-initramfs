#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"
# shellcheck source=/dev/null
source conf/settings.conf
# shellcheck source=/dev/null
source scripts/common.sh

pushd build

print_action "Estimating image size"
size=$(stat -c "%s" "$NAME-$RELEASE.efi")
(( imgsize = size / 1024 / 1024 + 8 ))

print_action "Create GPT image"
truncate -s "${imgsize}M" "$NAME-$RELEASE.img"

print_action "Partition GPT image"
parted -s "$NAME-$RELEASE.img" \
    mklabel gpt \
    mkpart ESP fat32 1MiB '100%' \
    set 1 esp on

print_action "Formating ESP partition"
mformat -i "$NAME-$RELEASE.img"@@1M -F -v ESP

print_action "Creating directory"
mmd -i "$NAME-$RELEASE.img"@@1M ::/EFI ::/EFI/BOOT

print_action "Importing EFI file"
mcopy -i "$NAME-$RELEASE.img"@@1M "$NAME-$RELEASE.efi" ::/EFI/BOOT/BOOTX64.EFI

print_action "Converting to VDI"
qemu-img convert -f raw "$NAME-$RELEASE.img" -O vdi "$NAME-$RELEASE.vdi"

print_action "Exporting to dist/"
cp "$NAME-$RELEASE.img" ../dist
cp "$NAME-$RELEASE.vdi" ../dist

popd # build
popd # project

print_status "GPT Image ready"
