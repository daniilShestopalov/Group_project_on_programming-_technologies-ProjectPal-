package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.TaskDTO;
import cs.vsu.projectpalback.model.Group;
import cs.vsu.projectpalback.model.Task;
import cs.vsu.projectpalback.model.User;
import cs.vsu.projectpalback.repository.GroupRepository;
import cs.vsu.projectpalback.repository.UserRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring", uses = {UserRepository.class, GroupRepository.class})
public abstract class TaskMapper {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private GroupRepository groupRepository;

    @Mapping(source = "teacher.id", target = "teacherUserId")
    @Mapping(source = "group.id", target = "groupId")
    public abstract TaskDTO toDto(Task task);

    @Mapping(source = "teacherUserId", target = "teacher", qualifiedByName = "userFromId")
    @Mapping(source = "groupId", target = "group", qualifiedByName = "groupFromId")
    public abstract Task toEntity(TaskDTO taskDTO);

    public abstract List<TaskDTO> toDtoList(List<Task> tasks);

    public abstract List<Task> toEntityList(List<TaskDTO> taskDTOs);

    @Mapping(source = "teacherUserId", target = "teacher", qualifiedByName = "userFromId")
    @Mapping(source = "groupId", target = "group", qualifiedByName = "groupFromId")
    public abstract void updateEntityFromDto(TaskDTO dto, @MappingTarget Task entity);

    @Named("userFromId")
    protected User userFromId(int id) {
        return userRepository.getReferenceById(id);
    }

    @Named("groupFromId")
    protected Group groupFromId(int id) {
        return groupRepository.findById(id).orElse(null);
    }
}
