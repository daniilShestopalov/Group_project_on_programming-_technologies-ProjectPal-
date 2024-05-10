package cs.vsu.projectpalback.repository;

import cs.vsu.projectpalback.model.Project;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProjectRepository extends JpaRepository<Project, Integer> {
    //TODO: поиск по преподу

}
