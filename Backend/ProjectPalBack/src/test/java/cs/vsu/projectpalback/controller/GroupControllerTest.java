package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.controller.GroupController;
import cs.vsu.projectpalback.dto.GroupDTO;
import cs.vsu.projectpalback.service.GroupService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

public class GroupControllerTest {

    @Mock
    private GroupService groupService;

    @InjectMocks
    private GroupController groupController;

    @BeforeEach
    public void init() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testGetAllGroups() {
        // Mocking service response
        GroupDTO group1 = new GroupDTO();
        group1.setId(1);
        group1.setGroupNumber(101);
        group1.setCourseNumber(1);

        GroupDTO group2 = new GroupDTO();
        group2.setId(2);
        group2.setGroupNumber(102);
        group2.setCourseNumber(1);

        List<GroupDTO> mockGroups = Arrays.asList(group1, group2);
        when(groupService.getAllGroups()).thenReturn(mockGroups);

        // Calling controller method
        ResponseEntity<List<GroupDTO>> responseEntity = groupController.getAllGroups();

        // Verifying the result
        assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        assertEquals(2, responseEntity.getBody().size());
        verify(groupService, times(1)).getAllGroups();
    }

    @Test
    public void testGetGroupById() {
        int groupId = 1;
        GroupDTO mockGroup = new GroupDTO();
        mockGroup.setId(groupId);
        mockGroup.setGroupNumber(101);
        mockGroup.setCourseNumber(1);

        when(groupService.getGroupById(groupId)).thenReturn(mockGroup);

        ResponseEntity<GroupDTO> responseEntity = groupController.getGroupById(groupId);

        assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        assertEquals(groupId, responseEntity.getBody().getId());
        verify(groupService, times(1)).getGroupById(groupId);
    }

    // Similarly, you can write tests for other methods like createGroup, updateGroup, and deleteGroup
    // Ensure to cover scenarios such as successful operations, error handling, and authorization checks.
}
