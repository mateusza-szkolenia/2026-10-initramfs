#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."
pushd "$PROJECTROOT"

# shellcheck disable=SC1091
source conf/settings.conf
# shellcheck disable=SC1091
source scripts/common.sh

print_action "Fetching busybox"
scripts/fetch-busybox.sh

print_action "Entering build directory"
pushd "build/busybox-${BUSYBOX_VERSION}"

if [ -e ../busybox-"$RELEASE" ]
then
    print_status "Busybox already built. Skipping"
    ls -l ../busybox-"$RELEASE"
    exit 0
fi

print_action "Importing config"
cp ../../conf/busybox.config .config
cp ../../conf/busybox.config .config.orig

print_action "Processing config"
make oldconfig

print_action "Config differences"
diff --color=always .config.orig .config || true

print_action "Make"
make -j"$(nproc)"

print_action "Result"
cp ./busybox ../busybox-"$RELEASE"
ls -l ../busybox-"$RELEASE"

popd # build/busybox-x.x.x
popd # project

print_status "Busybox ready"
