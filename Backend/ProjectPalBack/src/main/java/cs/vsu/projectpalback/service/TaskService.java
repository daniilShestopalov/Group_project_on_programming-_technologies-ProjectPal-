package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.TaskDTO;
import cs.vsu.projectpalback.mapper.TaskMapper;
import cs.vsu.projectpalback.model.Task;
import cs.vsu.projectpalback.repository.TaskRepository;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class TaskService {

    private static final Logger LOGGER = LoggerFactory.getLogger(TaskService.class);

    private final TaskRepository taskRepository;

    private final TaskMapper taskMapper;

    public List<TaskDTO> getAllTasks() {
        LOGGER.info("Fetching all tasks");
        List<Task> tasks = taskRepository.findAll();
        return taskMapper.toDtoList(tasks);
    }

    public List<TaskDTO> getTasksByGroupId(Integer groupId) {
        LOGGER.info("Fetching tasks by group ID: {}", groupId);
        List<Task> tasks = taskRepository.findByGroupId(groupId);
        return taskMapper.toDtoList(tasks);
    }

    public List<TaskDTO> getTasksByTeacherId(Integer teacherId) {
        LOGGER.info("Fetching tasks by teacher ID: {}", teacherId);
        List<Task> tasks = taskRepository.findByTeacherId(teacherId);
        return taskMapper.toDtoList(tasks);
    }

    public TaskDTO getTaskById(Integer id) {
        LOGGER.info("Fetching task by ID: {}", id);
        Optional<Task> taskOptional = taskRepository.findById(id);
        if (taskOptional.isPresent()) {
            LOGGER.info("Task found by ID: {}", id);
            return taskMapper.toDto(taskOptional.get());
        } else {
            LOGGER.warn("No task found by ID: {}", id);
            return null;
        }
    }

    public TaskDTO createTask(@NotNull TaskDTO taskDTO) {
        LOGGER.info("Creating task: {}", taskDTO.getId());
        try {
            Task task = taskRepository.save(taskMapper.toEntity(taskDTO));
            LOGGER.info("Created task: {}", task.getId());
            return taskMapper.toDto(task);
        } catch (Exception e) {
            LOGGER.error("Error creating task", e);
            throw new RuntimeException("Error creating task", e);
        }
    }

    public TaskDTO updateTask(@NotNull TaskDTO taskDTO) {
        LOGGER.info("Updating task with ID: {}", taskDTO.getId());
        Optional<Task> existingTask = taskRepository.findById(taskDTO.getId());
        if (existingTask.isPresent()) {
            Task task = existingTask.get();
            taskMapper.updateEntityFromDto(taskDTO, task);
            Task updatedTask = taskRepository.save(task);
            LOGGER.info("Task updated with ID: {}", updatedTask.getId());
            return taskMapper.toDto(updatedTask);
        } else {
            LOGGER.warn("No task found with ID for update: {}", taskDTO.getId());
            return null;
        }
    }

    public boolean deleteTask(Integer id) {
        LOGGER.info("Deleting task with ID: {}", id);
        try {
            Optional<Task> existingTask = taskRepository.findById(id);
            if (existingTask.isPresent()) {
                taskRepository.deleteById(id);
                LOGGER.info("Deleted task with ID: {}", id);
                return true;
            } else {
                LOGGER.warn("Task with ID: {} not found", id);
                return false;
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting task", e);
            throw new RuntimeException("Error deleting task", e);
        }
    }
}
