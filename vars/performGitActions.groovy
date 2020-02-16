import com.duvalhub.release.performgitactions.PerformGitActions

def call(PerformGitActions performGitActions) {
    echo "Executing 'performGitActions.groovy' with PerformGitActions: '${performGitActions.toString()}'"
    dir( performGitActions.app_workdir ) {
        withSshKey() {
            withCredentials([
                usernamePassword(credentialsId: 'GITHUB_SERVICE_ACCOUNT_CREDENTIALS', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')
            ]) {
                env.PULL_REQUEST_TITLE = "Automatic Pull Request from CI."
                String flow_type = performGitActions.getFlowType()
                switch(flow_type) {
                    case "release":
                        env.GIT_URI = performGitActions.getGitUri()
                        env.VERSION = performGitActions.getVersion()
                        String version_script = "${env.WORKSPACE}/scripts/version-controls/${performGitActions.getVersionControl()}.sh"
                        String new_version = executeScript(version_script, true)
                        env.NEW_VERSION = new_version
                        break
                    case "production":
                        env.REGISTRY_API = performGitActions.getRegistryApi()
                        env.NAMESPACE = performGitActions.getNamespace()
                        env.REPOSITORY  performGitActions.getRepository()
                        String release_branch_script = "${env.PIPELINE_WORKDIR}/scripts/bash/getReleaseBranch/getReleaseBranch.sh"
                        String release_branch = executeScript(release_branch_script, true)
                        env.RELEASE_BRANCH = release_branch
                        break
                    default:
                        echo "Flow type '$flow_type' unknown. Critical error."
                        sh "exit 1"
                }

                String git_action_script = "${env.WORKSPACE}/scripts/gitaction/${flow_type}.sh"
                executeScript(git_action_script)        

            }
        }
    }
}