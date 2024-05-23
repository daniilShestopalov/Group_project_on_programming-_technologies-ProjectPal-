package cs.vsu.projectpalback.service;

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
import java.time.YearMonth;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class ProjectServiceTest {

    @Autowired
    private ProjectService projectService;

    @Autowired
    private UserService userService;

    @Test
    public void testGetAllProjects() {
        List<ProjectDTO> result = projectService.getAllProjects();
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetAllProjectsByProjectId() {
        List<ProjectDTO> result = projectService.getAllProjectsByProjectId(List.of(1, 2, 3));
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetProjectsByDateAndTeacherId() {
        LocalDateTime date = LocalDateTime.now();
        List<ProjectDTO> result = projectService.getProjectsByDateAndTeacherId(1, date);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetProjectsByMonthAndTeacherId() {
        YearMonth month = YearMonth.now();
        List<ProjectDTO> result = projectService.getProjectsByMonthAndTeacherId(1, month);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetAllProjectsByTeacherId() {
        List<ProjectDTO> result = projectService.getAllProjectsByTeacherId(1);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetProjectsByStudentIdAndDate() {
        LocalDateTime date = LocalDateTime.now();
        List<ProjectDTO> result = projectService.getProjectsByStudentIdAndDate(1, date);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetProjectsByStudentIdAndMonth() {
        YearMonth month = YearMonth.now();
        List<ProjectDTO> result = projectService.getProjectsByStudentIdAndMonth(1, month);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetProjectById() {
        Integer id = 1;
        ProjectDTO result = projectService.getProjectById(id);
        assertNull(result);
    }

    @Test
    public void testCreateProject() {
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
        ProjectDTO result = projectService.createProject(projectDTO);
        assertNotNull(result);
    }

    @Test
    public void testUpdateProject() {
        ProjectDTO projectDTO = new ProjectDTO();
        projectDTO.setId(1);
        ProjectDTO result = projectService.updateProject(projectDTO);
        assertNull(result);
    }

    @Test
    public void testDeleteProject() {
        Integer id = 1;
        assertFalse(projectService.deleteProject(id));
    }

    @Test
    public void testCountProjectsByTeacherId() {
        Integer teacherId = 1;
        long result = projectService.countProjectsByTeacherId(teacherId);
        assertEquals(0, result);
    }

    @Test
    public void testCountProjectsByStudentId() {
        Integer studentId = 1;
        long result = projectService.countProjectsByStudentId(studentId);
        assertEquals(0, result);
    }
}
