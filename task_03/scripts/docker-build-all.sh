#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")/.."

DOCKERFILE="docker/build.Dockerfile"

pushd "$PROJECTROOT"

# shellcheck source=/dev/null
source conf/settings.conf

DOCKER_NAME="${NAME}-build"

# shellcheck source=/dev/null
source scripts/common.sh

print_action "Building Docker image (build environment)"
docker buildx build -f "$DOCKERFILE" -t "$DOCKER_NAME" .

print_action "Building all in Docker"
if ! docker run \
    --rm \
    --volume "$PROJECTROOT/base":/build/base \
    --volume "$PROJECTROOT/conf":/build/conf \
    --volume "$PROJECTROOT/scripts":/build/scripts \
    --volume "$PROJECTROOT/dist":/build/dist \
    --volume "$PROJECTROOT/cache":/build/cache \
    --volume "$PROJECTROOT/build":/build/build \
    "$DOCKER_NAME" \
    scripts/build-all.sh
then
    print_error "Build failed!"
fi

print_action "Fixing file ownership"
docker run \
    -it \
    --rm \
    --volume "$PROJECTROOT/dist":/build/dist \
    --volume "$PROJECTROOT/cache":/build/cache \
    --volume "$PROJECTROOT/build":/build/build \
    "$DOCKER_NAME" \
    chown -R "$UID" /build/dist /build/cache /build/build

popd # project

print_status "Docker finished"
