package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.UserDTO;
import cs.vsu.projectpalback.model.Group;
import cs.vsu.projectpalback.model.User;
import cs.vsu.projectpalback.repository.GroupRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring", uses = GroupRepository.class)
public abstract class UserMapper {

    @Autowired
    private GroupRepository groupRepository;

    @Mapping(source = "group.id", target = "groupId")
    public abstract UserDTO toDto(User user);

    @Mapping(source = "groupId", target = "group", qualifiedByName = "groupFromId")
    public abstract User toEntity(UserDTO userDTO);

    public abstract List<UserDTO> toDtoList(List<User> userList);

    public abstract List<User> toEntityList(List<UserDTO> userDTOList);

    @Mapping(source = "groupId", target = "group", qualifiedByName = "groupFromId")
    public abstract void updateEntityFromDto(UserDTO dto, @MappingTarget User entity);

    @Named("groupFromId")
    protected Group groupFromId(Integer id) {
        return id != null ? groupRepository.findById(id).orElse(null) : null;
    }
}
