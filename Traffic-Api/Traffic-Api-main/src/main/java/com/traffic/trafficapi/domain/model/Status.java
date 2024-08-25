package com.traffic.trafficapi.domain.model;

public enum Status {
    RED, GREEN, YELLOW, UNKNOWN;

    public static Status defaultValue() {
        return UNKNOWN;
    }

    }
