package cs.vsu.projectpalback.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ProjectAnswerDTO {

    private int id;

    @NotNull(message = "Project id cannot be null")
    private int projectId;

    @NotNull(message = "Submission date cannot be null")
    private LocalDateTime submissionDate;

    private String teacherCommentary;

    private String studentCommentary;

    private Integer grade;

    @NotNull(message = "File link cannot be null")
    private String fileLink;

}
