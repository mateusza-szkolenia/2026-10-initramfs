#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."
pushd "$PROJECTROOT"

# shellcheck disable=SC1091
source conf/settings.conf
# shellcheck disable=SC1091
source scripts/common.sh

print_section "Dependencies"
scripts/preinstall-dependencies.sh

print_section "Busybox"
scripts/build-busybox.sh

#print_section "Kernel"
#scripts/build-kernel.sh

print_section "Import kernel"
scripts/import-kernel.sh

print_section "RootFS"
scripts/build-rootfs.sh

print_section "Initramfs"
scripts/build-initramfs.sh

#print_section "Ukify (EFI)"
#scripts/build-efi.sh

#print_section "GPT Image"
#scripts/build-img.sh

#print_section "ISO Image"
#scripts/build-iso.sh

#print_section "Tarball"
#scripts/build-tarball.sh

popd

print_status "All done"
