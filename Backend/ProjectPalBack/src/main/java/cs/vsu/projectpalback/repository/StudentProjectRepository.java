package cs.vsu.projectpalback.repository;

import cs.vsu.projectpalback.model.StudentProject;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudentProjectRepository extends JpaRepository<StudentProject, Integer> {

    List<StudentProject> findByStudentId(Integer studentId);
    List<StudentProject> findByProjectId(Integer projectId);
}
