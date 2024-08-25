package com.traffic.trafficapi.domain.dto;

import lombok.Getter;
import lombok.Setter;
import org.antlr.v4.runtime.misc.NotNull;

@Getter
@Setter
public class UpdateTrafficLight {
    @NotNull
    private Long trafficLightId;
    private String latitude;
    private String longitude;
    private String locationName;
    @NotNull
    private String status;
}
