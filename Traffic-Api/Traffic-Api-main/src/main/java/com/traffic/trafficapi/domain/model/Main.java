package com.traffic.trafficapi.domain.model;

public class Main {
    public static void main(String[] args) {
        var facade = Factory.newInstance();
        System.out.println(facade.getTrafficLightName());
    }
}
