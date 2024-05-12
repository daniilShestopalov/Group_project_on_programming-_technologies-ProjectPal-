package cs.vsu.projectpalback.dto.auth;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class TmpInitialLoginUserDTO {

    @NotNull(message = "Temp login cannot be null")
    private String tempLogin;

    @NotNull(message = "Temp password cannot be null")
    private String tempPassword;

}
