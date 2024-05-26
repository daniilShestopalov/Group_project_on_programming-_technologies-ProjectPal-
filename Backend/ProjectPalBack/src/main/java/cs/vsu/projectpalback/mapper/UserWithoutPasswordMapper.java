package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.model.Group;
import cs.vsu.projectpalback.model.User;
import cs.vsu.projectpalback.repository.GroupRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring")
public abstract class UserWithoutPasswordMapper {

    @Autowired
    private GroupRepository groupRepository;

    @Mapping(target = "groupId", source = "group.id")
    public abstract UserWithoutPasswordDTO toDto(User user);

    @Mapping(source = "groupId", target = "group", qualifiedByName = "groupFromId")
    public abstract User toEntity(UserWithoutPasswordDTO userWithoutPasswordDTO);

    public abstract List<UserWithoutPasswordDTO> toDtoList(List<User> userList);

    public abstract List<User> toEntityList(List<UserWithoutPasswordDTO> userWithoutPasswordDTOList);

    @Mapping(source = "groupId", target = "group", qualifiedByName = "groupFromId")
    @Mapping(target = "password", ignore = true)
    public abstract void updateEntityFromDto(UserWithoutPasswordDTO dto, @MappingTarget User entity);

    @Named("groupFromId")
    protected Group groupFromId(Integer id) {
        return id != null ? groupRepository.findById(id).orElse(null) : null;
    }
}
