#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"
# shellcheck disable=SC1091
source conf/settings.conf
# shellcheck disable=SC1091
source scripts/common.sh

print_action "Fetching kernel"
scripts/fetch-kernel.sh

print_action "Entering kernel directory"
pushd "build/linux-${KERNEL_VERSION}"

print_action "Importing config to buildtree"
cp ../../conf/kernel.config .config
cp ../../conf/kernel.config .config.orig

print_action "Processing config"
make olddefconfig

print_action "Config differences"
diff --color=always .config.orig .config || true

print_action "Exporting config to repo"
cp .config ../../conf/kernel.config

popd # build/linux
popd # project

print_status "Config updated"
