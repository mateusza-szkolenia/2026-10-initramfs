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

KERNEL_FILE="kernel-${RELEASE}"
INITRD_FILE="initrd-${RELEASE}.$ext"
TARBALL="$NAME-$RELEASE.tar"

print_action "Creating tarball"
tar --owner=0 --group=0 -cf "$TARBALL" -C . "$KERNEL_FILE" "$INITRD_FILE"

print_action "Exporting to dist/"
cp "$TARBALL" ../dist

popd # build
popd # project

print_status "Tarball ready"
