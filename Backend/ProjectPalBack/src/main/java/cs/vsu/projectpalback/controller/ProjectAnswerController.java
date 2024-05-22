package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.dto.ProjectAnswerDTO;
import cs.vsu.projectpalback.service.ProjectAnswerService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/project-answer")
@Tag(name = "ProjectAnswerController", description = "Authorized users only.")
@AllArgsConstructor
public class ProjectAnswerController {

    private static final Logger LOGGER = LoggerFactory.getLogger(ProjectAnswerController.class);

    private final ProjectAnswerService projectAnswerService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Get all project answers (admin, teacher)", description = "Returns a list of all project answers")
    public ResponseEntity<List<ProjectAnswerDTO>> getAllProjectAnswers() {
        try {
            LOGGER.info("Fetching all project answers");
            List<ProjectAnswerDTO> projectAnswers = projectAnswerService.getAllProjectAnswers();
            return ResponseEntity.ok(projectAnswers);
        } catch (Exception e) {
            LOGGER.error("Error fetching all project answers", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get project answer by ID", description = "Returns a project answer by the given ID")
    public ResponseEntity<ProjectAnswerDTO> getProjectAnswerById(@PathVariable Integer id) {
        try {
            LOGGER.info("Fetching project answer by ID: {}", id);
            ProjectAnswerDTO projectAnswer = projectAnswerService.getProjectAnswerById(id);
            if (projectAnswer != null) {
                return ResponseEntity.ok(projectAnswer);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            LOGGER.error("Error fetching project answer by ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/project/{projectId}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get project answer by project ID", description = "Returns a project answer by the given project ID")
    public ResponseEntity<ProjectAnswerDTO> getProjectAnswerByProjectId(@PathVariable Integer projectId) {
        try {
            LOGGER.info("Fetching project answer by project ID: {}", projectId);
            ProjectAnswerDTO projectAnswer = projectAnswerService.getProjectAnswerByProjectId(projectId);
            if (projectAnswer != null) {
                return ResponseEntity.ok(projectAnswer);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            LOGGER.error("Error fetching project answer by project ID: {}", projectId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Create a new project answer (admin, teacher)", description = "Creates a new project answer")
    public ResponseEntity<ProjectAnswerDTO> createProjectAnswer(@RequestBody ProjectAnswerDTO projectAnswerDTO) {
        try {
            LOGGER.info("Creating project answer");
            ProjectAnswerDTO createdProjectAnswer = projectAnswerService.createProjectAnswer(projectAnswerDTO);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdProjectAnswer);
        } catch (Exception e) {
            LOGGER.error("Error creating project answer", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PutMapping
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Update a project answer", description = "Updates an existing project answer")
    public ResponseEntity<ProjectAnswerDTO> updateProjectAnswer(@RequestBody ProjectAnswerDTO projectAnswerDTO) {
        try {
            LOGGER.info("Updating project answer with ID: {}", projectAnswerDTO.getId());
            ProjectAnswerDTO updatedProjectAnswer = projectAnswerService.updateProjectAnswer(projectAnswerDTO);
            if (updatedProjectAnswer != null) {
                return ResponseEntity.ok(updatedProjectAnswer);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            LOGGER.error("Error updating project answer with ID: {}", projectAnswerDTO.getId(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Delete a project answer (admin, teacher)", description = "Deletes a project answer by the given ID")
    public ResponseEntity<Void> deleteProjectAnswer(@PathVariable Integer id) {
        try {
            LOGGER.info("Deleting project answer with ID: {}", id);
            boolean isDeleted = projectAnswerService.deleteProjectAnswer(id);
            if (isDeleted) {
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting project answer with ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

}
