package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.ProjectAnswerDTO;
import cs.vsu.projectpalback.dto.ProjectDTO;
import cs.vsu.projectpalback.dto.UserDTO;
import cs.vsu.projectpalback.model.enumerate.Role;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class ProjectAnswerServiceTest {

    @Autowired
    private ProjectAnswerService projectAnswerService;

    @Autowired
    private UserService userService;

    @Autowired
    private ProjectService projectService;

    @Test
    public void testGetAllProjectAnswers() {
        List<ProjectAnswerDTO> result = projectAnswerService.getAllProjectAnswers();
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetProjectAnswerById() {
        Integer id = 1;
        ProjectAnswerDTO result = projectAnswerService.getProjectAnswerById(id);
        assertNull(result);
    }

    @Test
    public void testGetProjectAnswerByProjectId() {
        Integer projectId = 1;
        ProjectAnswerDTO result = projectAnswerService.getProjectAnswerByProjectId(projectId);
        assertNull(result);
    }

    @Test
    public void testCreateProjectAnswer() {
        UserDTO userDTO = new UserDTO();
        userDTO.setId(1);
        userDTO.setName("Test User");
        userDTO.setLogin("test");
        userDTO.setPassword("password");
        userDTO.setSurname("Test User");
        userDTO.setPatronymic("Test User");
        userDTO.setRole(Role.TEACHER);

        userDTO = userService.createUser(userDTO);

        ProjectDTO projectDTO = new ProjectDTO();
        projectDTO.setId(0);
        projectDTO.setFileLink("link");
        projectDTO.setName("projectName");
        projectDTO.setDescription("projectDescription");
        projectDTO.setEndDate(LocalDateTime.now());
        projectDTO.setStartDate(LocalDateTime.now());
        projectDTO.setTeacherUserId(userDTO.getId());

        projectDTO = projectService.createProject(projectDTO);

        ProjectAnswerDTO projectAnswerDTO = new ProjectAnswerDTO();
        projectAnswerDTO.setProjectId(projectDTO.getId());
        projectAnswerDTO.setId(0);
        projectAnswerDTO.setGrade(5);
        projectAnswerDTO.setFileLink("link");
        projectAnswerDTO.setSubmissionDate(LocalDateTime.now());
        projectAnswerDTO.setStudentCommentary("good");
        projectAnswerDTO.setTeacherCommentary("bad");
        projectAnswerDTO = projectAnswerService.createProjectAnswer(projectAnswerDTO);

        assertNotNull(projectAnswerDTO);
    }

    @Test
    public void testUpdateProjectAnswer() {
        ProjectAnswerDTO projectAnswerDTO = new ProjectAnswerDTO();
        projectAnswerDTO.setId(1);
        ProjectAnswerDTO result = projectAnswerService.updateProjectAnswer(projectAnswerDTO);
        assertNull(result);
    }

    @Test
    public void testDeleteProjectAnswer() {
        Integer id = 1;
        assertFalse(projectAnswerService.deleteProjectAnswer(id));
    }
}
