package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.GroupDTO;
import cs.vsu.projectpalback.dto.UserDTO;
import cs.vsu.projectpalback.model.enumerate.Role;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class UserServiceTest {

    @Autowired
    private UserService userService;

    @Autowired
    private GroupService groupService;

    @BeforeEach
    public void setup() {
        GroupDTO group = new GroupDTO();
        group.setGroupNumber(101);
        group.setCourseNumber(1);
        group = groupService.createGroup(group);


        UserDTO userDTO = new UserDTO();
        userDTO.setId(1);
        userDTO.setName("Test User");
        userDTO.setLogin("test");
        userDTO.setPassword("password");
        userDTO.setSurname("Test User");
        userDTO.setPatronymic("Test User");
        userDTO.setRole(Role.ADMIN);
        userDTO.setGroupId(group.getId());

        userService.createUser(userDTO);
    }

    @Test
    public void testGetAllUsersWithoutPassword() {
        assertNotNull(userService.getAllUsersWithoutPassword());
    }

    @Test
    public void testGetAllUsersWithPassword() {
        assertNotNull(userService.getAllUsersWithPassword());
    }

    @Test
    public void testGetUserByIdWithoutPassword() {
        assertNotNull(userService.getUserByIdWithoutPassword(1));
    }

    @Test
    public void testGetUserByIdWithPassword() {
        assertNotNull(userService.getUserByIdWithPassword(1));
    }

    @Test
    public void testGetUsersByRole() {
        assertNotNull(userService.getUsersByRole(Role.ADMIN));
    }

    @Test
    public void testGetUsersByGroup() {
        GroupDTO group = new GroupDTO();
        group.setGroupNumber(101);
        group.setCourseNumber(1);
        group = groupService.createGroup(group);

        UserDTO userDTO = new UserDTO();
        userDTO.setId(1);
        userDTO.setName("Test User");
        userDTO.setLogin("test");
        userDTO.setPassword("password");
        userDTO.setSurname("Test User");
        userDTO.setPatronymic("Test User");
        userDTO.setRole(Role.TEACHER);
        userDTO.setGroupId(group.getId());

        userService.createUser(userDTO);
        assertSame("Test User", userService.getUsersByGroup(group.getId()).get(0).getName());
    }

    @Test
    public void testGetUserByLoginWithoutPassword() {
        assertNotNull(userService.getUserByLoginWithoutPassword("test"));
    }

    @Test
    public void testGetUserByLoginWithPassword() {
        assertNotNull(userService.getUserByLoginWithPassword("test"));
    }

    @Test
    public void testCreateUser() {
        UserDTO userDTO = new UserDTO();
        userDTO.setId(1);
        userDTO.setName("Test User");
        userDTO.setLogin("test");
        userDTO.setPassword("password");
        userDTO.setSurname("Test User");
        userDTO.setPatronymic("Test User");
        userDTO.setRole(Role.ADMIN);
        userDTO.setGroupId(3);
        assertNotNull(userService.createUser(userDTO));
    }

    @Test
    public void testDeleteUser() {
        assertTrue(userService.deleteUser(1));
    }

    @Test
    public void testUpdateUser() {
        UserDTO userDTO = new UserDTO();
        userDTO.setId(1);
        userDTO.setName("Test User 2");
        userDTO.setSurname("Test User 2");
        userDTO.setPatronymic("Test User 2");
        userDTO.setRole(Role.ADMIN);
        userDTO.setLogin("test");
        userDTO.setPassword("password");
        userDTO.setGroupId(2);


        userDTO = userService.updateUser(userDTO);
        assertSame(userDTO.getName(), userService.getUserByLoginWithoutPassword("test").getName());
    }

    @Test
    public void testUpdatePassword() {
        assertTrue(userService.updatePassword(1, "newPassword"));
    }

    @Test
    public void testUpdateUserGroup() {
        GroupDTO group = new GroupDTO();
        group.setGroupNumber(101);
        group.setCourseNumber(1);
        group = groupService.createGroup(group);
        assertTrue(userService.updateUserGroup(1, group.getId()));
    }

    @Test
    public void testUpdateUsersGroup() {
        GroupDTO group = new GroupDTO();
        group.setGroupNumber(101);
        group.setCourseNumber(1);
        group = groupService.createGroup(group);
        assertTrue(userService.updateUsersGroup(Arrays.asList(1, 2), group.getId()));
    }

    @Test
    public void testCountUsersByGroup() {
        GroupDTO group = new GroupDTO();
        group.setGroupNumber(101);
        group.setCourseNumber(1);
        group = groupService.createGroup(group);

        UserDTO userDTO = new UserDTO();
        userDTO.setId(1);
        userDTO.setName("Test User");
        userDTO.setLogin("test");
        userDTO.setPassword("password");
        userDTO.setSurname("Test User");
        userDTO.setPatronymic("Test User");
        userDTO.setRole(Role.ADMIN);
        userDTO.setGroupId(group.getId());

        userService.createUser(userDTO);

        assertEquals(1, userService.countUsersByGroup(group.getId()));
    }
}
