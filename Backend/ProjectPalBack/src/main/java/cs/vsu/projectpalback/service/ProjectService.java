package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.ProjectDTO;
import cs.vsu.projectpalback.mapper.ProjectMapper;
import cs.vsu.projectpalback.model.Project;
import cs.vsu.projectpalback.repository.ProjectRepository;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class ProjectService {

    private static final Logger logger = LoggerFactory.getLogger(ProjectService.class);

    private final ProjectRepository projectRepository;

    private final ProjectMapper projectMapper;

    public List<ProjectDTO> getAllProjects() {
        logger.info("Fetching all projects");
        List<Project> projects = projectRepository.findAll();
        return projectMapper.toDtoList(projects);
    }

    public List<ProjectDTO> getAllProjectsByProjectId(List<Integer> ids) {
        logger.info("Fetching projects by IDs: {}", ids);
        List<Project> projects = projectRepository.findAllById(ids);
        return projectMapper.toDtoList(projects);
    }

    public List<ProjectDTO> getAllProjectsByTeacherId(Integer teacherId) {
        logger.info("Fetching projects by teacher ID: {}", teacherId);
        List<Project> projects = projectRepository.findAllByTeacherId(teacherId);
        return projectMapper.toDtoList(projects);
    }

    public ProjectDTO getProjectById(Integer id) {
        logger.info("Fetching project by ID: {}", id);
        Optional<Project> project = projectRepository.findById(id);
        if (project.isPresent()) {
            logger.info("Project found by ID: {}", id);
            return projectMapper.toDto(project.get());
        } else {
            logger.warn("No project found by ID: {}", id);
            return null;
        }
    }

    public ProjectDTO createProject(@NotNull ProjectDTO projectDTO) {
        logger.info("Creating project: {}", projectDTO.getId());
        try {
            Project project = projectRepository.save(projectMapper.toEntity(projectDTO));
            logger.info("Created project: {}", project.getId());
            return projectMapper.toDto(project);
        } catch (Exception e) {
            logger.error("Error creating project", e);
            throw new RuntimeException("Error creating project", e);
        }
    }

    public ProjectDTO updateProject(@NotNull ProjectDTO projectDTO) {
        logger.info("Updating project with ID: {}", projectDTO.getId());
        Optional<Project> existingProject = projectRepository.findById(projectDTO.getId());
        if (existingProject.isPresent()) {
            Project project = existingProject.get();
            projectMapper.updateEntityFromDto(projectDTO, project);
            Project updatedProject = projectRepository.save(project);
            logger.info("Project updated with ID: {}", updatedProject.getId());
            return projectMapper.toDto(updatedProject);
        } else {
            logger.warn("No project found with ID for update: {}", projectDTO.getId());
            return null;
        }
    }

    public boolean deleteProject(Integer id) {
        logger.info("Deleting project with ID: {}", id);
        try {
            Optional<Project> existingProject = projectRepository.findById(id);
            if (existingProject.isPresent()) {
                projectRepository.deleteById(id);
                logger.info("Deleted project with ID: {}", id);
                return true;
            } else {
                logger.warn("Project with ID: {} not found", id);
                return false;
            }
        } catch (Exception e) {
            logger.error("Error deleting project", e);
            throw new RuntimeException("Error deleting project", e);
        }
    }
}
