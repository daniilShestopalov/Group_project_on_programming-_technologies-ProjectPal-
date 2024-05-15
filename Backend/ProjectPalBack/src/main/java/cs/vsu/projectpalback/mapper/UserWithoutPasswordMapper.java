package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.model.User;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UserWithoutPasswordMapper {

    UserWithoutPasswordDTO toDto(User user);

    List<UserWithoutPasswordDTO> toDtoList(List<User> userList);
}
