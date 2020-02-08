import com.duvalhub.release.performgitactions.PerformGitActions

def call(PerformGitActions performGitActions) {
    dir( performGitActions.app_workdir ) {
        withSshKey() {
            String script = "${env.WORKSPACE}/scripts/gitaction/gitaction.sh"
            executeScript(script)        
        }
    }
}