#!/bin/bash
set -e

if [ -z "$RELEASE_BRANCH" ]; then
    echo "Missing 'RELEASE_BRANCH' environment variable. Fatal error"
    exit 1
fi

echo "Releasing from release branch '$RELEASE_BRANCH'"
version=$(echo "$RELEASE_BRANCH" | cut -d'/' -f2)

# Prepare release branch
git checkout "$RELEASE_BRANCH"

fork_commit_with_develop=$(git merge-base --fork-point develop)
last_merge_commit=$(git log --pretty=format:"%h" --merges -n 1)
current_release_feature_commits=$(git log --pretty=format:"%s" $last_merge_commit..$fork_commit_with_develop)
 git reset --soft $fork_commit_with_develop
git commit -m "$release_branch :
$current_release_feature_commits
"
# Merge release branch into master
git checkout master
git merge --no-edit "$RELEASE_BRANCH"
git tag "$version"
git push origin --tags master
git push origin --delete "$RELEASE_BRANCH"

# Merge back into develop if no conflict
git checkout develop
echo "########### Merge conflict"
create_pull_request "$release_branch"


#if try_merge; then
#    echo "########## Merging successful"
#    git commit -am "End of Release: '$release_branch'"
#else
#    echo "########### Merge conflict"
#    git merge --abort
#    create_pull_request "$release_branch"
#fi

try_merge() {
    git merge --no-ff --no-commit master
}

create_pull_request() {

    curl -u "$USERNAME:$PASSWORD" -X POST -d '{"title":"End of Release: '$1'","head":"master","base":"develop"}' https://api.github.com/repos/duvalhub/continuous-deployment-test-app/pulls
}