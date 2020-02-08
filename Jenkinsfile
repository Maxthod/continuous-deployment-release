@Library(['release-library@feature/first-draft', 'shared-library@feature/multiple-env']) _
env.PIPELINE_BRANCH = "feature/multiple-env"
import com.duvalhub.release.parameters.Parameters
import com.duvalhub.gitclone.GitCloneRequest
import com.duvalhub.release.performgitactions.PerformGitActions

//dockerSlave {
node {
    properties([
        parameters([
            string(defaultValue: 'git@github.com:duvalhub/continuous-deployment-test-app.git', name: 'GIT_REPOSITORY'),
            choice(choices: ['release', 'production'], name: 'FLOW_TYPE'),
            choice(choices: ['patch', 'minor', 'major'], name: 'VERSION')
        ])
    ])

    checkout scm
    env.BASE_DIR = env.WORKSPACE

    initializeSharedLibrary()

    Parameters parameters = new Parameters(env.GIT_REPOSITORY, env.FLOW_TYPE, env.VERSION)

    GitCloneRequest gitCloneRequest = new GitCloneRequest(parameters.git_repository)
    gitCloneRequest.toCheckout = "develop"
    gitClone(gitCloneRequest)

    performGitActions(new PerformGitActions(parameters, gitCloneRequest))

}