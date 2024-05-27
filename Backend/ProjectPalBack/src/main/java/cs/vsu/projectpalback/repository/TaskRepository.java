package cs.vsu.projectpalback.repository;

import cs.vsu.projectpalback.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface TaskRepository extends JpaRepository<Task, Integer> {

    List<Task> findByGroupId(Integer groupId);
    List<Task> findByTeacherId(Integer teacherId);
    List<Task> findByGroupIdAndStartDate(Integer groupId, LocalDateTime startDate);
    List<Task> findByGroupIdAndEndDateBetween(Integer groupId, LocalDateTime startDate, LocalDateTime endDate);
    List<Task> findByTeacherIdAndStartDate(Integer teacherId, LocalDateTime date);
    List<Task> findByTeacherIdAndEndDateBetween(Integer teacherId, LocalDateTime startDate, LocalDateTime endDate);
    long countByGroupId(Integer groupId);
    long countByTeacherId(Integer teacherId);
}
