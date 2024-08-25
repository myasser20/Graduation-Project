package com.traffic.trafficapi.reposteries;

import com.traffic.trafficapi.domain.model.TrafficLight;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface TrafficLightRepository extends JpaRepository<TrafficLight, Long> {
    List<TrafficLight> findTrafficLightByCreatedDateBetween(LocalDateTime from, LocalDateTime to);
    List<TrafficLight> findTrafficLightByLocationName(String LocationName);
}
