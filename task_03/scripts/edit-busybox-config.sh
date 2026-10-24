#!/bin/bash

set -e

WHAT=busybox

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"
# shellcheck disable=SC1091
source conf/settings.conf
# shellcheck disable=SC1091
source scripts/common.sh

print_action "Fetching ${WHAT}"
scripts/fetch-busybox.sh

print_action "Entering ${WHAT} directory"
pushd "build/${WHAT}-${BUSYBOX_VERSION}"

print_action "Importing config to buildtree"
cp ../../conf/${WHAT}.config .config
cp ../../conf/${WHAT}.config .config.orig

print_action "Editing config with menu"
make menuconfig

print_action "Config differences"
diff --color=always .config.orig .config || true

print_action "Exporting config to repo"
cp .config "../../conf/${WHAT}.config"

popd # build/busybox
popd # project

print_status "Config updated"
