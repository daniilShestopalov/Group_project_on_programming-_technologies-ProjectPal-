package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.dto.auth.AuthUserDTO;
import cs.vsu.projectpalback.dto.auth.RegistrationUserDTO;
import cs.vsu.projectpalback.dto.auth.TmpInitialLoginUserDTO;
import cs.vsu.projectpalback.model.User;
import cs.vsu.projectpalback.repository.UserRepository;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;
import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@SpringBootTest
@ActiveProfiles("test")
@Rollback(true)
public class AuthServiceTest {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Before
    public void setUp() {
        userRepository.deleteAll();
    }

    @Test
    public void testAuthenticate_ValidCredentials() {
        String username = "testuser";
        String password = "password";
        User user = new User();
        user.setLogin(username);
        user.setPassword(passwordEncoder.encode(password));
        userRepository.save(user);

        AuthUserDTO authUserDTO = new AuthUserDTO();
        authUserDTO.setLogin(username);
        authUserDTO.setPassword(password);
        UserWithoutPasswordDTO result = authService.authenticate(authUserDTO);

        assertNotNull(result);
        assertEquals(username, result.getLogin());
    }

    @Test
    public void testAuthenticate_InvalidCredentials() {
        String username = "testuser";
        String password = "password";
        User user = new User();
        user.setLogin(username);
        user.setPassword(passwordEncoder.encode(password));
        userRepository.save(user);

        AuthUserDTO authUserDTO = new AuthUserDTO();
        authUserDTO.setLogin(username);
        authUserDTO.setPassword("wrong_password");
        UserWithoutPasswordDTO result = authService.authenticate(authUserDTO);

        assertNull(result);
    }

    @Test
    public void testAuthenticate_UserNotFound() {
        AuthUserDTO authUserDTO = new AuthUserDTO();
        authUserDTO.setLogin("non_existing_user");
        authUserDTO.setPassword("password");
        UserWithoutPasswordDTO result = authService.authenticate(authUserDTO);

        assertNull(result);
    }

    @Test
    public void testVerifyTemporaryUser_ValidCredentials() {
        String tempLogin = "tempuser";
        String tempPassword = "temp_password";
        User user = new User();
        user.setLogin(tempLogin);
        user.setPassword(tempPassword);
        userRepository.save(user);

        TmpInitialLoginUserDTO tmpInitialLoginUserDTO = new TmpInitialLoginUserDTO();
        tmpInitialLoginUserDTO.setTempLogin(tempLogin);
        tmpInitialLoginUserDTO.setTempPassword(tempPassword);
        Integer userId = authService.verifyTemporaryUser(tmpInitialLoginUserDTO);

        assertNotNull(userId);
    }

    @Test
    public void testVerifyTemporaryUser_InvalidCredentials() {
        String tempLogin = "tempuser";
        String tempPassword = "temp_password";
        User user = new User();
        user.setLogin(tempLogin);
        user.setPassword(tempPassword);
        userRepository.save(user);

        TmpInitialLoginUserDTO tmpInitialLoginUserDTO = new TmpInitialLoginUserDTO();
        tmpInitialLoginUserDTO.setTempLogin(tempLogin);
        tmpInitialLoginUserDTO.setTempPassword("wrong_password");
        Integer userId = authService.verifyTemporaryUser(tmpInitialLoginUserDTO);

        assertNull(userId);
    }

    @Test
    public void testVerifyTemporaryUser_UserNotFound() {
        TmpInitialLoginUserDTO tmpInitialLoginUserDTO = new TmpInitialLoginUserDTO();
        tmpInitialLoginUserDTO.setTempLogin("non_existing_user");
        tmpInitialLoginUserDTO.setTempPassword("password");
        Integer userId = authService.verifyTemporaryUser(tmpInitialLoginUserDTO);

        assertNull(userId);
    }

    @Test
    public void testRegisterUser_UserExists() {
        User user = new User();
        user.setId(1);
        userRepository.save(user);

        RegistrationUserDTO registrationUserDTO = new RegistrationUserDTO();
        registrationUserDTO.setId(1);
        registrationUserDTO.setLogin("existing_user");
        registrationUserDTO.setPhoneNumber("1234567890");
        registrationUserDTO.setNewPassword("new_password");

        assertFalse(authService.registerUser(registrationUserDTO));
    }

    @Test
    public void testRegisterUser_UserNotFound() {
        RegistrationUserDTO registrationUserDTO = new RegistrationUserDTO();
        registrationUserDTO.setId(1);
        registrationUserDTO.setLogin("non_existing_user");
        registrationUserDTO.setPhoneNumber("1234567890");
        registrationUserDTO.setNewPassword("new_password");

        assertFalse(authService.registerUser(registrationUserDTO));
    }

    @Test
    public void testCheckEmailExists_EmailExists() {
        User user = new User();
        user.setLogin("existing_email");
        userRepository.save(user);

        assertTrue(authService.checkEmailExists("existing_email"));
    }

    @Test
    public void testCheckEmailExists_EmailNotExists() {
        assertFalse(authService.checkEmailExists("non_existing_email"));
    }

    @Test
    public void testUpdatePasswordById_UserExists() {
        User user = new User();
        user.setId(1);
        userRepository.save(user);

        assertTrue(authService.updatePasswordById(1, "new_password"));
    }

    @Test
    public void testUpdatePasswordById_UserNotFound() {
        assertFalse(authService.updatePasswordById(1, "new_password"));
    }
}
