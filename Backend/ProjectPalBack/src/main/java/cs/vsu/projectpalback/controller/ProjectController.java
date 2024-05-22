package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.dto.ProjectDTO;
import cs.vsu.projectpalback.dto.IdWithMonthDTO;
import cs.vsu.projectpalback.dto.IdWithTimeDateDTO;
import cs.vsu.projectpalback.service.ProjectService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.List;

@RestController
@RequestMapping("/project")
@Tag(name = "ProjectController", description = "Authorized users only.")
@AllArgsConstructor
public class ProjectController {

    private static final Logger LOGGER = LoggerFactory.getLogger(ProjectController.class);

    private final ProjectService projectService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all projects (admin)", description = "Returns a list of all projects")
    public ResponseEntity<List<ProjectDTO>> getAllProjects() {
        try {
            LOGGER.info("Fetching all projects");
            List<ProjectDTO> projects = projectService.getAllProjects();
            return ResponseEntity.ok(projects);
        } catch (Exception e) {
            LOGGER.error("Error fetching all projects", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/ids")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get projects by IDs", description = "Returns a list of projects by their IDs")
    public ResponseEntity<List<ProjectDTO>> getAllProjectsByProjectId(@RequestParam List<Integer> ids) {
        try {
            LOGGER.info("Fetching projects by IDs: {}", ids);
            List<ProjectDTO> projects = projectService.getAllProjectsByProjectId(ids);
            return ResponseEntity.ok(projects);
        } catch (Exception e) {
            LOGGER.error("Error fetching projects by IDs: {}", ids, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/teacher/date-time")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Get projects by date and teacher ID (admin, teacher)", description = "Returns a list of projects by the given date and teacher ID")
    public ResponseEntity<List<ProjectDTO>> getProjectsByDateAndTeacherId(@RequestBody IdWithTimeDateDTO teacherWithTimeDateDTO) {
        Integer teacherId = teacherWithTimeDateDTO.getId();
        LocalDateTime date = teacherWithTimeDateDTO.getDate();
        try {
            LOGGER.info("Fetching projects by date: {} and teacher ID: {}", date, teacherId);
            List<ProjectDTO> projects = projectService.getProjectsByDateAndTeacherId(teacherId, date);
            return ResponseEntity.ok(projects);
        } catch (Exception e) {
            LOGGER.error("Error fetching projects by date: {} and teacher ID: {}", date, teacherId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/teacher/month")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Get projects by month and teacher ID (admin, teacher)", description = "Returns a list of projects by the given month and teacher ID")
    public ResponseEntity<List<ProjectDTO>> getProjectsByMonthAndTeacherId(@RequestBody IdWithMonthDTO teacherWithMonthDTO) {
        Integer teacherId = teacherWithMonthDTO.getId();
        YearMonth month = teacherWithMonthDTO.getYearMonth();
        try {
            LOGGER.info("Fetching projects by month: {} and teacher ID: {}", month, teacherId);
            List<ProjectDTO> projects = projectService.getProjectsByMonthAndTeacherId(teacherId, month);
            return ResponseEntity.ok(projects);
        } catch (Exception e) {
            LOGGER.error("Error fetching projects by month: {} and teacher ID: {}", month, teacherId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/teacher/{teacherId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Get all projects by teacher ID (admin, teacher)", description = "Returns a list of all projects by the given teacher ID")
    public ResponseEntity<List<ProjectDTO>> getAllProjectsByTeacherId(@PathVariable Integer teacherId) {
        try {
            LOGGER.info("Fetching projects by teacher ID: {}", teacherId);
            List<ProjectDTO> projects = projectService.getAllProjectsByTeacherId(teacherId);
            return ResponseEntity.ok(projects);
        } catch (Exception e) {
            LOGGER.error("Error fetching projects by teacher ID: {}", teacherId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/student/date-time")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get projects by student ID and date", description = "Returns a list of projects by the given student ID and date")
    public ResponseEntity<List<ProjectDTO>> getProjectsByStudentIdAndDate(@RequestBody IdWithTimeDateDTO idWithTimeDateDTO) {
        Integer studentId = idWithTimeDateDTO.getId();
        LocalDateTime date = idWithTimeDateDTO.getDate();
        try {
            LOGGER.info("Fetching projects by student ID: {} and date: {}", studentId, date);
            List<ProjectDTO> projects = projectService.getProjectsByStudentIdAndDate(studentId, date);
            return ResponseEntity.ok(projects);
        } catch (Exception e) {
            LOGGER.error("Error fetching projects by student ID: {} and date: {}", studentId, date, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/student/month")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get projects by student ID and month", description = "Returns a list of projects by the given student ID and month")
    public ResponseEntity<List<ProjectDTO>> getProjectsByStudentIdAndMonth(@RequestBody IdWithMonthDTO idWithMonthDTO) {
        Integer studentId = idWithMonthDTO.getId();
        YearMonth month = idWithMonthDTO.getYearMonth();
        try {
            LOGGER.info("Fetching projects by student ID: {} and month: {}", studentId, month);
            List<ProjectDTO> projects = projectService.getProjectsByStudentIdAndMonth(studentId, month);
            return ResponseEntity.ok(projects);
        } catch (Exception e) {
            LOGGER.error("Error fetching projects by student ID: {} and month: {}", studentId, month, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get project by ID", description = "Returns a project by the given ID")
    public ResponseEntity<ProjectDTO> getProjectById(@PathVariable Integer id) {
        try {
            LOGGER.info("Fetching project by ID: {}", id);
            ProjectDTO project = projectService.getProjectById(id);
            if (project != null) {
                return ResponseEntity.ok(project);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            LOGGER.error("Error fetching project by ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Create a new project (admin, teacher)", description = "Creates a new project")
    public ResponseEntity<ProjectDTO> createProject(@RequestBody ProjectDTO projectDTO) {
        try {
            LOGGER.info("Creating project");
            ProjectDTO createdProject = projectService.createProject(projectDTO);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdProject);
        } catch (Exception e) {
            LOGGER.error("Error creating project", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PutMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Update a project (admin, teacher)", description = "Updates an existing project")
    public ResponseEntity<ProjectDTO> updateProject(@RequestBody ProjectDTO projectDTO) {
        try {
            LOGGER.info("Updating project with ID: {}", projectDTO.getId());
            ProjectDTO updatedProject = projectService.updateProject(projectDTO);
            if (updatedProject != null) {
                return ResponseEntity.ok(updatedProject);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            LOGGER.error("Error updating project with ID: {}", projectDTO.getId(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Delete a project (admin, teacher)", description = "Deletes a project by the given ID")
    public ResponseEntity<Void> deleteProject(@PathVariable Integer id) {
        try {
            LOGGER.info("Deleting project with ID: {}", id);
            boolean isDeleted = projectService.deleteProject(id);
            if (isDeleted) {
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting project with ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/teacher/{teacherId}/count")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Count projects by teacher ID", description = "Returns the number of projects for a given teacher ID")
    public ResponseEntity<Long> countProjectsByTeacherId(@PathVariable Integer teacherId) {
        try {
            LOGGER.info("Counting projects by teacher ID: {}", teacherId);
            long count = projectService.countProjectsByTeacherId(teacherId);
            return ResponseEntity.ok(count);
        } catch (Exception e) {
            LOGGER.error("Error counting projects by teacher ID: {}", teacherId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/student/{studentId}/count")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Count projects by student ID", description = "Returns the number of projects for a given student ID")
    public ResponseEntity<Long> countProjectsByStudentId(@PathVariable Integer studentId) {
        try {
            LOGGER.info("Counting projects by student ID: {}", studentId);
            long count = projectService.countProjectsByStudentId(studentId);
            return ResponseEntity.ok(count);
        } catch (Exception e) {
            LOGGER.error("Error counting projects by student ID: {}", studentId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

}
