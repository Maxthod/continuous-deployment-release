@Library(['release-library@fix/pipeline-is-a-bit-outdated', 'shared-library@fix/launching-container-during-build']) _

import com.duvalhub.release.parameters.Parameters
import com.duvalhub.git.GitCloneRequest
import com.duvalhub.git.GitRepo
import com.duvalhub.release.performgitactions.PerformGitActions
import com.duvalhub.initializeworkdir.InitializeWorkdirIn
import com.duvalhub.appconfig.AppConfig
//
//     properties([
//         parameters([
//             string(name: 'GIT_REPOSITORY'),
//             choice(choices: ['none', 'release', 'production'], name: 'FLOW_TYPE'),
//             choice(choices: ['none','patch', 'minor', 'major'], name: 'VERSION'),
//             string(defaultValue: 'false', name: 'DRY_RUN')
//         ])
//     ])
//
//
// echo "allo"
//
// echo params.GIT_REPOSITORY

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

    sh "ls -l; sleep 5"

    sh "touch allo"
//     withDockerServer([uri: "tcp://build.docker.duvalhub.com:2376", credentialsId: "DOCKER_BUILD_BUNDLE"]) {
        docker.image('duvalhub/node:16.rc1')
//         docker.image('duvalhub/jenkins-slave:1.0.5.rc1')
        .inside() { c ->
            sh "npm -v"
            sh "ls -l"
            sh "mv allo toto"
        }
//     }
    sh "ls -l"
    return
    Parameters parameters = new Parameters(params)
    if ( parameters.isDryRun() ) {
        echo "Dry run detected! Aborting pipeline."
    } else {
        checkout scm
        String[] repo_parts = parameters.git_repository.split('/')
        String org = repo_parts[0]
        String repo = repo_parts[1]
        GitRepo appGitRepo = new GitRepo(org, repo, "main")
        InitializeWorkdirIn initWorkDirIn = new InitializeWorkdirIn(appGitRepo)
        AppConfig appConfig = initializeWorkdir.stage(initWorkDirIn)



//       docker.withDockerServer("tcp://build.docker.duvalhub.com:2376", "DOCKER_BUILD_BUNDLE") {
//             echo "we are here1"
//                 docker.image('node:16-alpine')
//                 .inside() { c ->
//                     sh "npm -v"
//                 }
//         }

        sh '''
        whoami
        echo uid
        id -u
        echo gid
        id -g
        pwd
        '''
        withDockerServer([uri: "tcp://build.docker.duvalhub.com:2376", credentialsId: "DOCKER_BUILD_BUNDLE"]) {
//         docker.withServer("tcp://build.docker.duvalhub.com:2376", "DOCKER_BUILD_BUNDLE") {
            echo "we are here"
            sh "env | grep -i docker"
            docker.image('duvalhub/node:16.rc1')
//                 .inside('--entrypoint "sleep 100000"') { c ->
//                 .inside('--entrypoint=') { c ->
                .inside() { c ->
//                     echo c
//                     sh "whoami"
//                     sh "env"
//                     sh "ls -l /usr/local/bin/npm"
//                     sh "/usr/local/bin/npm -v"
                    sh "whoami"
                }
        }

//         docker.image('node:16-alpine')
//         .withDockerServer([uri: "tcp://build.docker.duvalhub.com:2376", credentialsId: "DOCKER_BUILD_BUNDLE"])
//         .inside() { c ->
//             sh "npm -v"
//         }

        return

    }

}
