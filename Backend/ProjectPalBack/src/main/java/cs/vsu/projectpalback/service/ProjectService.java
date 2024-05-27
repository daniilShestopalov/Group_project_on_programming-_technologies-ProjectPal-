package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.ProjectDTO;
import cs.vsu.projectpalback.mapper.ProjectMapper;
import cs.vsu.projectpalback.model.Project;
import cs.vsu.projectpalback.model.StudentProject;
import cs.vsu.projectpalback.repository.ProjectRepository;
import cs.vsu.projectpalback.repository.StudentProjectRepository;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class ProjectService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ProjectService.class);

    private final ProjectRepository projectRepository;

    private final ProjectMapper projectMapper;

    private final StudentProjectRepository studentProjectRepository;

    public List<ProjectDTO> getAllProjects() {
        LOGGER.info("Fetching all projects");
        List<Project> projects = projectRepository.findAll();
        return projectMapper.toDtoList(projects);
    }

    public List<ProjectDTO> getAllProjectsByProjectId(List<Integer> ids) {
        LOGGER.info("Fetching projects by IDs: {}", ids);
        List<Project> projects = projectRepository.findAllById(ids);
        return projectMapper.toDtoList(projects);
    }

    public List<ProjectDTO> getProjectsByDateAndTeacherId(Integer teacherId, LocalDateTime date) {
        LOGGER.info("Fetching projects by date: {} and teacher ID: {}", date, teacherId);
        List<Project> projects = projectRepository.findByTeacherIdAndStartDate(teacherId, date);
        return projectMapper.toDtoList(projects);
    }

    public List<ProjectDTO> getProjectsByMonthAndTeacherId(Integer teacherId, YearMonth month) {
        LOGGER.info("Fetching projects by month: {} and teacher ID: {}", month, teacherId);
        LocalDateTime startDate = month.atDay(1).atStartOfDay();
        LocalDateTime endDate = month.atEndOfMonth().atTime(23, 59, 59);
        List<Project> projects = projectRepository.findByTeacherIdAndEndDateBetween(teacherId, startDate, endDate);
        return projectMapper.toDtoList(projects);
    }

    public List<ProjectDTO> getAllProjectsByTeacherId(Integer teacherId) {
        LOGGER.info("Fetching projects by teacher ID: {}", teacherId);
        List<Project> projects = projectRepository.findAllByTeacherId(teacherId);
        return projectMapper.toDtoList(projects);
    }

    @Transactional
    public List<ProjectDTO> getProjectsByStudentIdAndDate(Integer studentId, LocalDateTime date) {
        LOGGER.info("Fetching projects by student ID: {} and date: {}", studentId, date);
        List<StudentProject> studentProjects = studentProjectRepository.findByStudentId(studentId);
        List<Project> projects = studentProjects.stream()
                .map(StudentProject::getProject)
                .filter(project -> project.getStartDate().toLocalDate().isEqual(date.toLocalDate()))
                .collect(Collectors.toList());
        return projectMapper.toDtoList(projects);
    }

    @Transactional
    public List<ProjectDTO> getProjectsByStudentIdAndMonth(Integer studentId, YearMonth month) {
        LOGGER.info("Fetching projects by student ID: {} and month: {}", studentId, month);
        LocalDateTime startDate = month.atDay(1).atStartOfDay();
        LocalDateTime endDate = month.atEndOfMonth().atTime(23, 59, 59);
        List<StudentProject> studentProjects = studentProjectRepository.findByStudentId(studentId);
        List<Project> projects = studentProjects.stream()
                .map(StudentProject::getProject)
                .filter(project -> !project.getStartDate().isAfter(endDate) && !project.getEndDate().isBefore(startDate))
                .collect(Collectors.toList());
        return projectMapper.toDtoList(projects);
    }



    public ProjectDTO getProjectById(Integer id) {
        LOGGER.info("Fetching project by ID: {}", id);
        Optional<Project> project = projectRepository.findById(id);
        if (project.isPresent()) {
            LOGGER.info("Project found by ID: {}", id);
            return projectMapper.toDto(project.get());
        } else {
            LOGGER.warn("No project found by ID: {}", id);
            return null;
        }
    }

    public ProjectDTO createProject(@NotNull ProjectDTO projectDTO) {
        LOGGER.info("Creating project: {}", projectDTO.getId());
        try {
            Project project = projectRepository.save(projectMapper.toEntity(projectDTO));
            LOGGER.info("Created project: {}", project.getId());
            return projectMapper.toDto(project);
        } catch (Exception e) {
            LOGGER.error("Error creating project", e);
            throw new RuntimeException("Error creating project", e);
        }
    }

    public ProjectDTO updateProject(@NotNull ProjectDTO projectDTO) {
        LOGGER.info("Updating project with ID: {}", projectDTO.getId());
        Optional<Project> existingProject = projectRepository.findById(projectDTO.getId());
        if (existingProject.isPresent()) {
            Project project = existingProject.get();
            projectMapper.updateEntityFromDto(projectDTO, project);
            Project updatedProject = projectRepository.save(project);
            LOGGER.info("Project updated with ID: {}", updatedProject.getId());
            return projectMapper.toDto(updatedProject);
        } else {
            LOGGER.warn("No project found with ID for update: {}", projectDTO.getId());
            return null;
        }
    }

    public boolean deleteProject(Integer id) {
        LOGGER.info("Deleting project with ID: {}", id);
        try {
            Optional<Project> existingProject = projectRepository.findById(id);
            if (existingProject.isPresent()) {
                projectRepository.deleteById(id);
                LOGGER.info("Deleted project with ID: {}", id);
                return true;
            } else {
                LOGGER.warn("Project with ID: {} not found", id);
                return false;
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting project", e);
            throw new RuntimeException("Error deleting project", e);
        }
    }

    public long countProjectsByTeacherId(Integer teacherId) {
        LOGGER.info("Counting projects by teacher ID: {}", teacherId);
        return projectRepository.countByTeacherId(teacherId);
    }

    @Transactional
    public long countProjectsByStudentId(Integer studentId) {
        LOGGER.info("Counting projects by student ID: {}", studentId);
        return studentProjectRepository.countByStudentId(studentId);
    }

}
