package com.traffic.trafficapi.mapper;

import com.traffic.trafficapi.domain.dto.TrafficLightResponse;
import com.traffic.trafficapi.domain.model.Status;
import com.traffic.trafficapi.domain.model.TrafficLight;

import java.util.function.Function;

public class TrafficMapper {

    public static Function<TrafficLight, TrafficLightResponse> trafficModelToResponse() {

        Function<TrafficLight, TrafficLightResponse> modelToDtoMapper = new Function<TrafficLight, TrafficLightResponse>() {
            @Override
            public TrafficLightResponse apply(TrafficLight trafficLight) {
                Status status = trafficLight.getStatus() != null ? trafficLight.getStatus() : Status.defaultValue();
                return TrafficLightResponse.builder()
                        .id(trafficLight.getId())
                        .locationName(trafficLight.getLocationName())
                        .latitude(trafficLight.getLatitude())
                        .longitude(trafficLight.getLongitude())
                        .createdDate(trafficLight.getCreatedDate())
                        .updatedDate(trafficLight.getUpdatedAt())
                        .status(status.toString())
                        .build();
            }
        };

        return modelToDtoMapper;
    }



}
