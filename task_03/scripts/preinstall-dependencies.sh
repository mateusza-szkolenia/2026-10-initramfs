#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."
pushd "$PROJECTROOT"

# shellcheck disable=SC1091
source conf/settings.conf
# shellcheck disable=SC1091
source scripts/common.sh

apt-get update

apt-get install --yes --no-install-recommends "${BUILD_DEPS[@]}"
