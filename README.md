# Continuous deployment release
This pipepline create a new releases by manipulating the git branches following the [successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/). 

Running with option "release" means creating a new draft release by creating a release/x.y.z git branch from the main branch. The new branch should launch a [continuous deployment pipeline](https://github.com/duvalhub/continuous-deployment) (CICD pipeline) which in turn creates the new version x.y.z. We follow the [semantic versioning)(https://semver.org/). Only one release branch can exists at the time. New fix commits can be added to the release branch at this time.

Running with option "production" means merging that release branch into the production branch and creating the git tag which again launch the CICD pipeline. The production branch is then merged back into the main branch automatically if possible. In case of conflict, a pull request is created. This process ensure that the version and artifact are now fixed and linked to the code source. The artifact repository (DTR) should be immutable. 

It makes used of [shared library](https://github.com/duvalhub/continuous-deployment-shared-library) for common Jenkins functions and configurations.
