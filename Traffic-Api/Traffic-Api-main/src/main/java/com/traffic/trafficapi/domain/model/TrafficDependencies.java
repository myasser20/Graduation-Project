package com.traffic.trafficapi.domain.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Table(name = "traffic_dependencies")
@Entity
@Getter
@Setter
@ToString
public class TrafficDependencies {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "main_traffic_id")
    private TrafficLight mainTraffic;

    @ManyToOne
    @JoinColumn(name = "neighbour_traffic_id")
    private TrafficLight neighbourTraffic;
}
