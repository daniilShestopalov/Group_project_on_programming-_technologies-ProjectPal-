package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.dto.auth.*;
import cs.vsu.projectpalback.security.JwtProvider;
import cs.vsu.projectpalback.service.AuthService;
import cs.vsu.projectpalback.service.PasswordResetService;
import cs.vsu.projectpalback.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
@AllArgsConstructor
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    private final AuthService authService;

    private final UserService userService;

    private final PasswordResetService passwordResetService;

    private final JwtProvider jwtProvider;

    @Operation(summary = "Verify temporary user", description = "Verifies a temporary user with login and temporary password")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Temporary user verified successfully"),
            @ApiResponse(responseCode = "401", description = "Verification failed for temporary user")
    })
    @PostMapping("/verify-temp-user")
    public ResponseEntity<?> verifyTemporaryUser(@RequestBody @Valid TmpInitialLoginUserDTO tmpInitialLoginUserDTO) {
        logger.info("Verifying temporary user with login: {}", tmpInitialLoginUserDTO.getTempLogin());
        Integer userId = authService.verifyTemporaryUser(tmpInitialLoginUserDTO);
        if (userId != null) {
            logger.info("Temporary user verified with login: {}", tmpInitialLoginUserDTO.getTempLogin());
            UserWithoutPasswordDTO user = userService.getUserByIdWithoutPassword(userId);
            return ResponseEntity.ok(user);
        } else {
            logger.warn("Verification failed for temporary user with login: {}", tmpInitialLoginUserDTO.getTempLogin());
            return ResponseEntity.status(401).build();
        }
    }

    @Operation(summary = "Register a new user", description = "Registers a new user with the provided details")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "User registered successfully"),
            @ApiResponse(responseCode = "400", description = "User registration failed")
    })
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody @Valid RegistrationUserDTO registrationUserDTO) {
        if (authService.registerUser(registrationUserDTO)) {
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("User registration failed. Possible reasons: user not found or invalid data.");
        }
    }

    @Operation(summary = "Send password reset code", description = "Sends a password reset code to the provided email address")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Password reset code sent successfully"),
            @ApiResponse(responseCode = "500", description = "Failed to send password reset code")
    })
    @PostMapping("/send-password-reset-code")
    public ResponseEntity<?> sendPasswordResetCode(@RequestBody @Valid PasswordResetRequestDTO passwordResetRequestDTO) {
        try {
            passwordResetService.sendPasswordReset(passwordResetRequestDTO.getEmail());
            return ResponseEntity.ok("Password reset code sent successfully.");
        } catch (RuntimeException e) {
            logger.error("Error sending password reset code to email: {}", passwordResetRequestDTO.getEmail(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to send password reset code.");
        }
    }

    @Operation(summary = "Reset password", description = "Resets the password using the provided verification code and new password")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Password reset successfully"),
            @ApiResponse(responseCode = "500", description = "Failed to reset password")
    })
    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody @Valid PasswordChangeDTO passwordChangeDTO) {
        String token = passwordChangeDTO.getVerificationCode();
        logger.info("Received password reset request with token: {}", token);

        try {
            Integer userId = jwtProvider.getUserIdFromToken(token);
            logger.info("Extracted user ID: {} from token", userId);

            boolean isUpdated = authService.updatePasswordById(userId, passwordChangeDTO.getNewPassword());
            if (isUpdated) {
                logger.info("Password successfully reset for user ID: {}", userId);
                return ResponseEntity.ok().build();
            } else {
                logger.error("Failed to reset password for user ID: {}", userId);
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to reset password.");
            }
        } catch (Exception e) {
            logger.error("Exception occurred while resetting password", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to reset password.");
        }
    }

    @Operation(summary = "User login", description = "Authenticates a user and returns a JWT token")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "User authenticated successfully"),
            @ApiResponse(responseCode = "401", description = "Invalid login or password"),
            @ApiResponse(responseCode = "500", description = "An error occurred during authentication")
    })
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody @Valid AuthUserDTO authUserDTO) {
        try {
            UserWithoutPasswordDTO user = authService.authenticate(authUserDTO);
            if (user != null) {
                String token = jwtProvider.generateToken(user);

                HttpHeaders headers = new HttpHeaders();
                headers.add("Authorization", "Bearer " + token);

                return ResponseEntity.ok().headers(headers).body(user);

            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body("Invalid login or password");
            }
        } catch (Exception e) {
            logger.error("Error during authentication", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("An error occurred during authentication");
        }
    }

}
