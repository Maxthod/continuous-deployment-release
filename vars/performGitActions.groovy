
def call() {

    String script = "${env.PIPELINE_WORKDIR}/scripts/wait/wait.sh"
    executeScript(script)

}