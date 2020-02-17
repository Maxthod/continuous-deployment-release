#!/bin/bash
set -e
if [ -z "$VERSION" ]; then
    echo "Missing 'VERSION' environment variable. Fatal error."
    exit 1
fi
>&2 echo "Bumped version '$VERSION' using 'npm'"
version=$(npm version --no-git-tag-version "$VERSION")
echo -n ${version:1}
