package com.traffic.trafficapi.domain.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Table(name = "traffic_light")
@Entity
@Getter
@Setter
@ToString
public class TrafficLight {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "longitude")
    public String longitude;
    @Column(name = "latitude")
    public String latitude;
    @Column(name = "device_id")
    public String deviceId;
    @Column(name = "location_name")
    public String locationName;
    @CreationTimestamp
    public LocalDateTime createdDate;
    @UpdateTimestamp
    public LocalDateTime updatedAt;
    @Enumerated(EnumType.STRING)
    private Status status;
    @Enumerated(EnumType.STRING)
    private Status lastStatus;


}
