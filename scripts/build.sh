#!/bin/bash

if [[ ! -f Dockerfile ]]; then
	echo "Dockerfile not found!"
	exit 1
fi
if [[ ! -d src ]]; then
	echo "src directory not found!"
	exit 1
fi
if [[ ! -f docker-build.env ]]; then
	echo "docker-build.env file not found!"
	exit 1
fi

# shellcheck disable=SC1091
source ./docker-build.env # docker-specific environment docker-build

if [[ -z "$IMAGE_TAG" ]]; then
  echo "IMAGE_TAG is not set!"
  exit 1
fi

docker build -f Dockerfile src \
  --build-arg IMAGE_TAG="$IMAGE_TAG" \
	-t "${DOCKER_IMAGE_NAME_DOCKER}:${IMAGE_TAG}" \
	-t "${DOCKER_IMAGE_NAME_DOCKER}:latest" \
	-t "${DOCKER_IMAGE_NAME_GHCR}:${IMAGE_TAG}" \
	-t "${DOCKER_IMAGE_NAME_GHCR}:latest"
