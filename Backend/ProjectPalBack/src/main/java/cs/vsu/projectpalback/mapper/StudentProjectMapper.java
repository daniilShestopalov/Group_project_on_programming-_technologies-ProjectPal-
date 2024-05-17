package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.StudentProjectDTO;
import cs.vsu.projectpalback.model.Project;
import cs.vsu.projectpalback.model.StudentProject;
import cs.vsu.projectpalback.model.User;
import cs.vsu.projectpalback.repository.ProjectRepository;
import cs.vsu.projectpalback.repository.UserRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring", uses = {UserRepository.class, ProjectRepository.class})
public abstract class StudentProjectMapper {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProjectRepository projectRepository;

    @Mapping(source = "student.id", target = "studentUserId")
    @Mapping(source = "project.id", target = "projectId")
    public abstract StudentProjectDTO toDto(StudentProject studentProject);

    @Mapping(source = "studentUserId", target = "student", qualifiedByName = "userFromId")
    @Mapping(source = "projectId", target = "project", qualifiedByName = "projectFromId")
    public abstract StudentProject toEntity(StudentProjectDTO studentProjectDTO);

    public abstract List<StudentProjectDTO> toDtoList(List<StudentProject> studentProjectList);

    public abstract List<StudentProject> toEntityList(List<StudentProjectDTO> studentProjectDTOList);

    @Named("userFromId")
    protected User userFromId(int id) {
        return userRepository.findById(id).orElse(null);
    }

    @Named("projectFromId")
    protected Project projectFromId(int id) {
        return projectRepository.findById(id).orElse(null);
    }
}
