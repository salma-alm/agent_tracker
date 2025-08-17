package com.example.agenttracker.dto;
import java.time.LocalDate;
import lombok.Data;

@Data
public class VisitDTO {
    private String note;
    private LocalDate date;
    private Long projectId;

}

