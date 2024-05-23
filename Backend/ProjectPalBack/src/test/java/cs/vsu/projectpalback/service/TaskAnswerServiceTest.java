package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.GroupDTO;
import cs.vsu.projectpalback.dto.TaskAnswerDTO;
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
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class TaskAnswerServiceTest {

    @Autowired
    private TaskAnswerService taskAnswerService;

    @Autowired
    private UserService userService;

    @Autowired
    private TaskService taskService;

    @Autowired
    private GroupService groupService;

    @Test
    public void testGetAllTaskAnswers() {
        List<TaskAnswerDTO> result = taskAnswerService.getAllTaskAnswers();
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetTaskAnswerById() {
        Integer id = 1;
        TaskAnswerDTO result = taskAnswerService.getTaskAnswerById(id);
        assertNull(result);
    }

    @Test
    public void testGetTaskAnswersByTaskId() {
        Integer taskId = 1;
        List<TaskAnswerDTO> result = taskAnswerService.getTaskAnswersByTaskId(taskId);
        assertNotNull(result);
        assertEquals(0, result.size());
    }

    @Test
    public void testGetTaskAnswerByTaskIdAndStudentId() {
        Integer taskId = 1;
        Integer studentId = 1;
        TaskAnswerDTO result = taskAnswerService.getTaskAnswerByTaskIdAndStudentId(taskId, studentId);
        assertNull(result);
    }

    @Test
    public void testCreateTaskAnswer() {
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

        taskDTO = taskService.createTask(taskDTO);



        userDTO = new UserDTO();
        userDTO.setId(0);
        userDTO.setName("Test User");
        userDTO.setLogin("superduperlogin");
        userDTO.setPassword("password");
        userDTO.setSurname("Test User");
        userDTO.setPatronymic("Test User");
        userDTO.setRole(Role.STUDENT);
        userDTO.setGroupId(group.getId());

        UserDTO studentDTO = userService.createUser(userDTO);

        TaskAnswerDTO taskAnswerDTO = new TaskAnswerDTO();

        taskAnswerDTO.setTaskId(taskDTO.getId());
        taskAnswerDTO.setId(0);
        taskAnswerDTO.setFileLink("link");
        taskAnswerDTO.setGrade(5);
        taskAnswerDTO.setSubmissionDate(LocalDateTime.now());
        taskAnswerDTO.setTeacherCommentary("a");
        taskAnswerDTO.setStudentCommentary("boba");
        taskAnswerDTO.setStudentUserId(studentDTO.getId());

        TaskAnswerDTO result = taskAnswerService.createTaskAnswer(taskAnswerDTO);
        assertNotNull(result);
    }

    @Test
    public void testUpdateTaskAnswer() {
        TaskAnswerDTO taskAnswerDTO = new TaskAnswerDTO();
        taskAnswerDTO.setId(1);
        TaskAnswerDTO result = taskAnswerService.updateTaskAnswer(taskAnswerDTO);
        assertNull(result);
    }

    @Test
    public void testDeleteTaskAnswer() {
        Integer id = 1;
        assertFalse(taskAnswerService.deleteTaskAnswer(id));
    }
}
