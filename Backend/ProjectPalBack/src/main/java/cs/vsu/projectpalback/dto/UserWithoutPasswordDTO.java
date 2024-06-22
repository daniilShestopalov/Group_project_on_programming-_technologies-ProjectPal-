package cs.vsu.projectpalback.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;


@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
public class UserWithoutPasswordDTO extends UserDTO{

    public UserWithoutPasswordDTO(@NotNull UserDTO user) {
        this.setId(user.getId());
        this.setLogin(user.getLogin());
        this.setName(user.getName());
        this.setSurname(user.getSurname());
        this.setPatronymic(user.getPatronymic());
        this.setPhoneNumber(user.getPhoneNumber());
        this.setAvatarLink(user.getAvatarLink());
        this.setRole(user.getRole());
        this.setGroupId(user.getGroupId());
    }

    @JsonIgnore
    @Override
    public String getPassword() {
        return null;
    }
}
