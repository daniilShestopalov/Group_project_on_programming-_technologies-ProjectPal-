package cs.vsu.projectpalback.dto.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class RegistrationUserDTO {

    private int id;

    @NotBlank(message = "Login is required")
    @Email(message = "Invalid email format")
    private String login;

    @NotBlank(message = "Phone number is required")
    private String phoneNumber;

    @NotBlank(message = "New password is required")
    private String newPassword;

}
