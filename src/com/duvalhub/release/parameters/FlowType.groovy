package com.duvalhub.release.parameters

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