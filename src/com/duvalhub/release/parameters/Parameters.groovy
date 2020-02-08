package com.duvalhub.release.parameters

class Parameters {

    String git_repository
    FlowType flow_type
    Version version

    Parameters(String git_repository, String flow_type, String version) {
        this.git_repository = git_repository
        this.flow_type = flow_type.toUpperCase() as FlowType
        this.version = version.toUpperCase() as Version
    }
}

enum FlowType {
    RELEASE, PRODUCTION
    FlowType(){}
}

enum Version {
    PATCH,
    MINOR,
    MAJOR
    Version() {}
}