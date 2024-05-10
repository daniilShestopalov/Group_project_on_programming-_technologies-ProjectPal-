package cs.vsu.projectpalback.repository;

import cs.vsu.projectpalback.model.ProjectAnswer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProjectAnswerRepository extends JpaRepository<ProjectAnswer,Integer> {
    //TODO: поиск по проекту
}
