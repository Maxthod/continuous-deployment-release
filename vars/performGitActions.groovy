
def call() {

    String script = "${env.WORKSPACE}/scripts/gitaction/gitaction.sh"
    executeScript(script)

}