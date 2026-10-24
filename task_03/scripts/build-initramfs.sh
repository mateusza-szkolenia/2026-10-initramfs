#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"
# shellcheck source=/dev/null
source conf/settings.conf
# shellcheck source=/dev/null
source scripts/common.sh

pushd build

INITRAMFS="initramfs-$RELEASE"
INITRD="initrd-$RELEASE"
ROOTFS="rootfs-$RELEASE"

print_action "Removing old initramfs"
rm -rf "$INITRAMFS"

print_action "Creating initramfs directory"
mkdir -p "$INITRAMFS"

print_action "Importing initramfs skeleton"
cp -r ../base/initramfs/* "./$INITRAMFS/"

pushd "$INITRAMFS"

print_action "Importing rootfs and busybox"
# cp "../$ROOTFS.squashfs" ./rootfs.squashfs
cp "../$ROOTFS.tar" ./rootfs.tar
mkdir -p bin
cp ../busybox-"$RELEASE" ./bin/busybox

print_action "Writing version information"
echo "$RELEASE" > "etc/${NAME}_initrd_release"

print_action "Aliasing sh to busybox"
pushd bin
ln -s busybox sh
popd # bin

print_action "Cleaning up .empty placeholders"
find . -name '.empty' -exec rm {} ';'

print_action "Packing with cpio"
find . | cpio --owner=0:0 -H newc -o > "../$INITRD"

popd # initramfs

print_action "Compressing with $INITRD_COMPRESS"
case "$INITRD_COMPRESS" in
    zstd) true ;;
    xz) true ;;
    *) false ;;
esac

"$INITRD_COMPRESS" --keep --force "./$INITRD"

print_action "Listing result"
cpio -vit < "./$INITRD"
ls -l ./initrd*

popd # build
popd # project

print_status "Initramfs ready"
