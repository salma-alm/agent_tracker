package com.example.agenttracker.service;

import com.example.agenttracker.dto.VisitDTO;
import com.example.agenttracker.model.Project;
import com.example.agenttracker.model.Visit;
import com.example.agenttracker.repository.ProjectRepository;
import com.example.agenttracker.repository.VisitRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class VisitService {

    private final VisitRepository visitRepository;
    private final ProjectRepository projectRepository;

    public VisitService(VisitRepository visitRepository, ProjectRepository projectRepository) {
        this.visitRepository = visitRepository;
        this.projectRepository = projectRepository;
    }

    public List<Visit> getAllVisits() {
        return visitRepository.findAll();
    }

    public List<Visit> getVisitsByProjectId(Long projectId) {
        return visitRepository.findByProjectId(projectId);
    }

    public Visit saveVisit(VisitDTO visitDTO) {
        Project project = projectRepository.findById(visitDTO.getProjectId())
                .orElseThrow(() -> new RuntimeException("Projet introuvable avec l'ID : " + visitDTO.getProjectId()));

        Visit visit = Visit.builder()
                .note(visitDTO.getNote())
                .date(visitDTO.getDate() != null ? visitDTO.getDate() : LocalDateTime.now())
                .project(project)
                .build();

        return visitRepository.save(visit);
    }
}
