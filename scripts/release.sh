#!/bin/bash
set -e

# shellcheck disable=SC1091
. ./docker-build.env
# shellcheck disable=SC1091
. ./release.env

if [[ -z "$RELEASE_VERSION" ]]; then
	echo "RELEASE_VERSION is not set!"
	exit 1
fi
if [[ -z "$RELEASE_TITLE" ]]; then
	echo "RELEASE_TITLE is not set!"
	exit 1
fi
if [[ -z "$RELEASE_NOTE" ]]; then
	echo "RELEASE_NOTE is not set!"
	exit 1
fi
if [[ -z "$IMAGE_TAG" ]]; then
  echo "IMAGE_TAG is not set!"
  exit 1
fi
if [[ $IMAGE_TAG != "$RELEASE_VERSION" ]]; then
  echo "IMAGE_TAG ($IMAGE_TAG) does not match RELEASE_VERSION ($RELEASE_VERSION)!"
  exit 1
fi

gh release create "$RELEASE_VERSION" --title "$RELEASE_TITLE" --notes "${RELEASE_NOTE}" --latest
