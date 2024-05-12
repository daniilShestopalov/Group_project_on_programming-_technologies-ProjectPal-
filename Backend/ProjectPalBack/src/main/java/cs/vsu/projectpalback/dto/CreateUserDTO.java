package cs.vsu.projectpalback.dto;

import cs.vsu.projectpalback.model.enumerate.Role;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CreateUserDTO {

    private int id;

    @NotNull(message = "Login cannot be null")
    private String login;

    @NotNull(message = "Password cannot be null")
    private String password;

    @NotNull(message = "Name cannot be null")
    private String name;

    @NotNull(message = "Surname cannot be null")
    private String surname;

    private String patronymic;

    private String phoneNumber;

    private String avatarLink;

    @NotNull(message = "Role cannot be null")
    private Role role;

    private Integer groupId;

}
