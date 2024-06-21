package cs.vsu.projectpalback.dto.auth;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CodeDTO {

    @NotBlank
    private String code;

}
