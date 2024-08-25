package com.traffic.trafficapi.config;

import com.traffic.trafficapi.domain.model.Facade;
import com.traffic.trafficapi.domain.model.LearnSpring;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppBeans {
    @Bean
    public Facade getFacade() {
        return new Facade(new LearnSpring());
    }
}
