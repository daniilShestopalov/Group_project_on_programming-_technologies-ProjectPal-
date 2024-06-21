package cs.vsu.projectpalback.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ChangeAvatarDTO {

    private int id;

    @NotBlank(message = "Avatar link cannot be blank")
    private String avatarLink;
}
