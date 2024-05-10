package cs.vsu.projectpalback.repository;

import cs.vsu.projectpalback.model.StudentProject;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StudentProjectRepository extends JpaRepository<StudentProject, Integer> {
    //TODO: поиск по проекту и поиск по студенту
}
