package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.UserDTO;
import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.mapper.UserMapper;
import cs.vsu.projectpalback.model.User;
import cs.vsu.projectpalback.model.enumerate.Role;
import cs.vsu.projectpalback.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    private final UserMapper userMapper;

    public List<UserWithoutPasswordDTO> getAllUsersWithoutPassword() {
        return userMapper.toDtoListWithoutPassword(userRepository.findAll());
    }

    public  List<UserDTO> getAllUsersWithPassword() {
        return userMapper.toDtoList(userRepository.findAll());
    }

    public UserWithoutPasswordDTO getUserByIdWithoutPassword(int id) {
        return userRepository.findById(id)
                .map(userMapper::toDtoWithoutPassword)
                .orElse(null);
    }

    public UserDTO getUserByIdWithPassword(int id) {
        return userRepository.findById(id)
                .map(userMapper::toDto)
                .orElse(null);
    }

    public List<UserWithoutPasswordDTO> getUsersByRole(Role role) {
        return userMapper.toDtoListWithoutPassword(userRepository.findByRole(role));
    }

    public List<UserWithoutPasswordDTO> getUsersByGroup(Integer groupId) {
        return userMapper.toDtoListWithoutPassword(userRepository.findByGroupId(groupId));
    }

    public UserWithoutPasswordDTO getUserByLoginWithoutPassword(String login) {
        return userRepository.findByLogin(login)
                .map(userMapper::toDtoWithoutPassword)
                .orElse(null);
    }

    public UserDTO getUserByLoginWithPassword(String login) {
        return userRepository.findByLogin(login)
                .map(userMapper::toDto)
                .orElse(null);
    }

    public void createUser(UserDTO userDTO) {
        userRepository.save(userMapper.toEntity(userDTO));
    }

    public void deleteUser(int id) {
        userRepository.deleteById(id);
    }

    public UserWithoutPasswordDTO updateUser(UserDTO userDTO) {
        Optional<User> existingUserOptional = userRepository.findById(userDTO.getId());
        if (existingUserOptional.isPresent()) {
            User existingUser = existingUserOptional.get();
            userMapper.updateEntityFromDto(userDTO, existingUser);
            User updatedUser = userRepository.save(existingUser);
            return userMapper.toDtoWithoutPassword(updatedUser);
        }
        return null;
    }
}
