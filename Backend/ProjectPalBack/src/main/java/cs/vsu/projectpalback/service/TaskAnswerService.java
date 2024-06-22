package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.TaskAnswerDTO;
import cs.vsu.projectpalback.mapper.TaskAnswerMapper;
import cs.vsu.projectpalback.model.TaskAnswer;
import cs.vsu.projectpalback.repository.TaskAnswerRepository;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class TaskAnswerService {

    private static final Logger LOGGER = LoggerFactory.getLogger(TaskAnswerService.class);

    private final TaskAnswerRepository taskAnswerRepository;

    private final TaskAnswerMapper taskAnswerMapper;

    public List<TaskAnswerDTO> getAllTaskAnswers() {
        LOGGER.info("Fetching all task answers");
        List<TaskAnswer> taskAnswers = taskAnswerRepository.findAll();
        return taskAnswerMapper.toDtoList(taskAnswers);
    }

    public TaskAnswerDTO getTaskAnswerById(Integer id) {
        LOGGER.info("Fetching task answer by ID: {}", id);
        Optional<TaskAnswer> taskAnswerOptional = taskAnswerRepository.findById(id);
        if (taskAnswerOptional.isPresent()) {
            LOGGER.info("Task answer found by ID: {}", id);
            return taskAnswerMapper.toDto(taskAnswerOptional.get());
        } else {
            LOGGER.warn("No task answer found by ID: {}", id);
            return null;
        }
    }

    public List<TaskAnswerDTO> getTaskAnswersByTaskId(Integer taskId) {
        LOGGER.info("Fetching task answers by task ID: {}", taskId);
        List<TaskAnswer> taskAnswers = taskAnswerRepository.findByTaskId(taskId);
        return taskAnswerMapper.toDtoList(taskAnswers);
    }

    public TaskAnswerDTO getTaskAnswerByTaskIdAndStudentId(Integer taskId, Integer studentId) {
        LOGGER.info("Fetching task answer by task ID: {} and student ID: {}", taskId, studentId);
        TaskAnswer taskAnswer = taskAnswerRepository.findByTaskIdAndStudentId(taskId, studentId);
        return taskAnswer != null ? taskAnswerMapper.toDto(taskAnswer) : null;
    }

    public TaskAnswerDTO createTaskAnswer(@NotNull TaskAnswerDTO taskAnswerDTO) {
        LOGGER.info("Creating task answer: {}", taskAnswerDTO.getId());
        try {
            TaskAnswer taskAnswer = taskAnswerRepository.save(taskAnswerMapper.toEntity(taskAnswerDTO));
            LOGGER.info("Created task answer: {}", taskAnswer.getId());
            return taskAnswerMapper.toDto(taskAnswer);
        } catch (Exception e) {
            LOGGER.error("Error creating task answer", e);
            throw new RuntimeException("Error creating task answer", e);
        }
    }

    public TaskAnswerDTO updateTaskAnswer(@NotNull TaskAnswerDTO taskAnswerDTO) {
        LOGGER.info("Updating task answer with ID: {}", taskAnswerDTO.getId());
        Optional<TaskAnswer> existingTaskAnswer = taskAnswerRepository.findById(taskAnswerDTO.getId());
        if (existingTaskAnswer.isPresent()) {
            TaskAnswer taskAnswer = existingTaskAnswer.get();
            taskAnswerMapper.updateEntityFromDto(taskAnswerDTO, taskAnswer);
            TaskAnswer updatedTaskAnswer = taskAnswerRepository.save(taskAnswer);
            LOGGER.info("Task answer updated with ID: {}", updatedTaskAnswer.getId());
            return taskAnswerMapper.toDto(updatedTaskAnswer);
        } else {
            LOGGER.warn("No task answer found with ID for update: {}", taskAnswerDTO.getId());
            return null;
        }
    }

    public boolean deleteTaskAnswer(Integer id) {
        LOGGER.info("Deleting task answer with ID: {}", id);
        try {
            Optional<TaskAnswer> existingTaskAnswer = taskAnswerRepository.findById(id);
            if (existingTaskAnswer.isPresent()) {
                taskAnswerRepository.deleteById(id);
                LOGGER.info("Deleted task answer with ID: {}", id);
                return true;
            } else {
                LOGGER.warn("Task answer with ID: {} not found", id);
                return false;
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting task answer", e);
            throw new RuntimeException("Error deleting task answer", e);
        }
    }
}
