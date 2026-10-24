#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"

# shellcheck source=/dev/null
source conf/settings.conf

kernel="build/kernel-${RELEASE}"
initrd="build/initrd-${RELEASE}.zst"

qemu-system-x86_64 \
    -kernel "$kernel" \
    -initrd "$initrd" \
    -m 2000

popd
