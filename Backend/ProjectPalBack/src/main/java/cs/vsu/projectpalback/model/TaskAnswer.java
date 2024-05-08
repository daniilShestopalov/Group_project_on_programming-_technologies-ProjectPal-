package cs.vsu.projectpalback.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.time.LocalDateTime;

@Entity
@Table(name = "task_answer")
@Getter
@Setter
public class TaskAnswer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "task_id", referencedColumnName = "id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Task task;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", referencedColumnName = "id",nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User student;

    @Column(name = "submission_date", nullable = false)
    private LocalDateTime submissionDate;

    @Column(name = "teacher_commentary", columnDefinition = "TEXT")
    private String teacherCommentary;

    @Column(name = "student_commentary", columnDefinition = "TEXT")
    private String studentCommentary;

    //null если просто просмотренная работа
    @Column(name = "grade")
    private Integer grade;

    @Column(name = "file_link", columnDefinition = "TEXT")
    private String fileLink;

}
