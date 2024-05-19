package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.UserDTO;
import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.mapper.UserMapper;
import cs.vsu.projectpalback.mapper.UserWithoutPasswordMapper;
import cs.vsu.projectpalback.model.Group;
import cs.vsu.projectpalback.model.User;
import cs.vsu.projectpalback.model.enumerate.Role;
import cs.vsu.projectpalback.repository.GroupRepository;
import cs.vsu.projectpalback.repository.UserRepository;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class UserService {

    private final Logger LOGGER = LoggerFactory.getLogger(UserService.class);

    private final GroupRepository groupRepository;

    private final UserRepository userRepository;

    private final UserMapper userMapper;

    private final UserWithoutPasswordMapper userWithoutPasswordMapper;

    private final BCryptPasswordEncoder passwordEncoder;

    public List<UserWithoutPasswordDTO> getAllUsersWithoutPassword() {
        LOGGER.debug("Fetching all users without password");
        return userWithoutPasswordMapper.toDtoList(userRepository.findAll());
    }

    public  List<UserDTO> getAllUsersWithPassword() {
        LOGGER.debug("Fetching all users with password");
        return userMapper.toDtoList(userRepository.findAll());
    }

    public UserWithoutPasswordDTO getUserByIdWithoutPassword(int id) {
        LOGGER.debug("Fetching user without password by id: {}", id);
        return userRepository.findById(id)
                .map(userWithoutPasswordMapper::toDto)
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
        return userWithoutPasswordMapper.toDtoList(userRepository.findByRole(role));
    }

   public List<UserWithoutPasswordDTO> getUsersByGroup(Integer groupId) {
        LOGGER.debug("Fetching users by group: {}", groupId);
        return userWithoutPasswordMapper.toDtoList(userRepository.findByGroupId(groupId));
   }

    public UserWithoutPasswordDTO getUserByLoginWithoutPassword(String login) {
        LOGGER.debug("Fetching user without password by login: {}", login);
        return userRepository.findByLogin(login)
                .map(userWithoutPasswordMapper::toDto)
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

    public boolean deleteUser(int id) {
        try {
            Optional<User> user = userRepository.findById(id);
            if (user.isPresent()) {
                userRepository.deleteById(id);
                LOGGER.info("User deleted with id: {}", id);
                return true;
            }
            return false;

        } catch (Exception e) {
            LOGGER.error("Error deleting user with id: {}", id, e);
            throw new RuntimeException("Error deleting user", e);
        }
    }

    public UserDTO updateUser(@NotNull UserDTO userDTO) {
        Optional<User> existingUserOptional = userRepository.findById(userDTO.getId());
        if (existingUserOptional.isPresent()) {
            User existingUser = existingUserOptional.get();
            userMapper.updateEntityFromDto(userDTO, existingUser);
            User updatedUser = userRepository.save(existingUser);
            LOGGER.info("User updated: {}", userDTO.getId());
            return userMapper.toDto(updatedUser);
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
            existingUser.setPassword(passwordEncoder.encode(newPassword));
            userRepository.save(existingUser);
            LOGGER.info("User password updated for user id: {}", userId);
            return true;
        }
        LOGGER.warn("User with id {} not found for password update", userId);
        return false;
    }

    public boolean updateUserGroup(int userId, Integer groupId) {
        Optional<User> existingUserOptional = userRepository.findById(userId);
        Optional<Group> groupOptional = groupRepository.findById(groupId);
        if (existingUserOptional.isPresent() && groupOptional.isPresent()) {
            User existingUser = existingUserOptional.get();
            existingUser.setGroup(groupOptional.get());
            userRepository.save(existingUser);
            LOGGER.info("User group updated for user id: {}", userId);
            return true;
        }
        LOGGER.warn("User with id {} or group with id {} not found for group update", userId, groupId);
        return false;
    }

    public boolean updateUsersGroup(List<Integer> userIds, Integer groupId) {
        Optional<Group> groupOptional = groupRepository.findById(groupId);
        if (groupOptional.isEmpty()) {
            LOGGER.warn("Group with id {} not found for group update", groupId);
            return false;
        }

        Group group = groupOptional.get();
        boolean allUpdated = true;
        for (int userId : userIds) {
            boolean updated = updateUserGroup(userId, group.getId());
            if (!updated) {
                allUpdated = false;
            }
        }
        return allUpdated;
    }

    public long countUsersByGroup(Integer groupId) {
        LOGGER.debug("Counting users by group id: {}", groupId);
        return userRepository.countByGroupId(groupId);
    }

}
