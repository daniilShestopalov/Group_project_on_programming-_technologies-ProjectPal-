package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UserWithoutPasswordMapper {

    @Mapping(target = "groupId", source = "group.id")
    UserWithoutPasswordDTO toDto(User user);

    List<UserWithoutPasswordDTO> toDtoList(List<User> userList);
}
