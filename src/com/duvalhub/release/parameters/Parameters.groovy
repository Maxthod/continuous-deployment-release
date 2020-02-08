package com.duvalhub.release.parameters

class Parameters {

    String git_repository
    FlowType flow_type
    Version version

    Parameters(String git_repository, String flow_type, String version) {
        this.git_repository = git_repository
        this.flow_type = FlowType.fromString(flow_type)
        this.version = Version.fromString(version)
    }
}

enum FlowType {
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

enum Version {
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