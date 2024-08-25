package com.traffic.trafficapi.domain.model;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class Facade {
    private final LearnSpring learnSpring;

    public String getTrafficLightName(){
        return learnSpring.getTrafficName();
    }
}
