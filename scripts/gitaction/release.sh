#!/bin/bash
set -e
release_branch=$(git branch -a | grep '^  remotes/origin/release' | wc -l)
pull_request=$(curl -s "https://api.github.com/repos/$GIT_URI/pulls" | grep "$PULL_REQUEST_TITLE" | wc -l)
if (( $pull_request > 0 )); then
    echo "Pull Request Exists! There is a pull request from master to develop. Clear this pull request before launching a new release."
    exit 1    
elif (( $release_branch > 0 )); then
    echo "Release branch detected! There is already a release branch. Finish or removed current release and retry"
    exit 1
else
    NEW_BRANCH="release/$NEW_VERSION"
    git remote -v
    git checkout -b $NEW_BRANCH
    git add .
    git commit -am "Bumped to '$NEW_VERSION'"
    git push origin $NEW_BRANCH
fi
