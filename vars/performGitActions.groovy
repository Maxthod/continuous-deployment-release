import com.duvalhub.initializeworkdir.SharedLibrary
import com.duvalhub.release.performgitactions.PerformGitActions


def call(PerformGitActions performGitActions) {
    echo "Executing 'performGitActions.groovy' with PerformGitActions: '${performGitActions.toString()}'"
    dir(performGitActions.app_workdir) {
        withSshKey("github.com", "SERVICE_ACCOUNT_SSH", "git") {
            withCredentials([
                    usernamePassword(credentialsId: 'SERVICE_ACCOUNT_GITHUB_TOKEN', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD'),
                    usernamePassword(credentialsId: performGitActions.getCredentialId(), usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')
            ]) {
                env.PULL_REQUEST_TITLE = "Automatic Pull Request from CI."
                String flow_type = performGitActions.getFlowType()
                def versionControlImages = [npm: "node:16.14.2-alpine", maven: "maven:3"]
                switch (flow_type) {
                    case "release":
                        env.GIT_URI = performGitActions.getGitUri()
                        env.VERSION = performGitActions.getVersion()
                        String versionControl = performGitActions.getVersionControl()
                        String version_script = "${env.WORKSPACE}/scripts/version-controls/${versionControl}.sh"
                        String new_version = null
                        String image = versionControlImages[versionControl]
                        if(!image) {
                            echo "We don't have a version for ${versionControl}"
                            sh "exit 1"
                        }

                        docker.image(image)
                            .inside() { c ->
//                                sh "hostname"
//                                sh "whoami"
//                                sh "sleep 55555"
                                new_version = executeScript(version_script, true)
                            }
                        env.NEW_VERSION = new_version
                        break
                    case "production":
                        env.REGISTRY_API = performGitActions.getRegistryApi()
                        env.NAMESPACE = performGitActions.getNamespace()
                        env.REPOSITORY = performGitActions.getRepository()
                        String release_branch_script = "${SharedLibrary.getWorkdir(env)}/libs/scripts/getReleaseBranch/getReleaseBranch.sh"
                        String release_branch = executeScript(release_branch_script, true)
                        env.RELEASE_BRANCH = release_branch
                        break
                    default:
                        echo "Flow type '$flow_type' unknown. Critical error."
                        sh "exit 1"
                }

                String git_action_script = "${env.WORKSPACE}/scripts/gitaction/${flow_type}.sh"
                withEnv([
                        "PULL_REQUEST_TITLE=Automatic Pull Request from CI."
                ]) {
                    executeScript(git_action_script)
                }
            }
        }
    }
}