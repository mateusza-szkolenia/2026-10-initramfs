#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")"

pushd "$PROJECTROOT/output"

qemu-system-x86_64 \
    -kernel "kernel" \
    -initrd "initrd" \
    -m 1000

popd
