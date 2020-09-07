package com.duvalhub.release.performgitactions

import com.duvalhub.BaseObject
import com.duvalhub.appconfig.AppConfig
import com.duvalhub.release.parameters.Parameters
import com.duvalhub.initializeworkdir.InitializeWorkdirIn
import com.duvalhub.appconfig.AppConfigAccessor

class PerformGitActions extends AppConfigAccessor {
    Parameters parameters
    String app_workdir

    PerformGitActions(Parameters parameters, InitializeWorkdirIn initWorkDirIn, AppConfig appConfig) {
        super(appConfig)
        this.parameters = parameters
        this.app_workdir = initWorkDirIn.appWorkdir
    }

    String getVersion() {
        return this.parameters.version
    }

    String getFlowType() {
        return this.parameters.flow_type
    }

    String getGitUri() {
        return this.parameters.git_repository
    }

}
