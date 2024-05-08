package cs.vsu.projectpalback.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "\"group\"")
@Getter
@Setter
public class Group {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "group_number", nullable = false)
    private int groupNumber;

    @Column(name = "course_number", nullable = false)
    private int courseNumber;

}
