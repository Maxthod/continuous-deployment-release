package com.duvalhub.release.performgitactions

import com.duvalhub.release.parameters.Parameters
import com.duvalhub.gitclone.GitCloneRequest

class PerformGitActions {

    String app_workdir

    PerformGitActions(Parameters parameters, GitCloneRequest appGitCloneRequest) {
        this.app_workdir = appGitCloneRequest.directory
    }

}