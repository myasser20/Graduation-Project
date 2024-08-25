package com.traffic.trafficapi.controller;

import com.traffic.trafficapi.domain.dto.CreateTrafficLight;
import com.traffic.trafficapi.domain.dto.CreateTrafficLightDependency;
import com.traffic.trafficapi.domain.dto.TrafficLightResponse;
import com.traffic.trafficapi.domain.dto.UpdateTrafficLight;
import com.traffic.trafficapi.domain.model.Status;
import com.traffic.trafficapi.domain.model.TrafficLight;
import com.traffic.trafficapi.mapper.TrafficMapper;
import com.traffic.trafficapi.service.TrafficLightService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

@RestController
@RequestMapping(path = "/api/v1/trafficlight")
@AllArgsConstructor
public class TrafficLightController {

    private final TrafficLightService trafficLightService;

    @PostMapping
    public ResponseEntity<String> postTrafficLight(@RequestBody CreateTrafficLight trafficLight) {
        if (trafficLight.getLatitude() == null || trafficLight.getLongitude() == null || trafficLight.getStatus() == null) {
            return ResponseEntity.badRequest().build();
        }

        trafficLightService.saveTrafficLight(trafficLight);
        return ResponseEntity.ok("Traffic light saved");
    }

    @GetMapping
    public ResponseEntity<List<TrafficLightResponse>> getAllTrafficLights() {

        List<TrafficLight> trafficLightList = trafficLightService.getTrafficLights();

        return ResponseEntity.ok(trafficLightList
                .stream()
                .map(TrafficMapper.trafficModelToResponse())
                .collect(Collectors.toList()));
    }

    @GetMapping("location/{location}")
    public ResponseEntity<List<TrafficLightResponse>> getAllTrafficLightsByLocation(@PathVariable String location) {

        List<TrafficLight> trafficLightList = trafficLightService.getTrafficLightsByLocationName(location);

        return ResponseEntity.ok(trafficLightList
                .stream()
                .map(TrafficMapper.trafficModelToResponse())
                .collect(Collectors.toList()));
    }

    @GetMapping(path = "one/{id}")
    public ResponseEntity<TrafficLightResponse>  getTrafficLightById(@PathVariable Long id) {
        var trafficLight = trafficLightService.getTrafficLight(id);

        if (!trafficLight.isPresent()){
            return ResponseEntity.notFound().build();
        }

        TrafficLightResponse trafficLightResponse = TrafficMapper.trafficModelToResponse().apply(trafficLight.get());
        return ResponseEntity.ok(trafficLightResponse);
    }
    @DeleteMapping
    public ResponseEntity<String> deleteTrafficLight(@RequestParam Long id){
        if (id== null || id==0){
            return ResponseEntity.badRequest().body("please enter a correct id");
        }
        trafficLightService.deleteTrafficLight(id);
        return ResponseEntity.ok("Traffic light deleted");
    }

    @PostMapping("dependencies")
    public ResponseEntity<String> createTrafficDependecies(@RequestBody CreateTrafficLightDependency dependencies) {
        if (dependencies == null) {
            return ResponseEntity.badRequest().body("please enter a correct dependencies");
        }
        trafficLightService.createDependencies(dependencies);
        return ResponseEntity.ok("Traffic dependecies created");
    }

    @GetMapping("getTrafficLightNeighbours/{id}")
    public ResponseEntity<List<TrafficLightResponse>> createTrafficDependecies(@PathVariable Long id) {
        List<TrafficLight> neighbourTrafficLightList = trafficLightService.getNeighbouringTrafficLights(id);
        if (neighbourTrafficLightList == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(neighbourTrafficLightList
                .stream()
                .map(TrafficMapper.trafficModelToResponse())
                .collect(Collectors.toList()));

    }

    @PutMapping
    public ResponseEntity<String> updateTrafficLight(@RequestBody UpdateTrafficLight updateTrafficLight) {

        boolean updated = trafficLightService.updateTrafficLight(updateTrafficLight);
        if (updated)
            return ResponseEntity.ok("Update traffic light successful");
        else
            return ResponseEntity.badRequest().build();
    }

    @GetMapping("updateNeighboursToRedAndMainToGreen/{id}")
    public ResponseEntity<String> updateNeighboursToRedAndMainToGreen(@PathVariable Long id) {

        boolean updated = trafficLightService.updateNeighboursToRedAndMainToGreen(id);
        if (updated)
            return ResponseEntity.ok("Update neighbouring traffic light to red successfully and main to green");
        else
            return ResponseEntity.badRequest().build();
    }

    @GetMapping("updateNeighboursAndMainToLastStatus/{id}")
    public ResponseEntity<String> updateNeighboursAndMainToLastStatus(@PathVariable Long id) {
        boolean updated = trafficLightService.updateNeighboursAndMainToLastStatus(id);
        if (updated)
            return ResponseEntity.ok("Update neighbouring and main traffic light to last status successfully");
        else
            return ResponseEntity.badRequest().build();
    }

}
