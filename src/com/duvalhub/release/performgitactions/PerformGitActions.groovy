package com.duvalhub.release.performgitactions

import com.duvalhub.BaseObject
import com.duvalhub.appconfig.AppConfig
import com.duvalhub.release.parameters.Parameters
import com.duvalhub.git.GitCloneRequest
import com.duvalhub.initializeworkdir.InitializeWorkdirIn

class PerformGitActions extends BaseObject {
    Parameters parameters
    String app_workdir
    AppConfig app_config

    PerformGitActions(Parameters parameters, InitializeWorkdirIn initWorkDirIn, AppConfig appConfig) {
        this.parameters = parameters
        this.app_workdir = initWorkDirIn.appWorkdir
        this.app_config = appConfig
    }

    String getVersionControl() {
        return this.app_config.version_control
    }

    String getVersion() {
        return this.parameters.version
    }

}