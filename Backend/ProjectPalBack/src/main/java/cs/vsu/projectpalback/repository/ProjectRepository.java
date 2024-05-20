package cs.vsu.projectpalback.repository;

import cs.vsu.projectpalback.model.Project;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ProjectRepository extends JpaRepository<Project, Integer> {

    List<Project> findAllByTeacherId(Integer teacherId);
    List<Project> findByTeacherIdAndStartDateBetween(Integer teacherId, LocalDateTime startDate, LocalDateTime endDate);
    List<Project> findByTeacherIdAndStartDate(Integer teacherId, LocalDateTime date);

    /*@Query("SELECT p FROM Project p JOIN StudentProject sp ON p.id = sp.project.id WHERE sp.student.id = :studentId AND p.startDate = :date")
    List<Project> findProjectsByStudentIdAndStartDate(Integer studentId, LocalDateTime date);

    @Query("SELECT p FROM Project p JOIN FETCH StudentProject sp ON p.id = sp.project.id WHERE sp.student.id = :studentId AND p.startDate >= :startDate AND p.endDate <= :endDate")
    List<Project> findProjectsByStudentIdAndDateRange(Integer studentId, LocalDateTime startDate, LocalDateTime endDate);*/

    long countByTeacherId(Integer teacherId);

    /*@Query("SELECT COUNT(p) FROM Project p JOIN StudentProject sp ON p.id = sp.project.id WHERE sp.student.id = :studentId")
    long countByStudentId(Integer studentId);*/
}
