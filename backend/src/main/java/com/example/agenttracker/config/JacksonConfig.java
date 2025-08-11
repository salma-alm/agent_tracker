package com.example.agenttracker.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.Module;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class JacksonConfig {

    @Bean
    public ObjectMapper objectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        // Supporter Java 8 date/time
        mapper.registerModule(new JavaTimeModule());
        // Ne pas échouer sur les beans vides (ex : proxies Hibernate)
        mapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
        // Facultatif : désactiver écriture des dates en timestamps
        mapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
        return mapper;
    }
}
