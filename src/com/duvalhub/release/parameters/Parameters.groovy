package com.duvalhub.release.parameters

class Parameters {

    String git_repository
    FlowType flow_type
    Version version

    Parameters(String git_repository, FlowType flow_type, Version version) {
        this.git_repository = git_repository
        this.flow_type = flow_type
        this.version = version
    }
}

static enum FlowType {
    RELEASE, PRODUCTION
    FlowType(){}
        public static FlowType fromString(String text) {
        for (FlowType b : FlowType.values()) {
            if (b.text.equalsIgnoreCase(text)) {
                return b;
            }
        }
        return null;
    }
}

static enum Version {
    PATCH,
    MINOR,
    MAJOR
    Version() {}

    public static Version fromString(String text) {
        for (Version b : Version.values()) {
            if (b.text.equalsIgnoreCase(text)) {
                return b;
            }
        }
        return null;
    }    
}