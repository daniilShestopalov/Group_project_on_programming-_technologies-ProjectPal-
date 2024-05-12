package cs.vsu.projectpalback.dto;

import cs.vsu.projectpalback.model.User;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class TaskAnswerDTO {

    private int id;

    @NotNull(message = "Task id cannot be null")
    private int taskId;

    @NotNull(message = "Student user id cannot be null")
    private User student;

    @NotNull(message = "Submission date cannot be null")
    private LocalDateTime submissionDate;

    private String teacherCommentary;

    private String studentCommentary;

    private Integer grade;

    @NotNull(message = "File link cannot be null")
    private String fileLink;

}
