package cs.vsu.projectpalback.repository;

import cs.vsu.projectpalback.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TaskRepository extends JpaRepository<Task, Integer> {
    //TODO: поиск по группе
    //TODO: поск по преподователю

}
