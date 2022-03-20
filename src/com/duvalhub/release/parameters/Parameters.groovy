package com.duvalhub.release.parameters
import java.util.Collections.UnmodifiableMap;
class Parameters {

    String git_repository
    String flow_type
    String version
    Boolean dry_run

    Parameters(params) {
        this.git_repository = params.GIT_REPOSITORY
        this.flow_type = params.FLOW_TYPE
        this.version = params.VERSION
        this.dry_run = params.DRY_RUN
    }

    Boolean isDryRun() {
        return this.git_repository == '' || this.flow_type == '' || this.version == '' || dry_run
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