import com.duvalhub.release.performgitactions.PerformGitActions

def call(PerformGitActions performGitActions) {
    dir( performGitActions.app_workdir ) {
        String script = "${env.WORKSPACE}/scripts/gitaction/gitaction.sh"
        executeScript(script)        
    }
}