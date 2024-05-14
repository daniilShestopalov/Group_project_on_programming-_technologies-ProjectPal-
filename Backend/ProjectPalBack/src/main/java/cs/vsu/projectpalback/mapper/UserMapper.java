package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.UserDTO;
import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UserMapper {

    UserDTO toDto(User user);

    User toEntity(UserDTO userDTO);

    List<UserDTO> toDtoList(List<User> userList);

    List<User> toEntityList(List<UserDTO> userDTOList);

    default UserWithoutPasswordDTO toDtoWithoutPassword(User user) {
        UserDTO userDTO = toDto(user);
        return new UserWithoutPasswordDTO(userDTO);
    }

    List<UserWithoutPasswordDTO> toDtoListWithoutPassword(List<User> userList);

    void updateEntityFromDto(UserDTO dto, @MappingTarget User entity);
}
