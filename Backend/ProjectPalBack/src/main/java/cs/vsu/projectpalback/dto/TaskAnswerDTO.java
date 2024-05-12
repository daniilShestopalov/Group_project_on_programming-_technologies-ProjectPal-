package cs.vsu.projectpalback.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class TaskAnswerDTO {

    private int id;

    @NotNull(message = "Task id cannot be null")
    private int taskId;

    @NotNull(message = "Student user id cannot be null")
    private int studentUserId;

    @NotNull(message = "Submission date cannot be null")
    private LocalDateTime submissionDate;

    private String teacherCommentary;

    private String studentCommentary;

    private Integer grade;

    @NotBlank(message = "File link is required")
    private String fileLink;

}
