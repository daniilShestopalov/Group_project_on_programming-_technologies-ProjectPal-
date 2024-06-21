package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.dto.IdWithMonthDTO;
import cs.vsu.projectpalback.dto.IdWithTimeDateDTO;
import cs.vsu.projectpalback.dto.TaskDTO;
import cs.vsu.projectpalback.service.TaskService;
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
@RequestMapping("/task")
@Tag(name = "TaskController", description = "Authorized users only.")
@AllArgsConstructor
public class TaskController {

    private static final Logger LOGGER = LoggerFactory.getLogger(TaskController.class);

    private final TaskService taskService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Get all tasks (admin, teacher)", description = "Returns a list of all tasks")
    public ResponseEntity<List<TaskDTO>> getAllTasks() {
        try {
            LOGGER.info("Fetching all tasks");
            List<TaskDTO> tasks = taskService.getAllTasks();
            return ResponseEntity.ok(tasks);
        } catch (Exception e) {
            LOGGER.error("Error fetching all tasks", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/group/{groupId}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get tasks by group ID", description = "Returns a list of tasks by the given group ID")
    public ResponseEntity<List<TaskDTO>> getTasksByGroupId(@PathVariable Integer groupId) {
        try {
            LOGGER.info("Fetching tasks by group ID: {}", groupId);
            List<TaskDTO> tasks = taskService.getTasksByGroupId(groupId);
            return ResponseEntity.ok(tasks);
        } catch (Exception e) {
            LOGGER.error("Error fetching tasks by group ID: {}", groupId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/teacher/{teacherId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Get tasks by teacher ID (admin, teacher)", description = "Returns a list of tasks by the given teacher ID")
    public ResponseEntity<List<TaskDTO>> getTasksByTeacherId(@PathVariable Integer teacherId) {
        try {
            LOGGER.info("Fetching tasks by teacher ID: {}", teacherId);
            List<TaskDTO> tasks = taskService.getTasksByTeacherId(teacherId);
            return ResponseEntity.ok(tasks);
        } catch (Exception e) {
            LOGGER.error("Error fetching tasks by teacher ID: {}", teacherId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping("/group/date")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get tasks by date and group", description = "Returns a list of tasks by the given date and group ID")
    public ResponseEntity<List<TaskDTO>> getTasksByDateAndGroup(@RequestBody IdWithTimeDateDTO idWithTimeDateDTO) {
        Integer groupId = idWithTimeDateDTO.getId();
        LocalDateTime date = idWithTimeDateDTO.getDate();
        try {
            LOGGER.info("Fetching tasks by date: {} and group ID: {}", date, groupId);
            List<TaskDTO> tasks = taskService.getTasksByDateAndGroup(groupId, date);
            return ResponseEntity.ok(tasks);
        } catch (Exception e) {
            LOGGER.error("Error fetching tasks by date: {} and group ID: {}", date, groupId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping("/group/month")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get tasks by month and group", description = "Returns a list of tasks by the given month and group ID")
    public ResponseEntity<List<TaskDTO>> getTasksByMonthAndGroup(@RequestBody IdWithMonthDTO idWithMonthDTO) {
        Integer groupId = idWithMonthDTO.getId();
        YearMonth month = idWithMonthDTO.getYearMonth();
        try {
            LOGGER.info("Fetching tasks by month: {} and group ID: {}", month, groupId);
            List<TaskDTO> tasks = taskService.getTasksByMonthAndGroup(groupId, month);
            return ResponseEntity.ok(tasks);
        } catch (Exception e) {
            LOGGER.error("Error fetching tasks by month: {} and group ID: {}", month, groupId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping("/teacher/date")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Get tasks by date and teacher (admin, teacher)", description = "Returns a list of tasks by the given date and teacher ID")
    public ResponseEntity<List<TaskDTO>> getTasksByDateAndTeacher(@RequestBody IdWithTimeDateDTO idWithTimeDateDTO) {
        Integer teacherId = idWithTimeDateDTO.getId();
        LocalDateTime date = idWithTimeDateDTO.getDate();
        try {
            LOGGER.info("Fetching tasks by date: {} and teacher ID: {}", date, teacherId);
            List<TaskDTO> tasks = taskService.getTasksByDateAndTeacher(teacherId, date);
            return ResponseEntity.ok(tasks);
        } catch (Exception e) {
            LOGGER.error("Error fetching tasks by date: {} and teacher ID: {}", date, teacherId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping("/teacher/month")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Get tasks by month and teacher (admin, teacher)", description = "Returns a list of tasks by the given month and teacher ID")
    public ResponseEntity<List<TaskDTO>> getTasksByMonthAndTeacher(@RequestBody IdWithMonthDTO idWithMonthDTO) {
        Integer teacherId = idWithMonthDTO.getId();
        YearMonth month = idWithMonthDTO.getYearMonth();
        try {
            LOGGER.info("Fetching tasks by month: {} and teacher ID: {}", month, teacherId);
            List<TaskDTO> tasks = taskService.getTasksByMonthAndTeacher(teacherId, month);
            return ResponseEntity.ok(tasks);
        } catch (Exception e) {
            LOGGER.error("Error fetching tasks by month: {} and teacher ID: {}", month, teacherId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get task by ID", description = "Returns a task by the given ID")
    public ResponseEntity<TaskDTO> getTaskById(@PathVariable Integer id) {
        try {
            LOGGER.info("Fetching task by ID: {}", id);
            TaskDTO task = taskService.getTaskById(id);
            if (task != null) {
                return ResponseEntity.ok(task);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            LOGGER.error("Error fetching task by ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Create a new task (admin, teacher)", description = "Creates a new task")
    public ResponseEntity<TaskDTO> createTask(@RequestBody TaskDTO taskDTO) {
        try {
            LOGGER.info("Creating task");
            TaskDTO createdTask = taskService.createTask(taskDTO);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdTask);
        } catch (Exception e) {
            LOGGER.error("Error creating task", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PutMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Update a task (admin, teacher)", description = "Updates an existing task")
    public ResponseEntity<TaskDTO> updateTask(@RequestBody TaskDTO taskDTO) {
        try {
            LOGGER.info("Updating task with ID: {}", taskDTO.getId());
            TaskDTO updatedTask = taskService.updateTask(taskDTO);
            if (updatedTask != null) {
                return ResponseEntity.ok(updatedTask);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            LOGGER.error("Error updating task with ID: {}", taskDTO.getId(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Delete a task (admin, teacher)", description = "Deletes a task by the given ID")
    public ResponseEntity<Void> deleteTask(@PathVariable Integer id) {
        try {
            LOGGER.info("Deleting task with ID: {}", id);
            boolean isDeleted = taskService.deleteTask(id);
            if (isDeleted) {
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting task with ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/group/{groupId}/count")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Count tasks by group ID", description = "Returns the number of tasks by the given group ID")
    public ResponseEntity<Long> countTasksByGroupId(@PathVariable Integer groupId) {
        try {
            LOGGER.info("Counting tasks by group ID: {}", groupId);
            long count = taskService.countTasksByGroupId(groupId);
            return ResponseEntity.ok(count);
        } catch (Exception e) {
            LOGGER.error("Error counting tasks by group ID: {}", groupId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/teacher/{teacherId}/count")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation()
    public ResponseEntity<Long> countTasksByTeacher(@PathVariable Integer teacherId) {
        try {
            LOGGER.info("Counting tasks by teacher ID: {}", teacherId);
            Long count = taskService.countTasksByTeacherId(teacherId);
            return ResponseEntity.ok(count);
        } catch (Exception e) {
            LOGGER.error("Error counting tasks by teacher ID: {}", teacherId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
