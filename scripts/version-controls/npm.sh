#!/bin/bash
set -e
echoerr() {
  echo "$@" >&2
}
if [ -z "$VERSION" ]; then
    echoerr "Missing 'VERSION' environment variable. Fatal error."
    exit 1
fi
if [[ ! "$VERSION" =~ ^(patch|minor|major|([0-9]+.[0-9]+.[0-9]+))$ ]]; then
  echoerr "Version '$VERSION' invalid."
  exit 1
fi

echoerr "Bumped version '$VERSION' using 'npm'"
version=$(npm version --no-git-tag-version "$VERSION")
echo -n ${version:1}
