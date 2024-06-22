package cs.vsu.projectpalback.dto.auth;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ChangePasswordDTO {

    private int id;

    @NotBlank(message = "Password cannot be blank")
    private String password;

}
