package cs.vsu.projectpalback.dto.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AuthUserDTO {

    @NotBlank(message = "Login is required")
    @Email(message = "Invalid email format")
    private String login;

    @NotBlank(message = "Password is required")
    private String password;
}
