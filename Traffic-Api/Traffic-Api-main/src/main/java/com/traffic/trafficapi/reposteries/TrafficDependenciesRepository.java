package com.traffic.trafficapi.reposteries;

import com.traffic.trafficapi.domain.model.TrafficDependencies;
import com.traffic.trafficapi.domain.model.TrafficLight;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface TrafficDependenciesRepository extends JpaRepository<TrafficDependencies, Long> {

    @Query("SELECT td.neighbourTraffic FROM TrafficDependencies td WHERE td.mainTraffic.id = :mainTrafficLightId")
    List<TrafficLight> findNeighboursByMainTrafficLightId(Long mainTrafficLightId);

    @Query("SELECT td FROM TrafficDependencies td WHERE td.mainTraffic.id = :mainTrafficId AND td.neighbourTraffic.id = :neighbourTrafficId")
    TrafficDependencies findByMainTrafficIdAndNeighbourTrafficId(@Param("mainTrafficId") Long mainTrafficId, @Param("neighbourTrafficId") Long neighbourTrafficId);

}
