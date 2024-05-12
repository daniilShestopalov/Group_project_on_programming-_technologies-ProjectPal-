package cs.vsu.projectpalback.dto.auth;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class RegistrationUserDTO {

    @NotNull(message = "Login cannot be null")
    private String login;

    @NotNull(message = "Phone number cannot be null")
    private String phoneNumber;

    @NotNull(message = "New password cannot be null")
    private String newPassword;

}
