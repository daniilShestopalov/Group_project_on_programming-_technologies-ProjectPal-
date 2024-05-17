package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.dto.auth.AuthUserDTO;
import cs.vsu.projectpalback.dto.auth.PasswordResetRequestDTO;
import cs.vsu.projectpalback.dto.auth.RegistrationUserDTO;
import cs.vsu.projectpalback.dto.auth.TmpInitialLoginUserDTO;
import cs.vsu.projectpalback.mapper.UserWithoutPasswordMapper;
import cs.vsu.projectpalback.model.User;
import cs.vsu.projectpalback.repository.UserRepository;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@AllArgsConstructor
public class AuthService {

    private final UserService userService;

    private final BCryptPasswordEncoder passwordEncoder;

    private final UserWithoutPasswordMapper userWithoutPasswordMapper;

    private final UserRepository userRepository;

    public UserWithoutPasswordDTO authenticate(@NotNull AuthUserDTO authUserDTO) {
        Optional<User> userOptional = userRepository.findByLogin(authUserDTO.getLogin());
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            if (!passwordEncoder.matches(authUserDTO.getPassword(), user.getPassword())) {
                return userWithoutPasswordMapper.toDto(user);
            }
        }
        return null;
    }

    public Integer verifyTemporaryUser(@NotNull TmpInitialLoginUserDTO tmpInitialLoginUserDTO) {
        Optional<User> userOptional = userRepository.findByLogin(tmpInitialLoginUserDTO.getTempLogin());
        return userOptional.filter(user -> tmpInitialLoginUserDTO.getTempPassword().equals(user.getPassword()))
                .map(User::getId)
                .orElse(null);
    }

    public boolean registerUser(@NotNull RegistrationUserDTO registrationUserDTO) {
        Optional<User> userOptional = userRepository.findById(registrationUserDTO.getId());
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.setLogin(registrationUserDTO.getLogin());
            user.setPhoneNumber(registrationUserDTO.getPhoneNumber());
            userService.updatePassword(user.getId(), registrationUserDTO.getNewPassword());
            userRepository.save(user);
            return true;
        }
        return false;
    }

    public boolean checkEmailExists(@NotNull PasswordResetRequestDTO passwordResetRequestDTO) {
        Optional<User> userOptional = userRepository.findByLogin(passwordResetRequestDTO.getEmail());
        return userOptional.isPresent();
    }

    public boolean updatePasswordById(Integer userId, String newPassword) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isPresent()) {
            userService.updatePassword(userOptional.get().getId(), newPassword);
            return true;
        }
        return false;
    }
}
