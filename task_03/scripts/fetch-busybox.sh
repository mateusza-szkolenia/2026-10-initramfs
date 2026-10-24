#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"
# shellcheck disable=SC1091
source conf/settings.conf
# shellcheck disable=SC1091
source scripts/common.sh

BB_FN="busybox-${BUSYBOX_VERSION}.tar.bz2"

pushd cache

print_action "Downloading sources"
if ! [[ -e "$BB_FN" ]]
then
    wget "https://busybox.net/downloads/${BB_FN}" -O "${BB_FN}.part"
    mv "${BB_FN}.part" "$BB_FN"
fi
popd # cache

pushd build

print_action "Extracting sources"
tar xf "../cache/${BB_FN}"

popd # build
popd # project

print_status "Busybox fetched and extracted"
