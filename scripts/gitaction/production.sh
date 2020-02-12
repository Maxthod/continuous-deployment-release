#!/bin/bash
set -e

if [ -z "$RELEASE_BRANCH" ]; then
    echo "Missing 'RELEASE_BRANCH' environment variable. Fatal error"
    exit 1
fi
echo "Releasing from release branch '$RELEASE_BRANCH'"
version=$(echo "$RELEASE_BRANCH" | cut -d'/' -f2)
git checkout "$RELEASE_BRANCH"
git checkout master
git merge "$RELEASE_BRANCH"
git tag "$version"
git push origin --tags master
git push origin --delete "$RELEASE_BRANCH"