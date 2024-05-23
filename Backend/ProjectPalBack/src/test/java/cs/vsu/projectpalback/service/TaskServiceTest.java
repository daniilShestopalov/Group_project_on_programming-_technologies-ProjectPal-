package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.GroupDTO;
import cs.vsu.projectpalback.dto.TaskDTO;
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
public class TaskServiceTest {

    @Autowired
    private TaskService taskService;

    @Autowired
    private UserService userService;

    @Autowired
    private GroupService groupService;

    @Test
    public void testGetAllTasks() {
        List<TaskDTO> result = taskService.getAllTasks();
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetTasksByGroupId() {
        Integer groupId = 1;
        List<TaskDTO> result = taskService.getTasksByGroupId(groupId);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetTasksByTeacherId() {
        Integer teacherId = 1;
        List<TaskDTO> result = taskService.getTasksByTeacherId(teacherId);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetTasksByDateAndGroup() {
        Integer groupId = 1;
        LocalDateTime date = LocalDateTime.now();
        List<TaskDTO> result = taskService.getTasksByDateAndGroup(groupId, date);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetTasksByMonthAndGroup() {
        Integer groupId = 1;
        YearMonth month = YearMonth.now();
        List<TaskDTO> result = taskService.getTasksByMonthAndGroup(groupId, month);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetTasksByDateAndTeacher() {
        Integer teacherId = 1;
        LocalDateTime date = LocalDateTime.now();
        List<TaskDTO> result = taskService.getTasksByDateAndTeacher(teacherId, date);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetTasksByMonthAndTeacher() {
        Integer teacherId = 1;
        YearMonth month = YearMonth.now();
        List<TaskDTO> result = taskService.getTasksByMonthAndTeacher(teacherId, month);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetTaskById() {
        Integer id = 1;
        TaskDTO result = taskService.getTaskById(id);
        assertNull(result);
    }

    @Test
    public void testCreateTask() {
        UserDTO userDTO = new UserDTO();
        userDTO.setId(1);
        userDTO.setName("Test User");
        userDTO.setLogin("test");
        userDTO.setPassword("password");
        userDTO.setSurname("Test User");
        userDTO.setPatronymic("Test User");
        userDTO.setRole(Role.TEACHER);

        userDTO = userService.createUser(userDTO);

        GroupDTO group = new GroupDTO();
        group.setGroupNumber(101);
        group.setCourseNumber(1);
        group = groupService.createGroup(group);

        TaskDTO taskDTO = new TaskDTO();
        taskDTO.setId(0);
        taskDTO.setName("name");
        taskDTO.setDescription("desc");
        taskDTO.setGroupId(group.getId());
        taskDTO.setEndDate(LocalDateTime.now());
        taskDTO.setStartDate(LocalDateTime.now());
        taskDTO.setFileLink("link");
        taskDTO.setTeacherUserId(userDTO.getId());

        TaskDTO result = taskService.createTask(taskDTO);
        assertNotNull(result);
    }

    @Test
    public void testUpdateTask() {
        TaskDTO taskDTO = new TaskDTO();
        taskDTO.setId(1);
        TaskDTO result = taskService.updateTask(taskDTO);
        assertNull(result);
    }

    @Test
    public void testDeleteTask() {
        Integer id = 1;
        assertFalse(taskService.deleteTask(id));
    }

    @Test
    public void testCountTasksByGroupId() {
        Integer groupId = 1;
        long result = taskService.countTasksByGroupId(groupId);
        assertEquals(0, result);
    }

    @Test
    public void testCountTasksByTeacherId() {
        Integer teacherId = 1;
        long result = taskService.countTasksByTeacherId(teacherId);
        assertEquals(0, result);
    }
}
