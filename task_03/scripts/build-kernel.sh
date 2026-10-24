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

print_action "Entering build directory"
pushd "build/linux-${KERNEL_VERSION}"

print_action "Importing config"
cp ../../conf/kernel.config .config
cp ../../conf/kernel.config .config.orig

print_action "Processing config"
make olddefconfig

print_action "Config differences"
diff --color=always .config.orig .config || true

print_action "Local configuration"
scripts/config --set-str CONFIG_LOCALVERSION "$KERNEL_LOCALVERSION"
scripts/config --set-str CONFIG_DEFAULT_HOSTNAME "$DEFAULT_HOSTNAME"
diff --color=always ../../conf/kernel.config .config || true

print_action "Make"
export KCFLAGS="-march=x86-64 -mtune=generic"
make -j"$(nproc)"

print_action "Make modules"
make -j"$(nproc)" modules

print_action "Exporting kernel"
cp arch/x86/boot/bzImage "../kernel-${RELEASE}"

print_action "Exporting modules"
mkdir -p "../modules-$RELEASE"
make modules_install INSTALL_MOD_PATH="../modules-$RELEASE"

popd # build/linux-x.x.x
popd # project

print_status "Kernel ready"