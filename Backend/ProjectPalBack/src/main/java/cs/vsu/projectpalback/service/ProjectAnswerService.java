package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.ProjectAnswerDTO;
import cs.vsu.projectpalback.mapper.ProjectAnswerMapper;
import cs.vsu.projectpalback.model.ProjectAnswer;
import cs.vsu.projectpalback.repository.ProjectAnswerRepository;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class ProjectAnswerService {

    private static final Logger LOGGER = LoggerFactory.getLogger(TaskService.class);

    private final ProjectAnswerRepository projectAnswerRepository;

    private final ProjectAnswerMapper projectAnswerMapper;

    public List<ProjectAnswerDTO> getAllProjectAnswers() {
        LOGGER.info("Fetching all project answers");
        List<ProjectAnswer> projectAnswers = projectAnswerRepository.findAll();
        return projectAnswerMapper.toDtoList(projectAnswers);
    }

    public ProjectAnswerDTO getProjectAnswerById(Integer id) {
        LOGGER.info("Fetching project answer by ID: {}", id);
        Optional<ProjectAnswer> projectAnswerOptional = projectAnswerRepository.findById(id);
        if (projectAnswerOptional.isPresent()) {
            LOGGER.info("Project answer found by ID: {}", id);
            return projectAnswerMapper.toDto(projectAnswerOptional.get());
        } else {
            LOGGER.warn("No project answer found by ID: {}", id);
            return null;
        }
    }

    public ProjectAnswerDTO getProjectAnswerByProjectId(Integer projectId) {
        LOGGER.info("Fetching project answer by project ID: {}", projectId);
        Optional<ProjectAnswer> projectAnswerOptional = projectAnswerRepository.findByProjectId(projectId);
        if (projectAnswerOptional.isPresent()) {
            LOGGER.info("Project answer found by project ID: {}", projectId);
            return projectAnswerMapper.toDto(projectAnswerOptional.get());
        } else {
            LOGGER.warn("No project answer found by project ID: {}", projectId);
            return null;
        }
    }

    public ProjectAnswerDTO createProjectAnswer(@NotNull ProjectAnswerDTO projectAnswerDTO) {
        LOGGER.info("Creating project answer: {}", projectAnswerDTO.getId());
        try {
            ProjectAnswer projectAnswer = projectAnswerRepository.save(projectAnswerMapper.toEntity(projectAnswerDTO));
            LOGGER.info("Created project answer: {}", projectAnswer.getId());
            return projectAnswerMapper.toDto(projectAnswer);
        } catch (Exception e) {
            LOGGER.error("Error creating project answer", e);
            throw new RuntimeException("Error creating project answer", e);
        }
    }

    public ProjectAnswerDTO updateProjectAnswer(@NotNull ProjectAnswerDTO projectAnswerDTO) {
        LOGGER.info("Updating project answer with ID: {}", projectAnswerDTO.getId());
        Optional<ProjectAnswer> existingProjectAnswer = projectAnswerRepository.findById(projectAnswerDTO.getId());
        if (existingProjectAnswer.isPresent()) {
            ProjectAnswer projectAnswer = existingProjectAnswer.get();
            projectAnswerMapper.updateEntityFromDto(projectAnswerDTO, projectAnswer);
            ProjectAnswer updatedProjectAnswer = projectAnswerRepository.save(projectAnswer);
            LOGGER.info("Project answer updated with ID: {}", updatedProjectAnswer.getId());
            return projectAnswerMapper.toDto(updatedProjectAnswer);
        } else {
            LOGGER.warn("No project answer found with ID for update: {}", projectAnswerDTO.getId());
            return null;
        }
    }

    public boolean deleteProjectAnswer(Integer id) {
        LOGGER.info("Deleting project answer with ID: {}", id);
        try {
            Optional<ProjectAnswer> existingProjectAnswer = projectAnswerRepository.findById(id);
            if (existingProjectAnswer.isPresent()) {
                projectAnswerRepository.deleteById(id);
                LOGGER.info("Deleted project answer with ID: {}", id);
                return true;
            } else {
                LOGGER.warn("Project answer with ID: {} not found", id);
                return false;
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting project answer", e);
            throw new RuntimeException("Error deleting project answer", e);
        }
    }
}
