package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import cs.vsu.projectpalback.security.JwtProvider;
import lombok.AllArgsConstructor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class PasswordResetService {

    private final JwtProvider jwtProvider;

    private final AuthService authService;

    private final UserService userService;

    private final JavaMailSender mailSender;

    public void sendPasswordReset(String email) {
        if (authService.checkEmailExists(email)) {
            UserWithoutPasswordDTO user = userService.getUserByLoginWithoutPassword(email);
            Integer userId = user.getId();
            String token = jwtProvider.generatePasswordResetToken(userId);

            String subject = "Password Reset Request";
            String text = "Your password reset code is: " + token;

            sendEmail(email, subject, text);
        } else {
            throw new RuntimeException("User with email " + email + " not found");
        }

    }

    private void sendEmail(String to, String subject, String text) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("ivan.grigorij4@yandex.ru");
        message.setTo(to);
        message.setSubject(subject);
        message.setText(text);
        mailSender.send(message);
    }

}
