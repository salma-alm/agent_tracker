package com.example.agenttracker.controller;

import com.example.agenttracker.model.Visit;
import com.example.agenttracker.service.VisitService;
import com.example.agenttracker.dto.VisitDTO;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;

import java.util.List;

@RestController
@RequestMapping("/api/visits")
@CrossOrigin(origins = "*")
public class VisitController {
    private final VisitService visitService;

    public VisitController(VisitService visitService) {
        this.visitService = visitService;
    }

    @GetMapping
    public List<Visit> getAllVisits() {
        return visitService.getAllVisits();
    }

    @GetMapping("/project/{projectId}")
    public List<Visit> getVisitsByProject(@PathVariable Long projectId) {
        return visitService.getVisitsByProjectId(projectId);
    }


    @PostMapping
    public ResponseEntity<Visit> createVisit(@RequestBody VisitDTO visitDTO) {
        Visit visit = visitService.saveVisit(visitDTO);
        return ResponseEntity.ok(visit);
    }
}

