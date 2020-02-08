#!/bin/bash


pwd
ls -l
git remote -v
export GIT_SSH_COMMAND="ssh -oStrictHostKeyChecking=accept-new -i $SSH_KEY_PATH -F /dev/null"
NEW_BRANCH="release/1.2.3"
git checkout -b $NEW_BRANCH
git push origin $NEW_BRANCH