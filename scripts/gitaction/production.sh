#!/bin/bash
set -e
docker_tag_exists() {
    curl --silent -f -lSL "$1"/repositories/$2/tags/$3 > /dev/null
}

try_merge() {
    git merge --no-ff --no-commit "$1"
}

create_pull_request() {
    curl -u "$USERNAME:$PASSWORD" -X POST -d "{\"title\":\"$PULL_REQUEST_TITLE\",\"head\":\"master\",\"base\":\"develop\"}" https://api.github.com/repos/duvalhub/continuous-deployment-test-app/pulls
}

if [ -z "$RELEASE_BRANCH" ]; then
    echo "Missing 'RELEASE_BRANCH' environment variable. Fatal error"
    exit 1
else
    version=$(echo "$RELEASE_BRANCH" | cut -d'/' -f2)
    if ! docker_tag_exists "$REGISTRY_API" "$NAMESPACE/$REPOSITORY" "$version"; then
        echo "Image '$NAMESPACE/$REPOSITORY:$version' does not exist. Release in production impossible. Aborting..."
        exit 1
    else
        echo "Releasing from release branch '$RELEASE_BRANCH'"
    
        # Prepare release branch
        git checkout master
        git checkout develop
        git checkout "$RELEASE_BRANCH"

        fork_commit_with_develop=$(git merge-base --fork-point develop)
        last_merge_commit=$(git log --pretty=format:"%h" --merges -n 1)
        current_release_feature_commits=$(git log --pretty=format:"%s" $last_merge_commit..$fork_commit_with_develop)

        echo "fork_commit_with_develop: '$fork_commit_with_develop', last_merge_commit: '$last_merge_commit', current_release_feature_commits: '$current_release_feature_commits'"

        git reset --soft "$fork_commit_with_develop"
        git commit -am "$release_branch :
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
        if try_merge "master"; then
            echo "########## Merging successful"
            git commit -am "End of Release: '$release_branch'"
            git push origin develop
        else
            echo "########### Merge conflict"
            git merge --abort
            create_pull_request "$release_branch"
        fi
    fi
fi
