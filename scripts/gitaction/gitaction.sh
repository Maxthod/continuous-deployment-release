#!/bin/bash
NEW_BRANCH="release/$NEW_VERSION"
git checkout -b $NEW_BRANCH
git add .
git commit -am "Bumped to '$NEW_VERSION'"
git push origin $NEW_BRANCH