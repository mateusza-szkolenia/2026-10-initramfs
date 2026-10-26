#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"
# shellcheck source=/dev/null
source conf/settings.conf

# shellcheck source=/dev/null
source scripts/common.sh

pushd build

ISOROOT="isoroot-$RELEASE"

rm -rf "$ISOROOT"

mkdir -p "$ISOROOT"
pushd "$ISOROOT"

print_action "Creating isoroot structure"
mkdir -p isolinux boot

print_action "Importing isolinux modules"
cp /usr/lib/ISOLINUX/isolinux.bin isolinux/
cp /usr/lib/syslinux/modules/bios/{ldlinux,libcom32,libutil,libmenu,libgpl,vesamenu}.c32 isolinux/

print_action "Importing background image"
cp "../../base/syslinux/bg.png" isolinux/

print_action "Importing kernel + initrd"
case "$INITRD_COMPRESS" in
    zstd) ext=zst ;;
    xz) ext=xz ;;
    *) false ;;
esac
cp ../kernel-"${RELEASE}" ./boot
cp "../initrd-${RELEASE}.$ext" ./boot

print_action "Creating isolinux.cfg"
cat > isolinux/isolinux.cfg <<EOF
UI vesamenu.c32

MENU BACKGROUND bg.png

MENU COLOR title 1;33;40 #ffff8000 #00000000 std
MENU COLOR unsel 30;47   #ff000000 #40ffffff std
MENU COLOR sel   7;30;43 #ff000000 #80ff8000 all
MENU COLOR tabmsg 1;34;47 #ff00008b #40ffffff std

PROMPT 0
TIMEOUT 100
MENU TITLE $NAME

LABEL $NAME
    MENU LABEL $NAME $RELEASE
    KERNEL /boot/kernel-$RELEASE
    APPEND initrd=/boot/initrd-$RELEASE.$ext console=tty0 bootsrc=iso
EOF

popd # isoroot

print_action "Creating ESP partition"
mkdir -p "$ISOROOT/boot"
dd if="$NAME-$RELEASE.img" of="$ISOROOT/boot/$NAME-$RELEASE.esp" bs=1M skip=1

print_action "Creating iso"
xorriso -as mkisofs \
  -o "$NAME-$RELEASE.iso" \
  -V "$NAME" \
  -J -joliet-long \
  -rational-rock \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
  -partition_cyl_align off \
  -c isolinux/boot.cat \
  -b isolinux/isolinux.bin \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot \
  -e "boot/$NAME-$RELEASE.esp" \
    -no-emul-boot -boot-load-size 8192 \
  "$ISOROOT"

print_action "Exporting to dist/"
cp "$NAME-$RELEASE.iso" ../dist

popd # build
popd # project

print_status "ISO ready"
