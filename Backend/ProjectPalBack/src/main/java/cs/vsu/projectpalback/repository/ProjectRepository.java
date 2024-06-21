package cs.vsu.projectpalback.repository;

import cs.vsu.projectpalback.model.Project;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ProjectRepository extends JpaRepository<Project, Integer> {

    List<Project> findAllByTeacherId(Integer teacherId);
    List<Project> findByTeacherIdAndEndDateBetween(Integer teacherId, LocalDateTime startDate, LocalDateTime endDate);
    List<Project> findByTeacherIdAndStartDate(Integer teacherId, LocalDateTime date);
    long countByTeacherId(Integer teacherId);

}
