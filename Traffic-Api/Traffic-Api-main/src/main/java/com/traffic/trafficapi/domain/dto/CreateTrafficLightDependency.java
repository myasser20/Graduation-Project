package com.traffic.trafficapi.domain.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.util.Pair;

import java.util.HashMap;
import java.util.List;

@Getter
@Setter
public class CreateTrafficLightDependency {
    private List<Pair<Long, Long>> trafficLightsDependecies;

}
