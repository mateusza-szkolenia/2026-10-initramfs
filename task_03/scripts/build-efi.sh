#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"
# shellcheck source=/dev/null
source conf/settings.conf
# shellcheck source=/dev/null
source scripts/common.sh

pushd build

case "$INITRD_COMPRESS" in
    zstd) ext=zst ;;
    xz) ext=xz ;;
    *) false ;;
esac

print_action "Building EFI with Ukify"
ukify build \
    --linux=kernel-"${RELEASE}" \
    --initrd=initrd-"${RELEASE}.${ext}" \
    --cmdline="console=tty0" \
    --output="$NAME-$RELEASE.efi"

print_action "Exporting to dist/"
cp "$NAME-$RELEASE.efi" ../dist/

popd # build
popd # project

print_status "EFI ready"
