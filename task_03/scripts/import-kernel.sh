#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"
# shellcheck disable=SC1091
source conf/settings.conf
# shellcheck disable=SC1091
source scripts/common.sh

print_action "Installing kernel package"
apt-get install --yes linux-image-amd64

print_action "Detecting available kernel"
kernel=(/boot/vmlinuz*)
modules=(/lib/modules/*)
echo "Kernel: $kernel"
echo "Modules: $modules"

print_action "Exporting kernel"
cp "$kernel" "build/kernel-${RELEASE}"

print_action "Exporting modules"
mkdir -p "build/modules-$RELEASE/lib/modules/"
cp -r "$modules" "build/modules-$RELEASE/lib/modules/"

popd # project

print_status "Kernel exported from system package"
