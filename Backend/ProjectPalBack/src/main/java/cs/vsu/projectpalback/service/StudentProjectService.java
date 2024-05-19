package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.ProjectDTO;
import cs.vsu.projectpalback.dto.StudentProjectDTO;
import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.mapper.ProjectMapper;
import cs.vsu.projectpalback.mapper.StudentProjectMapper;
import cs.vsu.projectpalback.mapper.UserWithoutPasswordMapper;
import cs.vsu.projectpalback.model.StudentProject;
import cs.vsu.projectpalback.repository.StudentProjectRepository;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class StudentProjectService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ProjectService.class);

    private final StudentProjectRepository studentProjectRepository;

    private final StudentProjectMapper studentProjectMapper;

    private final ProjectMapper projectMapper;

    private final UserWithoutPasswordMapper userWithoutPasswordMapper;

    @Transactional(readOnly = true)
    public List<StudentProjectDTO> getAllStudentProjects() {
        LOGGER.info("Fetching all student projects");
        List<StudentProject> studentProjects = studentProjectRepository.findAll();
        return studentProjectMapper.toDtoList(studentProjects);
    }

    @Transactional(readOnly = true)
    public List<StudentProjectDTO> getAllStudentProjectsByStudentId(Integer studentId) {
        LOGGER.info("Fetching student projects by student ID: {}", studentId);
        List<StudentProject> studentProjects = studentProjectRepository.findByStudentId(studentId);
        return studentProjectMapper.toDtoList(studentProjects);
    }

    @Transactional(readOnly = true)
    public List<StudentProjectDTO> getAllStudentProjectsByProjectId(Integer projectId) {
        LOGGER.info("Fetching student projects by project ID: {}", projectId);
        List<StudentProject> studentProjects = studentProjectRepository.findByProjectId(projectId);
        return studentProjectMapper.toDtoList(studentProjects);
    }

    @Transactional(readOnly = true)
    public List<UserWithoutPasswordDTO> getStudentsByProjectId(Integer projectId) {
        LOGGER.info("Fetching students by project ID: {}", projectId);
        List<StudentProject> studentProjects = studentProjectRepository.findByProjectId(projectId);
        return studentProjects.stream()
                .map(StudentProject::getStudent)
                .map(userWithoutPasswordMapper::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ProjectDTO> getProjectsByStudentId(Integer studentId) {
        LOGGER.info("Fetching projects by student ID: {}", studentId);
        List<StudentProject> studentProjects = studentProjectRepository.findByStudentId(studentId);
        return studentProjects.stream()
                .map(StudentProject::getProject)
                .map(projectMapper::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public StudentProjectDTO getStudentProjectById(Integer id) {
        LOGGER.info("Fetching studentProject with ID: {}", id);
        Optional<StudentProject> studentProjectOptional = studentProjectRepository.findById(id);
        if (studentProjectOptional.isPresent()) {
            LOGGER.info("StudentProject found with ID: {}", id);
            return studentProjectMapper.toDto(studentProjectOptional.get());
        } else {
            LOGGER.warn("No studentProject found with ID: {}", id);
            return null;
        }
    }
    @Transactional()
    public StudentProjectDTO createStudentProject(StudentProjectDTO studentProjectDTO) {
        try {
            LOGGER.info("Creating student project: {}", studentProjectDTO);
            StudentProject studentProject = studentProjectRepository.save(studentProjectMapper.toEntity(studentProjectDTO));
            LOGGER.info("Student project created with ID: {}", studentProject.getId());
            return studentProjectMapper.toDto(studentProject);
        } catch (Exception e) {
            LOGGER.error("Error creating student project: {}", e.getMessage(), e);
            throw new RuntimeException("Error creating student project", e);
        }
    }

    @Transactional()
    public boolean deleteStudentProjectById(Integer id) {
        try {
            LOGGER.info("Deleting studentProject with ID: {}", id);
            Optional<StudentProject> existingStudentProject = studentProjectRepository.findById(id);
            if (existingStudentProject.isPresent()) {
                studentProjectRepository.deleteById(id);
                LOGGER.info("StudentProject deleted with ID: {}", id);
                return true;
            } else {
                LOGGER.warn("No studentProject found with ID for delete: {}", id);
                return false;
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting studentProject with ID: {}", id, e);
            throw new RuntimeException("Error deleting group", e);
        }
    }

}
