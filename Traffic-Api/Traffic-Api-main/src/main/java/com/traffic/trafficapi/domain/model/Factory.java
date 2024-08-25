package com.traffic.trafficapi.domain.model;

public class Factory {
    public static Facade newInstance(){
        return new Facade(new LearnSpring());
    }
}
