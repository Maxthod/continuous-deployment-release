#!/bin/bash

script_under_test="$(pwd)/production.sh"

# Arrange
export RELEASE_BRANCH="release/1.2.3"
git_repo_bare=$(mktemp -d)
git_repo=$(mktemp -d)
git_repo2=$(mktemp -d)
cd "$git_repo_bare"
git init --bare
cd "$git_repo"
git init
git remote add origin "$git_repo_bare"
touch allo
git add allo
git commit -am "dont care"
git branch
git push origin master
git checkout -b develop
git push origin develop
git checkout -b "$RELEASE_BRANCH"
echo "bobo" >> allo
git commit -am "allo"
git push origin "$RELEASE_BRANCH"
git checkout develop
git clone "$git_repo_bare" "$git_repo2" -b develop
cd "$git_repo2"
# Act
$script_under_test

rm -rf "$git_repo_bare"
rm -rf "$git_repo"