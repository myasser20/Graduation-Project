package com.traffic.trafficapi.service;

import com.traffic.trafficapi.domain.dto.CreateTrafficLight;
import com.traffic.trafficapi.domain.dto.CreateTrafficLightDependency;
import com.traffic.trafficapi.domain.dto.UpdateTrafficLight;
import com.traffic.trafficapi.domain.model.TrafficLight;

import java.util.List;
import java.util.Optional;

public interface TrafficLightService {
    void saveTrafficLight(CreateTrafficLight trafficLight);
    List<TrafficLight> getTrafficLights();
    Optional<TrafficLight> getTrafficLight(Long id);
    void deleteTrafficLight(Long id);
    List<TrafficLight> getTrafficLightsByLocationName(String locationName);
    void createDependencies(CreateTrafficLightDependency dependencies);
    List<TrafficLight> getNeighbouringTrafficLights(Long id);
    boolean updateTrafficLight(UpdateTrafficLight trafficLight);
    boolean updateNeighboursToRedAndMainToGreen(Long id);
    boolean updateNeighboursAndMainToLastStatus(Long id);
}
