package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.dto.*;
import cs.vsu.projectpalback.dto.auth.ChangePasswordDTO;
import cs.vsu.projectpalback.model.enumerate.Role;
import cs.vsu.projectpalback.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user")
@Tag(name = "UserController", description = "Authorized users only.")
@AllArgsConstructor
public class UserController {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserController.class);

    private final UserService userService;

    @GetMapping("/all")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Get all users without password (admin, teacher)", description = "Returns a list of all users without their passwords")
    public ResponseEntity<List<UserWithoutPasswordDTO>> getAllUsersWithoutPassword() {
        try {
            LOGGER.info("Fetching all users without password");
            return ResponseEntity.ok(userService.getAllUsersWithoutPassword());
        } catch (Exception e) {
            LOGGER.error("Error fetching all users without password", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/all-with-password")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all users with password (admin)", description = "Returns a list of all users with their passwords")
    public ResponseEntity<List<UserDTO>> getAllUsersWithPassword() {
        try {
            LOGGER.info("Fetching all users with password");
            return ResponseEntity.ok(userService.getAllUsersWithPassword());
        } catch (Exception e) {
            LOGGER.error("Error fetching all users with password", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get user by ID without password", description = "Returns a user by the given ID without their password")
    public ResponseEntity<UserWithoutPasswordDTO> getUserByIdWithoutPassword(@PathVariable int id) {
        try {
            LOGGER.info("Fetching user without password by ID: {}", id);
            return ResponseEntity.ok(userService.getUserByIdWithoutPassword(id));
        } catch (Exception e) {
            LOGGER.error("Error fetching user without password by ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/{id}/with-password")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get user by ID with password (admin)", description = "Returns a user by the given ID with their password")
    public ResponseEntity<UserDTO> getUserByIdWithPassword(@PathVariable int id) {
        try {
            LOGGER.info("Fetching user with password by ID: {}", id);
            return ResponseEntity.ok(userService.getUserByIdWithPassword(id));
        } catch (Exception e) {
            LOGGER.error("Error fetching user with password by ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/role/{role}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get users by role", description = "Returns a list of users by the given role")
    public ResponseEntity<List<UserWithoutPasswordDTO>> getUsersByRole(@PathVariable String role) {
        try {
            Role roleEnum = Role.valueOf(role.toUpperCase());
            LOGGER.info("Fetching users by role: {}", role);
            return ResponseEntity.ok(userService.getUsersByRole(roleEnum));
        } catch (Exception e) {
            LOGGER.error("Error fetching users by role: {}", role, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/group/{groupId}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get users by group", description = "Returns a list of users by the given group ID")
    public ResponseEntity<List<UserWithoutPasswordDTO>> getUsersByGroup(@PathVariable Integer groupId) {
        try {
            LOGGER.info("Fetching users by group ID: {}", groupId);
            return ResponseEntity.ok(userService.getUsersByGroup(groupId));
        } catch (Exception e) {
            LOGGER.error("Error fetching users by group ID: {}", groupId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }


    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Create a new user (admin)", description = "Creates a new user")
    public ResponseEntity<?> createUser(@RequestBody UserDTO userDTO) {
        try {
            LOGGER.info("Creating a new user with login: {}", userDTO.getLogin());
            return ResponseEntity.ok(userService.createUser(userDTO));
        } catch (Exception e) {
            LOGGER.error("Error creating new user with login: {}", userDTO.getLogin(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Delete a user (admin)", description = "Deletes a user by the given ID")
    public ResponseEntity<Void> deleteUser(@PathVariable int id) {
        try {
            LOGGER.info("Deleting user with ID: {}", id);
            boolean isDeleted = userService.deleteUser(id);
            if (isDeleted) {
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting user with ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PutMapping
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Update a user", description = "Updates an existing user")
    public ResponseEntity<UserDTO> updateUser(@RequestBody UserDTO userDTO) {
        try {
            LOGGER.info("Updating user with ID: {}", userDTO.getId());
            UserDTO updatedUser = userService.updateUser(userDTO);
            if (updatedUser != null) {
                return ResponseEntity.ok(updatedUser);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            LOGGER.error("Error updating user with ID: {}", userDTO.getId(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PutMapping("/without-password")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Update a user without password", description = "Updates an existing user without password")
    public ResponseEntity<UserWithoutPasswordDTO> updateUser(@RequestBody UserWithoutPasswordDTO userWithoutPasswordDTO) {
        try {
            LOGGER.info("Updating user without password with ID: {}", userWithoutPasswordDTO.getId());
            UserWithoutPasswordDTO updatedUser = userService.updateUser(userWithoutPasswordDTO);
            if (updatedUser != null) {
                return ResponseEntity.ok(updatedUser);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
        } catch (Exception e) {
            LOGGER.error("Error updating user without password with ID: {}", userWithoutPasswordDTO.getId(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PutMapping("/avatar")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Update user avatar", description = "Updates the avatar of an existing user")
    public ResponseEntity<Void> updateAvatar(@RequestBody ChangeAvatarDTO changeAvatarDTO) {
        try {
            LOGGER.info("Updating avatar for user ID: {}", changeAvatarDTO.getId());
            boolean isUpdated = userService.updateAvatar(changeAvatarDTO);
            if (isUpdated) {
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } catch (Exception e) {
            LOGGER.error("Error updating avatar for user ID: {}", changeAvatarDTO.getId(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PutMapping("/password")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Update user password (admin)", description = "Updates the password of an existing user")
    public ResponseEntity<Void> updatePassword(@RequestBody ChangePasswordDTO changePasswordDTO) {
        int id = changePasswordDTO.getId();
        try {
            String newPassword = changePasswordDTO.getPassword();
            LOGGER.info("Updating password for user ID: {}", id);
            boolean isUpdated = userService.updatePassword(id, newPassword);
            if (isUpdated) {
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } catch (Exception e) {
            LOGGER.error("Error updating password for user ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PutMapping("/group")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Update user group (admin, teacher)", description = "Updates the group of an existing user")
    public ResponseEntity<Void> updateUserGroup(@RequestBody ChangeGroupDTO changeGroupDTO) {
        int id = changeGroupDTO.getId();
        try {
            Integer groupId = changeGroupDTO.getGroupId();
            LOGGER.info("Updating group for user ID: {}", id);
            boolean isUpdated = userService.updateUserGroup(id, groupId);
            if (isUpdated) {
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } catch (Exception e) {
            LOGGER.error("Error updating group for user ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PutMapping("/group/list")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Update users group (admin, teacher)", description = "Updates the group of multiple users")
    public ResponseEntity<Void> updateUsersGroup(@RequestBody ChangeGroupForManyDTO groupForManyDTO) {
        List<Integer> userIds = groupForManyDTO.getUserIds();
        try {
            Integer groupId = groupForManyDTO.getGroupId();
            LOGGER.info("Updating group for user IDs: {}", userIds);
            boolean allUpdated = userService.updateUsersGroup(userIds, groupId);
            if (allUpdated) {
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } catch (Exception e) {
            LOGGER.error("Error updating group for user IDs: {}", userIds, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/group/{groupId}/count")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Count users by group", description = "Returns the number of users in a given group")
    public ResponseEntity<Long> countUsersByGroup(@PathVariable Integer groupId) {
        try {
            LOGGER.info("Counting users by group ID: {}", groupId);
            long count = userService.countUsersByGroup(groupId);
            return ResponseEntity.ok(count);
        } catch (Exception e) {
            LOGGER.error("Error counting users by group ID: {}", groupId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/{id}/role")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "User role by id", description = "Returns the role of user by id")
    public ResponseEntity<?> getRoleById(@PathVariable Integer id) {
        try {
            LOGGER.info("Getting role for user ID: {}", id);
            Role role = userService.getRoleById(id);
            return ResponseEntity.ok(role);
        } catch (Exception e) {
            LOGGER.error("Error getting role by id", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

}
