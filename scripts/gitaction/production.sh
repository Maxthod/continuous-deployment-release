#!/bin/bash
set -e
docker_tag_exists() {
    curl --silent -u "$DOCKERHUB_USERNAME:$DOCKERHUB_PASSWORD" -f -lSL "$1"/repositories/$2/tags/$3 > /dev/null
}

try_merge() {
    git merge --no-ff --no-commit "$1"
}

create_pull_request() {
    curl -u "$USERNAME:$PASSWORD" -X POST -d "{\"title\":\"$PULL_REQUEST_TITLE\",\"head\":\"$1\",\"base\":\"$2\"}" https://api.github.com/repos/duvalhub/continuous-deployment-test-app/pulls
}

missing_params=false

test_param() {
    if [ -z "${!1}" ]; then
        echo "Missing '$1' environment variable. Fatal error"
        missing_params=true
    else
      echo "'$1=${!1}'"
    fi
}
test_param "RELEASE_BRANCH"
test_param "REGISTRY_API"
test_param "NAMESPACE"
test_param "REPOSITORY"
test_param "MAIN_BRANCH"
test_param "PRODUCTION_BRANCH"

if [ "$missing_params" = true ]; then
    echo "Missing parameters detected. Aborting..."
    exit 1
else
    version=$(echo "$RELEASE_BRANCH" | cut -d'/' -f2)
    if ! docker_tag_exists "$REGISTRY_API" "$NAMESPACE/$REPOSITORY" "$version"; then
        echo "Image '$NAMESPACE/$REPOSITORY:$version' does not exist. Release in production impossible. Aborting..."
        exit 1
    else
        echo "Releasing from release branch '$RELEASE_BRANCH'"
    
        # Prepare release branch
        git checkout "$PRODUCTION_BRANCH"
        git checkout "$MAIN_BRANCH"
        git checkout "$RELEASE_BRANCH"

        fork_commit_with_develop=$(git merge-base "$RELEASE_BRANCH" "$MAIN_BRANCH")
        last_merge_commit=$(git log --pretty=format:"%h" --merges -n 1)
        current_release_feature_commits=$(git log --pretty=format:"%s" "$last_merge_commit..$fork_commit_with_develop")
        echo "fork_commit_with_develop: '$fork_commit_with_develop', last_merge_commit: '$last_merge_commit', current_release_feature_commits: '$current_release_feature_commits'"

        git reset --soft "$fork_commit_with_develop"
        git commit -am "$RELEASE_BRANCH :
        $current_release_feature_commits
        "
        # Merge release branch into "$PRODUCTION_BRANCH"
        git checkout "$PRODUCTION_BRANCH"
        git merge --no-edit "$RELEASE_BRANCH"
        git tag "$version"
        git push origin --tags "$PRODUCTION_BRANCH"
        git push origin --delete "$RELEASE_BRANCH"

        # Merge back into "$MAIN_BRANCH if no conflict
        git checkout "$MAIN_BRANCH"
        if try_merge "$PRODUCTION_BRANCH"; then
            echo "########## Merging successful"
            git commit -am "End of Release: '$RELEASE_BRANCH'"
            git push origin "$MAIN_BRANCH"
        else
            echo "########### Merge conflict"
            git merge --abort
            conflict_branch="conflicts/$RELEASE_BRANCH"
            git checkout "$PRODUCTION_BRANCH"
            git checkout -b "$conflict_branch"
            git push origin "$conflict_branch"
            create_pull_request "$conflict_branch" ""$MAIN_BRANCH
        fi
    fi
fi
