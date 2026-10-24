#!/bin/bash

# shellcheck disable=SC2034

function print_section () {
    local c1="\e[1;38;5;15;48;5;208m"
    local c2="\e[1;38;5;130;48;5;208m"
    local reset='\e[m'
    local fill='\e[K'

    printf "%b ▸ %b%s %b%b\n" "$c2" "$c1" "$*" "$fill" "$reset"
}

function print_action () {
    local c1="\e[1;38;5;15;48;5;26m"
    local c2="\e[1;38;5;18;48;5;26m"
    local reset='\e[m'
    local fill='\e[K'

    printf "%b ▸ %b%s %b%b\n" "$c2" "$c1" "$*" "$fill" "$reset"
}

function print_status () {
    local c1="\e[1;38;5;15;48;5;28m"
    local c2="\e[1;38;5;118;48;5;28m"
    local reset='\e[m'
    local fill='\e[K'

    printf "%b ▸ %b%s %b%b\n" "$c2" "$c1" "$*" "$fill" "$reset"
}

function print_error () {
    local c1="\e[1;38;5;15;48;5;88m"
    local c2="\e[1;38;5;196;48;5;88m"
    local reset='\e[m'
    local fill='\e[K'

    printf "%b ▸ %b%s %b%b\n" "$c2" "$c1" "$*" "$fill" "$reset"
}

function join_by() {
    local IFS="$1"
    shift
    echo "$*"
}

KERNEL_LOCALVERSION="-${RELEASE,,}"
DEFAULT_HOSTNAME="$NAME-${RELEASE//./-}"
KERNEL_FULLVERSION="${KERNEL_VERSION}${KERNEL_LOCALVERSION}"

case "$DISTRO" in
    ubuntu)
        DISTRO_REPO="${DISTRO_REPO:-http://archive.ubuntu.com/ubuntu}"
        DISTRO_SECURITY_REPO="${DISTRO_SECURITY_REPO:-http://security.ubuntu.com/ubuntu}"
        [[ "${#DISTRO_COMPONENTS[@]}" == 0 ]] && DISTRO_COMPONENTS=(main universe restricted)
        ;;
    debian)
        DISTRO_REPO="${DISTRO_REPO:-http://deb.debian.org/debian}"
        DISTRO_SECURITY_REPO="${DISTRO_SECURITY_REPO:-http://deb.debian.org/debian-security}"
        [[ "${#DISTRO_COMPONENTS[@]}" == 0 ]] && DISTRO_COMPONENTS=(main non-free-firmware)
        ;;
    *)
        print_error "Unknown DISTRO: $DISTRO"
        exit 1
        ;;
esac
