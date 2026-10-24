#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"

# shellcheck source=/dev/null
source conf/settings.conf

iso=dist/"$NAME-$RELEASE".iso

qemu-system-x86_64 \
  -drive file="$iso",media=cdrom,readonly=on \
  -boot order=d \
  -m 16000 \
  -smp 8

popd
