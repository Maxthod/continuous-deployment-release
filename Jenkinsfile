@Library(['release-library@feature/first-draft', 'shared-library@feature/multiple-env']) _

import com.duvalhub.release.parameters.Parameters
import com.duvalhub.release.parameters.FlowType
import com.duvalhub.gitclone.GitCloneRequest

dockerSlave {
    properties([
        parameters([
            string(defaultValue: 'git@github.com:duvalhub/continuous-deployment-test-app.git', name: 'GIT_REPOSITORY'),
            choice(choices: ['release', 'production'], name: 'FLOW_TYPE'),
            choice(choices: ['patch', 'minor', 'major'], name: 'VERSION')
        ])
    ])

    checkout scm
    env.BASE_DIR = pwd()

    Parameters parameters = new Parameters(env.GIT_REPOSITORY, FlowType.fromString(env.FLOW_TYPE), Version.fromString(env.VERSION))

    GitCloneRequest gitCloneRequest = new GitCloneRequest(env.GIT_REPOSITORY)
    gitCloneRequest.toCheckout = "develop"
    gitClone(gitCloneRequest)

    performGitActions()



}