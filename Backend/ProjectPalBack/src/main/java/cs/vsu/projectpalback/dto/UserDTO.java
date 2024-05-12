package cs.vsu.projectpalback.dto;

import cs.vsu.projectpalback.model.enumerate.Role;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserDTO {

    private int id;

    @NotBlank(message = "Login is required")
    private String login;

    @NotBlank(message = "Name is required")
    private String name;

    @NotBlank(message = "Surname is required")
    private String surname;

    private String patronymic;

    private String phoneNumber;

    private String avatarLink;

    @NotNull(message = "Role cannot be null")
    private Role role;

    private Integer groupId;

}
