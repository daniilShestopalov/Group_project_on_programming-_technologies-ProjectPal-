package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.dto.UserDTO;
import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

public class UserControllerTest {

    @Mock
    private UserService userService;

    @InjectMocks
    private UserController userController;

    @BeforeEach
    public void init() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testGetAllUsersWithoutPassword() {
        UserWithoutPasswordDTO user1 = new UserWithoutPasswordDTO();
        user1.setId(1);
        user1.setLogin("user1");
        user1.setName("John");

        UserWithoutPasswordDTO user2 = new UserWithoutPasswordDTO();
        user2.setId(2);
        user2.setLogin("user2");
        user2.setName("Jane");

        List<UserWithoutPasswordDTO> mockUsers = Arrays.asList(user1, user2);
        when(userService.getAllUsersWithoutPassword()).thenReturn(mockUsers);

        ResponseEntity<List<UserWithoutPasswordDTO>> responseEntity = userController.getAllUsersWithoutPassword();

        assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        assertEquals(2, responseEntity.getBody().size());
        verify(userService, times(1)).getAllUsersWithoutPassword();
    }

    @Test
    public void testGetAllUsersWithPassword() {
        UserDTO user1 = new UserDTO();
        user1.setId(1);
        user1.setLogin("admin");
        user1.setName("Admin");

        UserDTO user2 = new UserDTO();
        user2.setId(2);
        user2.setLogin("teacher");
        user2.setName("Teacher");

        List<UserDTO> mockUsers = Arrays.asList(user1, user2);
        when(userService.getAllUsersWithPassword()).thenReturn(mockUsers);

        ResponseEntity<List<UserDTO>> responseEntity = userController.getAllUsersWithPassword();

        assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        assertEquals(2, responseEntity.getBody().size());
        verify(userService, times(1)).getAllUsersWithPassword();
    }

    // Add more test methods to cover other controller methods as per your application's requirements

}
