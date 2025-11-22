package com.pii.java_service.model;

public class ValidationResults {

    private final boolean isValid;
    private final String errorMessage;

    public ValidationResults(boolean isValid, String errorMessage) {
        this.isValid = isValid;
        this.errorMessage = errorMessage;
    }

    public ValidationResults(boolean isValid) {
        this(isValid, null);
    }

    public boolean isValid() {
        return isValid;
    }

    public String getErrorMessage() {
        return errorMessage;
    }
}

