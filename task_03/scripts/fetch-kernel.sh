#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"
# shellcheck disable=SC1091
source conf/settings.conf
# shellcheck disable=SC1091
source scripts/common.sh

KERNEL_FN="linux-${KERNEL_VERSION}.tar.xz"

pushd cache

print_action "Downloading sources"
if ! [[ -e "$KERNEL_FN" ]]
then
    [[ $KERNEL_VERSION =~ ^([0-9]+)\. ]]
    major="${BASH_REMATCH[1]}"
    wget "https://cdn.kernel.org/pub/linux/kernel/v${major}.x/${KERNEL_FN}" -O "${KERNEL_FN}.part"
    mv "${KERNEL_FN}.part" "$KERNEL_FN"
fi
popd # cache

pushd build

print_action "Extracting sources"
tar xf "../cache/${KERNEL_FN}"

popd # build
popd # project

print_status "Kernel fetched and extracted"
