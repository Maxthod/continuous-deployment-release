package com.duvalhub.release.parameters

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