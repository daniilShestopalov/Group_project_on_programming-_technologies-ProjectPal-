package cs.vsu.projectpalback.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class GroupDTO {

    private int id;

    @NotNull(message = "Group number cannot be null")
    private int groupNumber;

    @NotNull(message = "Course number cannot be null")
    private int courseNumber;
}
