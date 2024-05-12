package cs.vsu.projectpalback.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class StudentProjectDTO {

    private Long id;

    @NotNull(message = "Student user id cannot be null")
    private int studentUserId;

    @NotNull(message = "Project id cannot be null")
    private int projectId;
}
