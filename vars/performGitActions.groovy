import com.duvalhub.release.performgitactions.PerformGitActions

def call(PerformGitActions performGitActions) {
    echo "Executing 'performGitActions.groovy' with PerformGitActions: '${performGitActions.toString()}'"
    dir( performGitActions.app_workdir ) {
        withSshKey() {
            env.VERSION = performGitActions.getVersion()
            String version_script = "${env.WORKSPACE}/scripts/version-controls/${performGitActions.getVersionControl()}.sh"
            String new_version = executeScript(script_path: git_action_script, stdout: true)

            env.NEW_VERSION = new_version
            String git_action_script = "${env.WORKSPACE}/scripts/gitaction/gitaction.sh"
            executeScript(git_action_script)        
        }
    }
}