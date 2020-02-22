@Library(['release-library@master', 'shared-library@master']) _
env.PIPELINE_BRANCH = "master"

import com.duvalhub.release.parameters.Parameters
import com.duvalhub.git.GitCloneRequest
import com.duvalhub.git.GitRepo
import com.duvalhub.release.performgitactions.PerformGitActions
import com.duvalhub.initializeworkdir.InitializeWorkdirIn
import com.duvalhub.appconfig.AppConfig

dockerSlave {
//node {
    properties([
        parameters([
            string(defaultValue: 'duvalhub/continuous-deployment-test-app', name: 'GIT_REPOSITORY'),
            choice(choices: ['release', 'production'], name: 'FLOW_TYPE'),
            choice(choices: ['patch', 'minor', 'major'], name: 'VERSION'),
            string(defaultValue: 'false', name: 'DRY_RUN')
        ])
    ])

    if ( params.DRY_RUN == 'false' ) {
        Parameters parameters = new Parameters(params.GIT_REPOSITORY, params.FLOW_TYPE, params.VERSION)

        checkout scm
        env.BASE_DIR = env.WORKSPACE

        String[] repo_parts = parameters.git_repository.split('/')
        String org = repo_parts[0]
        String repo = repo_parts[1]
        GitRepo appGitRepo = new GitRepo(org, repo, "develop")

        InitializeWorkdirIn initWorkDirIn = new InitializeWorkdirIn(appGitRepo)
        initializeWorkdir.stage(initWorkDirIn)

        AppConfig appConfig = readConfiguration()

        performGitActions(new PerformGitActions(parameters, initWorkDirIn, appConfig))
    } else {
        echo "Dry run detected! Aborting pipeline."
    }

}
