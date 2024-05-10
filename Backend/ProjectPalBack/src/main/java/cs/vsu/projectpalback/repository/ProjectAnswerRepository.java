package cs.vsu.projectpalback.repository;

import cs.vsu.projectpalback.model.ProjectAnswer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ProjectAnswerRepository extends JpaRepository<ProjectAnswer,Integer> {

    Optional<ProjectAnswer> findByProjectId(Integer projectId);
}
