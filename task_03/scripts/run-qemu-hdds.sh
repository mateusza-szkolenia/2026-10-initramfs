#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"

# shellcheck source=/dev/null
source conf/settings.conf

kernel="build/kernel-${RELEASE}"
initrd="build/initrd-${RELEASE}.zst"

truncate -s 100G cache/sda.ima
truncate -s 100G cache/sdb.ima
truncate -s 20G cache/sdc.ima
truncate -s 10G cache/sdd.ima

qemu-system-x86_64 \
    -kernel "$kernel" \
    -initrd "$initrd" \
    -drive file=cache/sda.ima,format=raw,if=ide \
    -drive file=cache/sdb.ima,format=raw,if=ide \
    -drive file=cache/sdc.ima,format=raw,if=ide \
    -drive file=cache/sdd.ima,format=raw,if=ide \
    -m 8000

popd
