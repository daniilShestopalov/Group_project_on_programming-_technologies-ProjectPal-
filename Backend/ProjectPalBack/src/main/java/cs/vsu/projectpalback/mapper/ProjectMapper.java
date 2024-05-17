package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.ProjectDTO;
import cs.vsu.projectpalback.model.Project;
import cs.vsu.projectpalback.model.User;
import cs.vsu.projectpalback.repository.UserRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring", uses = UserRepository.class)
public abstract class ProjectMapper {

    @Autowired
    private UserRepository userRepository;

    @Mapping(source = "teacher.id", target = "teacherUserId")
    public abstract ProjectDTO toDto(Project project);

    @Mapping(source = "teacherUserId", target = "teacher", qualifiedByName = "userFromId")
    public abstract Project toEntity(ProjectDTO projectDTO);

    public abstract List<ProjectDTO> toDtoList(List<Project> projects);

    public abstract List<Project> toEntityList(List<ProjectDTO> projectDTOs);

    @Named("userFromId")
    protected User userFromId(int id) {
        return userRepository.findById(id).orElse(null);
    }
}
