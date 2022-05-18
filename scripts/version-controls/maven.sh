#!/usr/bin/env bash
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

echoerr "Bumped version '$VERSION' using maven"

if [ "$VERSION" = "patch" ]; then
  mvn build-helper:parse-version versions:set \
    '-DnewVersion=${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.nextIncrementalVersion}' \
    versions:commit 1>&2
elif [ "$VERSION" = "minor" ]; then
  mvn build-helper:parse-version versions:set \
      '-DnewVersion=${parsedVersion.majorVersion}.${parsedVersion.nextMinorVersion}.0' \
      versions:commit 1>&2
elif [ "$VERSION" = "major" ]; then
  mvn build-helper:parse-version versions:set \
      '-DnewVersion=${parsedVersion.nextMajorVersion}.0.0' \
      versions:commit 1>&2
else
  mvn build-helper:parse-version versions:set \
      -DnewVersion="$VERSION" \
      versions:commit 1>&2
fi

mvn help:evaluate -Dexpression=project.version -q -DforceStdout
