@Library(['release-library@feature/first-draft', 'shared-library@feature/multiple-env']) _

import com.duvalhub.release.parameters.Parameters
import com.duvalhub.gitclone.GitCloneRequest

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
    env.BASE_DIR = pwd()
    
    echo "$WORKSPACE vs $BASE_DIR"
    sh "ls -l $WORKSPACE"
    initializeSharedLibrary

    Parameters parameters = new Parameters(env.GIT_REPOSITORY, env.FLOW_TYPE, env.VERSION)

    GitCloneRequest gitCloneRequest = new GitCloneRequest(env.GIT_REPOSITORY)
    gitCloneRequest.toCheckout = "develop"
    gitClone(gitCloneRequest)

    performGitActions()



}