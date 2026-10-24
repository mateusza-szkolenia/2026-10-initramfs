#!/bin/bash

set -eo pipefail

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

pushd "$PROJECTROOT"

# shellcheck source=/dev/null
source conf/settings.conf

# shellcheck source=/dev/null
source scripts/common.sh

pushd build

ROOTFS="rootfs-$RELEASE"

rm -rf "$ROOTFS"

join_by() { local IFS="$1"; shift; echo "$*"; }

components=$(join_by , "${DISTRO_COMPONENTS[@]}")
include=$(join_by , "${DISTRO_PKGS[@]}")

print_action "Building rootfs with mmdebstrap"
mmdebstrap \
  --variant=minbase \
  --aptopt='APT::Install-Recommends "false"' \
  --components="$components" \
  --include="$include" \
  "$DISTRO_RELEASE" \
  "$ROOTFS" \
  "deb $DISTRO_REPO $DISTRO_RELEASE ${DISTRO_COMPONENTS[*]}" \
  "deb $DISTRO_REPO $DISTRO_RELEASE-updates ${DISTRO_COMPONENTS[*]}" \
  "deb $DISTRO_SECURITY_REPO $DISTRO_RELEASE-security ${DISTRO_COMPONENTS[*]}"

print_action "Settings root password"
chroot "$ROOTFS" chpasswd <<< "root:$ROOT_PASSWORD"

print_action "Image release info"
echo "$RELEASE" > "$ROOTFS/etc/${NAME}_release"

print_action "Importing modules"
mkdir -p "$ROOTFS/lib/modules"

modulesdir=(modules-"$RELEASE"/lib/modules/*)

cp -rf "$modulesdir" "$ROOTFS/lib/modules/"
rm -f "$ROOTFS"/lib/modules/*/build

print_action "Importing base files"
cp -rf ../base/rootfs/* "./$ROOTFS/"

print_action "Making SSH only use socket activation"
chroot "$ROOTFS" systemctl disable ssh.service
chroot "$ROOTFS" systemctl enable ssh.socket

print_action "Enabling helpers"
helper_services=(
    busybox-ntpd.service
)

for srv in "${helper_services[@]}"
do
    echo "Enabling $srv"
    chroot "$ROOTFS" systemctl enable "$srv"
done

print_action "Disabling unwanted services"
unwanted_services=(
    ipmievd.service
    systemd-networkd-wait-online.service
    systemd-pcrlock-firmware-code.service
    systemd-pcrlock-firmware-config.service
    systemd-pcrlock-make-policy.service
    systemd-tpm2-setup-early.service
    systemd-tpm2-setup.service
    systemd-sysupdate.service
    systemd-sysupdate.timer
)
for srv in "${unwanted_services[@]}"
do
    echo "Disabling $srv"
    chroot "$ROOTFS" systemctl mask "$srv"
done


#print_action "Modernizing APT sources"
#chroot rootfs apt modernize-sources --yes

#apt_key=/usr/share/keyrings/ubuntu-archive-keyring.gpg
#apt_sources=/etc/apt/sources.list.d/moved-from-main.sources

#if [[ -e "rootfs/${apt_key}" ]]
#then
#    sed --in-place -e "/^Signed-By: /s@^.*\$@Signed-By: $apt_key@" "rootfs/${apt_sources}"
#fi

print_action "Uninitializing"
chroot "$ROOTFS" /usr/local/libexec/uninitialize-system.sh

pushd "$ROOTFS"

print_action "Setting authorized_keys"
mkdir -p root/.ssh
chmod 700 root/.ssh
touch root/.ssh/authorized_keys
chmod 600 root/.ssh/authorized_keys

#print_action "Remove unwanted files (pycache)"
#find usr/lib/python* -name '__pycache__' -type d -exec rm -rf {} ';' || true

#print_action "Remove unwanted files (localized man)"
#find usr/share/man -not -name 'man*' -type d -exec rm -rf {} ';' || true

tee -a root/.ssh/authorized_keys < "../../conf/authorized_keys"

print_action "Setting hostname"
echo "$DEFAULT_HOSTNAME" > etc/hostname

print_action "Setup prompt"
cat >> root/.bashrc <<EOF
[ -e ~/.bash_prompt ] && source ~/.bash_prompt
EOF

print_action "Cleaning up .empty placeholders"
find . -name '.empty' -exec rm {} ';'

popd # rootfs ($ROOTFS)

print_action "Creating tar bundle"
tar --transform 's_^'"$ROOTFS"'_rootfs_' -c "$ROOTFS" > "$ROOTFS".tar

# print_action "Creating squashfs image"
# mksquashfs "$ROOTFS" "$ROOTFS.squashfs" -noappend -comp zstd

popd # build
popd # project

print_status "Rootfs ready"
