package cs.vsu.projectpalback.repository;

import cs.vsu.projectpalback.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TaskRepository extends JpaRepository<Task, Integer> {

    List<Task> findByGroupId(Integer groupId);
    List<Task> findByTeacherId(Integer teacherId);


}
