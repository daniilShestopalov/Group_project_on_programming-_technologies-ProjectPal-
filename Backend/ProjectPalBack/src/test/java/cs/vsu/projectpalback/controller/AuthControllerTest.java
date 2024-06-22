package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.dto.auth.*;
import cs.vsu.projectpalback.security.JwtProvider;
import cs.vsu.projectpalback.service.AuthService;
import cs.vsu.projectpalback.service.PasswordResetService;
import cs.vsu.projectpalback.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
public class AuthControllerTest {

    private MockMvc mockMvc;

    @Mock
    private AuthService authService;

    @Mock
    private UserService userService;

    @Mock
    private PasswordResetService passwordResetService;

    @Mock
    private JwtProvider jwtProvider;

    @InjectMocks
    private AuthController authController;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(authController).build();
    }

    @Test
    void verifyTemporaryUser_InvalidData_ReturnsUnauthorized() throws Exception {
        // Mocking the service response for invalid data
        when(authService.verifyTemporaryUser(any(TmpInitialLoginUserDTO.class))).thenReturn(null);

        TmpInitialLoginUserDTO dto = new TmpInitialLoginUserDTO();
        dto.setTempLogin("invaliduser");

        mockMvc.perform(post("/auth/verify-temp-user")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"tempLogin\": \"invaliduser\"}")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void register_ValidData_ReturnsOk() throws Exception {
        // Mocking the service response
        when(authService.registerUser(any(RegistrationUserDTO.class))).thenReturn(true);

        mockMvc.perform(post("/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\": \"testuser\", \"password\": \"testpassword\"}")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    @Test
    void register_InvalidData_ReturnsBadRequest() throws Exception {
        // Mocking the service response for invalid data
        when(authService.registerUser(any(RegistrationUserDTO.class))).thenReturn(false);

        mockMvc.perform(post("/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\": \"invaliduser\", \"password\": \"testpassword\"}")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isBadRequest());
    }

    @Test
    void sendPasswordResetCode_ValidData_ReturnsOk() throws Exception {
        // Mocking the service response
        doNothing().when(passwordResetService).sendPasswordReset(any(String.class));

        mockMvc.perform(post("/auth/send-password-reset-code")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\": \"test@example.com\"}")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    @Test
    void sendPasswordResetCode_InvalidData_ReturnsInternalServerError() throws Exception {
        // Mocking the service response for exception
        doThrow(RuntimeException.class).when(passwordResetService).sendPasswordReset(any(String.class));

        mockMvc.perform(post("/auth/send-password-reset-code")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\": \"invalid-email\"}")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isInternalServerError());
    }
}
