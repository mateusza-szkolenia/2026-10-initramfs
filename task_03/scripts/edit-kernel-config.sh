#!/bin/bash

set -e

WHAT=kernel

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"
# shellcheck disable=SC1091
source conf/settings.conf
# shellcheck disable=SC1091
source scripts/common.sh

print_action "Fetching ${WHAT}"
scripts/fetch-kernel.sh

print_action "Entering ${WHAT} directory"
pushd "build/linux-${KERNEL_VERSION}"

print_action "Importing config to buildtree"
cp ../../conf/${WHAT}.config .config
cp ../../conf/${WHAT}.config .config.orig

print_action "Editing config with menu"
make menuconfig

print_action "Config differences"
diff --color=always .config.orig .config || true

print_action "Exporting config to repo"
cp .config "../../conf/${WHAT}.config"

popd # build/linux
popd # project

print_status "Config updated"
