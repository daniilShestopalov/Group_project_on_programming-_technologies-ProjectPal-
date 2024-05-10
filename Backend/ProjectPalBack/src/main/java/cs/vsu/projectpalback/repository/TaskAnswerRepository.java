package cs.vsu.projectpalback.repository;

import cs.vsu.projectpalback.model.TaskAnswer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TaskAnswerRepository extends JpaRepository<TaskAnswer, Integer> {
    //TODO: поиск по заданию
}
