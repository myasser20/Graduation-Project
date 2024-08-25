package com.traffic.trafficapi.domain.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@Setter
@ToString
@Builder
public class TrafficLightResponse {
    private Long id;
    private String latitude;
    private String longitude;
    private String locationName;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;
    private String status;
}
