package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.UserDTO;
import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.mapper.UserMapper;
import cs.vsu.projectpalback.model.User;
import cs.vsu.projectpalback.model.enumerate.Role;
import cs.vsu.projectpalback.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class UserService {

    private final Logger LOGGER = LoggerFactory.getLogger(UserService.class);

    private final UserRepository userRepository;

    private final UserMapper userMapper;



    public List<UserWithoutPasswordDTO> getAllUsersWithoutPassword() {
        LOGGER.debug("Fetching all users without password");
        return userMapper.toDtoListWithoutPassword(userRepository.findAll());
    }

    public  List<UserDTO> getAllUsersWithPassword() {
        LOGGER.debug("Fetching all users with password");
        return userMapper.toDtoList(userRepository.findAll());
    }

    public UserWithoutPasswordDTO getUserByIdWithoutPassword(int id) {
        LOGGER.debug("Fetching user without password by id: {}", id);
        return userRepository.findById(id)
                .map(userMapper::toDtoWithoutPassword)
                .orElse(null);
    }

    public UserDTO getUserByIdWithPassword(int id) {
        LOGGER.debug("Fetching user with password by id: {}", id);
        return userRepository.findById(id)
                .map(userMapper::toDto)
                .orElse(null);
    }

    public List<UserWithoutPasswordDTO> getUsersByRole(Role role) {
        LOGGER.debug("Fetching users by role: {}", role);
        return userMapper.toDtoListWithoutPassword(userRepository.findByRole(role));
    }

    public List<UserWithoutPasswordDTO> getUsersByGroup(Integer groupId) {
        LOGGER.debug("Fetching users by group: {}", groupId);
        return userMapper.toDtoListWithoutPassword(userRepository.findByGroupId(groupId));
    }

    public UserWithoutPasswordDTO getUserByLoginWithoutPassword(String login) {
        LOGGER.debug("Fetching user without password by login: {}", login);
        return userRepository.findByLogin(login)
                .map(userMapper::toDtoWithoutPassword)
                .orElse(null);
    }

    public UserDTO getUserByLoginWithPassword(String login) {
        LOGGER.debug("Fetching user with password by login: {}", login);
        return userRepository.findByLogin(login)
                .map(userMapper::toDto)
                .orElse(null);
    }

    public void createUser(UserDTO userDTO) {
        try {
            userRepository.save(userMapper.toEntity(userDTO));
            LOGGER.info("User created: {}", userDTO.getLogin());
        } catch (Exception e) {
            LOGGER.error("Error creating user: {}", userDTO.getLogin(), e);
            throw new RuntimeException("Error creating user", e);
        }
    }

    public void deleteUser(int id) {
        try {
            userRepository.deleteById(id);
            LOGGER.info("User deleted with id: {}", id);
        } catch (Exception e) {
            LOGGER.error("Error deleting user with id: {}", id, e);
            throw new RuntimeException("Error deleting user", e);
        }
    }

    public UserWithoutPasswordDTO updateUser(UserDTO userDTO) {
        Optional<User> existingUserOptional = userRepository.findById(userDTO.getId());
        if (existingUserOptional.isPresent()) {
            User existingUser = existingUserOptional.get();
            userMapper.updateEntityFromDto(userDTO, existingUser);
            User updatedUser = userRepository.save(existingUser);
            LOGGER.info("User updated: {}", userDTO.getId());
            return userMapper.toDtoWithoutPassword(updatedUser);
        }
        LOGGER.warn("User with id {} not found for update", userDTO.getId());
        return null;
    }

    public boolean updateAvatar(int userId, String avatarPath) {
        Optional<User> existingUserOptional = userRepository.findById(userId);
        if (existingUserOptional.isPresent()) {
            User existingUser = existingUserOptional.get();
            existingUser.setAvatarLink(avatarPath);
            userRepository.save(existingUser);
            LOGGER.info("User avatar updated for user id: {}", userId);
            return true;
        }
        LOGGER.warn("User with id {} not found for avatar update", userId);
        return false;
    }

    public boolean updatePassword(int userId, String newPassword) {
        Optional<User> existingUserOptional = userRepository.findById(userId);
        if (existingUserOptional.isPresent()) {
            User existingUser = existingUserOptional.get();
            existingUser.setPassword(newPassword);
            userRepository.save(existingUser);
            LOGGER.info("User password updated for user id: {}", userId);
            return true;
        }
        LOGGER.warn("User with id {} not found for password update", userId);
        return false;
    }

    public long countUsersByGroup(Integer groupId) {
        LOGGER.debug("Counting users by group id: {}", groupId);
        return userRepository.countByGroupId(groupId);
    }
}
