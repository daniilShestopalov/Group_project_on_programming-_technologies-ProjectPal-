package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.dto.auth.AuthUserDTO;
import cs.vsu.projectpalback.dto.auth.RegistrationUserDTO;
import cs.vsu.projectpalback.dto.auth.TmpInitialLoginUserDTO;
import cs.vsu.projectpalback.mapper.UserWithoutPasswordMapper;
import cs.vsu.projectpalback.model.User;
import cs.vsu.projectpalback.repository.UserRepository;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@AllArgsConstructor
public class AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);

    private final UserService userService;

    private final BCryptPasswordEncoder passwordEncoder;

    private final UserWithoutPasswordMapper userWithoutPasswordMapper;

    private final UserRepository userRepository;

    public UserWithoutPasswordDTO authenticate(@NotNull AuthUserDTO authUserDTO) {
        logger.info("Authenticating user with login: {}", authUserDTO.getLogin());
        Optional<User> userOptional = userRepository.findByLogin(authUserDTO.getLogin());
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            if (passwordEncoder.matches(authUserDTO.getPassword(), user.getPassword())) {
                logger.info("Authentication successful for user: {}", user.getLogin());
                return userWithoutPasswordMapper.toDto(user);
            } else {
                logger.warn("Authentication failed for user: {}", authUserDTO.getLogin());
            }
        } else {
            logger.warn("User not found with login: {}", authUserDTO.getLogin());
        }
        return null;
    }

    public Integer verifyTemporaryUser(@NotNull TmpInitialLoginUserDTO tmpInitialLoginUserDTO) {
        logger.info("Verifying temporary user with login: {}", tmpInitialLoginUserDTO.getTempLogin());
        Optional<User> userOptional = userRepository.findByLogin(tmpInitialLoginUserDTO.getTempLogin());
        return userOptional.filter(user -> tmpInitialLoginUserDTO.getTempPassword().equals(user.getPassword()))
                .map(User::getId)
                .orElse(null);
    }

    public boolean registerUser(@NotNull RegistrationUserDTO registrationUserDTO) {
        logger.info("Registering user with ID: {}", registrationUserDTO.getId());
        Optional<User> userOptional = userRepository.findById(registrationUserDTO.getId());
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.setLogin(registrationUserDTO.getLogin());
            user.setPhoneNumber(registrationUserDTO.getPhoneNumber());
            userRepository.save(user);
            userService.updatePassword(user.getId(), registrationUserDTO.getNewPassword());
            logger.info("User registered successfully with ID: {}", registrationUserDTO.getId());
            return true;
        }
        logger.warn("User not found with ID: {}", registrationUserDTO.getId());
        return false;
    }

    public boolean checkEmailExists(@NotNull String email) {
        logger.info("Checking if email exists: {}", email);
        Optional<User> userOptional = userRepository.findByLogin(email);
        boolean exists = userOptional.isPresent();
        if (exists) {
            logger.info("Email exists: {}", email);
        } else {
            logger.warn("Email does not exist: {}", email);
        }
        return exists;
    }

    public boolean updatePasswordById(Integer userId, String newPassword) {
        logger.info("Updating password for user ID: {}", userId);
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isPresent()) {
            userService.updatePassword(userOptional.get().getId(), newPassword);
            logger.info("Password updated successfully for user ID: {}", userId);
            return true;
        }
        logger.warn("User not found with ID: {}", userId);
        return false;
    }

}
