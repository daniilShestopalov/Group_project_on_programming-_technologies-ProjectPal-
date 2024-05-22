package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.dto.TaskAnswerDTO;
import cs.vsu.projectpalback.dto.UserIdTaskIdDTO;
import cs.vsu.projectpalback.service.TaskAnswerService;
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
@RequestMapping("/task-answer")
@Tag(name = "TaskAnswerController", description = "Authorized users only.")
@AllArgsConstructor
public class TaskAnswerController {

    private static final Logger LOGGER = LoggerFactory.getLogger(TaskAnswerController.class);

    private final TaskAnswerService taskAnswerService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Get all task answers (admin, teacher)", description = "Returns a list of all task answers")
    public ResponseEntity<List<TaskAnswerDTO>> getAllTaskAnswers() {
        try {
            LOGGER.info("Fetching all task answers");
            List<TaskAnswerDTO> taskAnswers = taskAnswerService.getAllTaskAnswers();
            return ResponseEntity.ok(taskAnswers);
        } catch (Exception e) {
            LOGGER.error("Error fetching all task answers", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get task answer by ID", description = "Returns a task answer by the given ID")
    public ResponseEntity<TaskAnswerDTO> getTaskAnswerById(@PathVariable Integer id) {
        try {
            LOGGER.info("Fetching task answer by ID: {}", id);
            TaskAnswerDTO taskAnswer = taskAnswerService.getTaskAnswerById(id);
            if (taskAnswer != null) {
                return ResponseEntity.ok(taskAnswer);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            LOGGER.error("Error fetching task answer by ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/task/{taskId}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get task answers by task ID", description = "Returns a list of task answers by the given task ID")
    public ResponseEntity<List<TaskAnswerDTO>> getTaskAnswersByTaskId(@PathVariable Integer taskId) {
        try {
            LOGGER.info("Fetching task answers by task ID: {}", taskId);
            List<TaskAnswerDTO> taskAnswers = taskAnswerService.getTaskAnswersByTaskId(taskId);
            return ResponseEntity.ok(taskAnswers);
        } catch (Exception e) {
            LOGGER.error("Error fetching task answers by task ID: {}", taskId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/task/student")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get task answer by task ID and student ID", description = "Returns a task answer by the given task ID and student ID")
    public ResponseEntity<TaskAnswerDTO> getTaskAnswerByTaskIdAndStudentId(@RequestBody UserIdTaskIdDTO userIdTaskIdDTO) {
        Integer taskId = userIdTaskIdDTO.getTaskId();
        Integer studentId = userIdTaskIdDTO.getUserId();
        try {
            LOGGER.info("Fetching task answer by task ID: {} and student ID: {}", taskId, studentId);
            TaskAnswerDTO taskAnswer = taskAnswerService.getTaskAnswerByTaskIdAndStudentId(taskId, studentId);
            if (taskAnswer != null) {
                return ResponseEntity.ok(taskAnswer);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            LOGGER.error("Error fetching task answer by task ID: {} and student ID: {}", taskId, studentId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Create a new task answer (admin, teacher)", description = "Creates a new task answer")
    public ResponseEntity<TaskAnswerDTO> createTaskAnswer(@RequestBody TaskAnswerDTO taskAnswerDTO) {
        try {
            LOGGER.info("Creating task answer");
            TaskAnswerDTO createdTaskAnswer = taskAnswerService.createTaskAnswer(taskAnswerDTO);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdTaskAnswer);
        } catch (Exception e) {
            LOGGER.error("Error creating task answer", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PutMapping
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Update a task answer", description = "Updates an existing task answer")
    public ResponseEntity<TaskAnswerDTO> updateTaskAnswer(@RequestBody TaskAnswerDTO taskAnswerDTO) {
        try {
            LOGGER.info("Updating task answer with ID: {}", taskAnswerDTO.getId());
            TaskAnswerDTO updatedTaskAnswer = taskAnswerService.updateTaskAnswer(taskAnswerDTO);
            if (updatedTaskAnswer != null) {
                return ResponseEntity.ok(updatedTaskAnswer);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            LOGGER.error("Error updating task answer with ID: {}", taskAnswerDTO.getId(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Delete a task answer", description = "Deletes a task answer by the given ID")
    public ResponseEntity<Void> deleteTaskAnswer(@PathVariable Integer id) {
        try {
            LOGGER.info("Deleting task answer with ID: {}", id);
            boolean isDeleted = taskAnswerService.deleteTaskAnswer(id);
            if (isDeleted) {
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting task answer with ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
