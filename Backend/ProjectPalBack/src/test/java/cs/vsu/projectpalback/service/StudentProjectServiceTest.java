package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.*;
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
public class StudentProjectServiceTest {

    @Autowired
    private StudentProjectService studentProjectService;

    @Autowired
    private GroupService groupService;

    @Autowired
    private UserService userService;

    @Autowired
    private ProjectService projectService;

    @Test
    public void testGetAllStudentProjects() {
        List<StudentProjectDTO> result = studentProjectService.getAllStudentProjects();
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetAllStudentProjectsByStudentId() {
        Integer studentId = 1;
        List<StudentProjectDTO> result = studentProjectService.getAllStudentProjectsByStudentId(studentId);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetAllStudentProjectsByProjectId() {
        Integer projectId = 1;
        List<StudentProjectDTO> result = studentProjectService.getAllStudentProjectsByProjectId(projectId);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetStudentsByProjectId() {
        Integer projectId = 1;
        List<UserWithoutPasswordDTO> result = studentProjectService.getStudentsByProjectId(projectId);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetProjectsByStudentId() {
        Integer studentId = 1;
        List<ProjectDTO> result = studentProjectService.getProjectsByStudentId(studentId);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetStudentProjectById() {
        Integer id = 1;
        StudentProjectDTO result = studentProjectService.getStudentProjectById(id);
        assertNull(result);
    }

    @Test
    public void testCreateStudentProject() {
        GroupDTO group = new GroupDTO();
        group.setGroupNumber(101);
        group.setCourseNumber(1);
        group = groupService.createGroup(group);

        UserDTO userDTO = new UserDTO();
        userDTO.setId(0);
        userDTO.setName("Test User");
        userDTO.setLogin("superduperlogin");
        userDTO.setPassword("password");
        userDTO.setSurname("Test User");
        userDTO.setPatronymic("Test User");
        userDTO.setRole(Role.STUDENT);
        userDTO.setGroupId(group.getId());

        UserDTO studentDTO = userService.createUser(userDTO);

        userDTO = new UserDTO();
        userDTO.setId(0);
        userDTO.setName("Test User");
        userDTO.setLogin("supadupalogin");
        userDTO.setPassword("password");
        userDTO.setSurname("Test User");
        userDTO.setPatronymic("Test User");
        userDTO.setRole(Role.TEACHER);

        userDTO = userService.createUser(userDTO);

        ProjectDTO project = new ProjectDTO();
        project.setId(1);
        project.setName("Test Project");
        project.setDescription("Test Project");
        project.setTeacherUserId(userDTO.getId());
        project.setFileLink("link");
        project.setStartDate(LocalDateTime.now());
        project.setEndDate(LocalDateTime.now());

        project = projectService.createProject(project);

        StudentProjectDTO studentProjectDTO = new StudentProjectDTO();
        studentProjectDTO.setProjectId(project.getId());
        studentProjectDTO.setId(0L);
        studentProjectDTO.setStudentUserId(studentDTO.getId());
        StudentProjectDTO result = studentProjectService.createStudentProject(studentProjectDTO);
        assertNotNull(result);
    }

    @Test
    public void testDeleteStudentProjectById() {
        Integer id = 1;
        assertFalse(studentProjectService.deleteStudentProjectById(id));
    }
}
