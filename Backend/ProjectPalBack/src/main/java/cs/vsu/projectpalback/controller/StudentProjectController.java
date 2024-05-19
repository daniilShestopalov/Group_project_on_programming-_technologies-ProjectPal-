package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.dto.ProjectDTO;
import cs.vsu.projectpalback.dto.StudentProjectDTO;
import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.service.StudentProjectService;
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
@RequestMapping("/student-project")
@Tag(name = "StudentProjectController", description = "Authorized users only.")
@AllArgsConstructor
public class StudentProjectController {

    private static final Logger LOGGER = LoggerFactory.getLogger(StudentProjectController.class);

    private final StudentProjectService studentProjectService;

    @GetMapping
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get all student projects", description = "Returns a list of all student projects")
    public ResponseEntity<List<StudentProjectDTO>> getAllStudentProjects() {
        try {
            LOGGER.info("Fetching all student projects");
            List<StudentProjectDTO> studentProjects = studentProjectService.getAllStudentProjects();
            return ResponseEntity.ok(studentProjects);
        } catch (Exception e) {
            LOGGER.error("Error fetching all student projects", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/student/{studentId}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get all student projects by student ID", description = "Returns a list of all student projects by student ID")
    public ResponseEntity<List<StudentProjectDTO>> getAllStudentProjectsByStudentId(@PathVariable Integer studentId) {
        try {
            LOGGER.info("Fetching student projects by student ID: {}", studentId);
            List<StudentProjectDTO> studentProjects = studentProjectService.getAllStudentProjectsByStudentId(studentId);
            return ResponseEntity.ok(studentProjects);
        } catch (Exception e) {
            LOGGER.error("Error fetching student projects by student ID: {}", studentId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/project/{projectId}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get all student projects by project ID", description = "Returns a list of all student projects by project ID")
    public ResponseEntity<List<StudentProjectDTO>> getAllStudentProjectsByProjectId(@PathVariable Integer projectId) {
        try {
            LOGGER.info("Fetching student projects by project ID: {}", projectId);
            List<StudentProjectDTO> studentProjects = studentProjectService.getAllStudentProjectsByProjectId(projectId);
            return ResponseEntity.ok(studentProjects);
        } catch (Exception e) {
            LOGGER.error("Error fetching student projects by project ID: {}", projectId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/students/{projectId}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get students by project ID", description = "Returns a list of students by project ID")
    public ResponseEntity<List<UserWithoutPasswordDTO>> getStudentsByProjectId(@PathVariable Integer projectId) {
        try {
            LOGGER.info("Fetching students by project ID: {}", projectId);
            List<UserWithoutPasswordDTO> students = studentProjectService.getStudentsByProjectId(projectId);
            return ResponseEntity.ok(students);
        } catch (Exception e) {
            LOGGER.error("Error fetching students by project ID: {}", projectId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/projects/{studentId}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get projects by student ID", description = "Returns a list of projects by student ID")
    public ResponseEntity<List<ProjectDTO>> getProjectsByStudentId(@PathVariable Integer studentId) {
        try {
            LOGGER.info("Fetching projects by student ID: {}", studentId);
            List<ProjectDTO> projects = studentProjectService.getProjectsByStudentId(studentId);
            return ResponseEntity.ok(projects);
        } catch (Exception e) {
            LOGGER.error("Error fetching projects by student ID: {}", studentId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get student project by ID", description = "Returns a student project by the given ID")
    public ResponseEntity<StudentProjectDTO> getStudentProjectById(@PathVariable Integer id) {
        try {
            LOGGER.info("Fetching student project with ID: {}", id);
            StudentProjectDTO studentProjectDTO = studentProjectService.getStudentProjectById(id);
            if (studentProjectDTO != null) {
                return ResponseEntity.ok(studentProjectDTO);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            LOGGER.error("Error fetching student project with ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('АДМИН', 'ПРЕПОДАВАТЕЛЬ')")
    @Operation(summary = "Create a new student project (admin, teacher)", description = "Creates a new student project")
    public ResponseEntity<StudentProjectDTO> createStudentProject(@RequestBody StudentProjectDTO studentProjectDTO) {
        try {
            LOGGER.info("Creating student project: {}", studentProjectDTO);
            StudentProjectDTO createdStudentProject = studentProjectService.createStudentProject(studentProjectDTO);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdStudentProject);
        } catch (Exception e) {
            LOGGER.error("Error creating student project", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('АДМИН', 'ПРЕПОДАВАТЕЛЬ')")
    @Operation(summary = "Delete a student project (admin, teacher)", description = "Deletes a student project by the given ID")
    public ResponseEntity<Void> deleteStudentProjectById(@PathVariable Integer id) {
        try {
            LOGGER.info("Deleting student project with ID: {}", id);
            boolean isDeleted = studentProjectService.deleteStudentProjectById(id);
            if (isDeleted) {
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting student project with ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
