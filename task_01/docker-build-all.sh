#!/bin/bash

set -e

PROJECTROOT="$(dirname "${BASH_SOURCE[0]}")"

DOCKERFILE="build.Dockerfile"

DOCKER_NAME="myinitrd-01-build"

echo "Building Docker image (build environment)"
docker buildx build -f "$DOCKERFILE" -t "$DOCKER_NAME" .

echo "Building all in Docker"
if ! docker run \
    --rm \
    --volume "$PROJECTROOT/":/build \
    "$DOCKER_NAME" \
    ./build.sh
then
    echo "Build failed!"
fi

echo "Fixing file ownership"
docker run \
    -it \
    --rm \
    --volume "$PROJECTROOT/":/build \
    "$DOCKER_NAME" \
    chown -R "$UID" /build

echo "Docker finished"
