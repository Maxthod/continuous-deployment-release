@Library(['release-library@feature/first-draft', 'shared-library@feature/multiple-env']) _
env.PIPELINE_BRANCH = "feature/multiple-env"
import com.duvalhub.release.parameters.Parameters
import com.duvalhub.git.GitCloneRequest
import com.duvalhub.git.GitRepo
import com.duvalhub.release.performgitactions.PerformGitActions

//dockerSlave {
node {
    properties([
        parameters([
            string(defaultValue: 'git@github.com:duvalhub/continuous-deployment-test-app.git', name: 'GIT_REPOSITORY'),
            choice(choices: ['release', 'production'], name: 'FLOW_TYPE'),
            choice(choices: ['patch', 'minor', 'major'], name: 'VERSION'),
            string(defaultValue: 'false', name: 'DRY_RUN')
        ])
    ])

    if ( params.DRY_RUN == 'false' ) {
        checkout scm
        env.BASE_DIR = env.WORKSPACE

        initializeSharedLibrary()

        Parameters parameters = new Parameters(env.GIT_REPOSITORY, env.FLOW_TYPE, env.VERSION)

        String[] repo_parts = params.GIT_REPOSITORY.split('/')
        String org = repo_parts[-2]
        String repo = repo_parts[-1]
        GitRepo gitRepo = new GitRepo(org, repo, "develop")
        GitCloneRequest gitCloneRequest = new GitCloneRequest(gitRepo)
        gitClone(gitCloneRequest)

        performGitActions(new PerformGitActions(parameters, gitCloneRequest))
    } else {
        echo "Dry run detected! Aborting pipeline."
    }

}