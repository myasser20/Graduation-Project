package com.traffic.trafficapi.domain.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

public class CreateTrafficLight {
    private String latitude;
    private String longitude;
    private String locationName;
    private String status;
}
