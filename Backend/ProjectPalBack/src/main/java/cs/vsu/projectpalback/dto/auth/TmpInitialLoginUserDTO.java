package cs.vsu.projectpalback.dto.auth;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class TmpInitialLoginUserDTO {

    @NotBlank(message = "Temp login is required")
    private String tempLogin;

    @NotBlank(message = "Temp password is required")
    private String tempPassword;

}
