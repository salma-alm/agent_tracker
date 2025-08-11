package com.example.agenttracker.repository;

import com.example.agenttracker.model.Visit;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface VisitRepository extends JpaRepository<Visit, Long> {
    List<Visit> findByProjectId(Long projectId);
}
