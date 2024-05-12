package cs.vsu.projectpalback.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class TaskDTO {

    private int id;

    @NotNull(message = "Task name cannot be null")
    private String name;

    @NotNull(message = "Teacher user id cannot be null")
    private int teacherUserId;

    @NotNull(message = "Group id cannot be null")
    private int groupId;

    private String description;

    private String fileLink;

    @NotNull(message = "Start date cannot be null")
    private LocalDateTime startDate;

    private LocalDateTime endDate;

}
