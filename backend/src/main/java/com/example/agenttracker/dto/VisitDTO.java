package com.example.agenttracker.dto;
import java.time.LocalDateTime;
import lombok.Data;

@Data
public class VisitDTO {
    private String note;
    private LocalDateTime date;
    private Long projectId;

}

