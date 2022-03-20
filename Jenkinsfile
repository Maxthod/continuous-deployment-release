@Library(['release-library@fix/pipeline-is-a-bit-outdated', 'shared-library@master']) _

import com.duvalhub.release.parameters.Parameters
import com.duvalhub.git.GitCloneRequest
import com.duvalhub.git.GitRepo
import com.duvalhub.release.performgitactions.PerformGitActions
import com.duvalhub.initializeworkdir.InitializeWorkdirIn
import com.duvalhub.appconfig.AppConfig

// dockerSlave {
node {
    properties([
        parameters([
            string(name: 'GIT_REPOSITORY'),
            choice(choices: ['none', 'release', 'production'], name: 'FLOW_TYPE'),
            choice(choices: ['none','patch', 'minor', 'major'], name: 'VERSION'),
            string(defaultValue: 'false', name: 'DRY_RUN')
        ])
    ])

//     Parameters parameters = new Parameters(params.GIT_REPOSITORY, params.FLOW_TYPE, params.VERSION, params.DRY_RUN)
    Parameters parameters = new Parameters(params)
    if ( true || parameters.isDryRun() ) {
        echo "Dry run detected! Aborting pipeline."
        echo parameters.toString()
        if(parameters.isDryRun()) {
            echo "ouch"
        } else {
            echo "ouille"
        }
        echo "" + parameters.isDryRun()
    } else {
        checkout scm
        env.BASE_DIR = env.WORKSPACE

        String[] repo_parts = parameters.git_repository.split('/')
        String org = repo_parts[0]
        String repo = repo_parts[1]
        GitRepo appGitRepo = new GitRepo(org, repo, "main")
        InitializeWorkdirIn initWorkDirIn = new InitializeWorkdirIn(appGitRepo)
        AppConfig conf = initializeWorkdir.stage(initWorkDirIn)
        performGitActions(new PerformGitActions(parameters, initWorkDirIn, appConfig))
    }

}
