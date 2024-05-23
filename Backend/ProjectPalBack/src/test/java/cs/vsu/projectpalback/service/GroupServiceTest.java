package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.GroupDTO;
import cs.vsu.projectpalback.model.Group;
import cs.vsu.projectpalback.repository.GroupRepository;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.ArrayList;
import java.util.List;

@RunWith(SpringRunner.class)
@SpringBootTest
@ActiveProfiles("test")
@Rollback(true)
public class GroupServiceTest {

    @Autowired
    private GroupService groupService;

    @Autowired
    private GroupRepository groupRepository;

    @Before
    public void setUp() {
        List<Group> groups = new ArrayList<>();
        Group group1 = new Group();
        group1.setId(1);
        Group group2 = new Group();
        group2.setId(2);
        groups.add(group1);
        groups.add(group2);

        groupRepository.saveAll(groups);
    }

    @Test
    public void testGetAllGroups() {
        List<GroupDTO> expectedGroupDTOs = new ArrayList<>();
        GroupDTO groupDTO1 = new GroupDTO();
        groupDTO1.setId(1);
        GroupDTO groupDTO2 = new GroupDTO();
        groupDTO2.setId(2);
        expectedGroupDTOs.add(groupDTO1);
        expectedGroupDTOs.add(groupDTO2);

        List<GroupDTO> fetchedGroups = groupService.getAllGroups();

        Assert.assertEquals(expectedGroupDTOs.size(), fetchedGroups.size());
        for (int i = 0; i < expectedGroupDTOs.size(); i++) {
            Assert.assertEquals(expectedGroupDTOs.get(i).getId(), fetchedGroups.get(i).getId());
        }
    }

    @Test
    public void testGetGroupById_GroupExists() {
        int id = 1;

        GroupDTO expectedGroupDTO = new GroupDTO();
        expectedGroupDTO.setId(id);

        GroupDTO fetchedGroup = groupService.getGroupById(id);

        Assert.assertNotNull(fetchedGroup);
        Assert.assertEquals(expectedGroupDTO.getId(), fetchedGroup.getId());
    }

    @Test
    public void testGetGroupById_GroupDoesNotExist() {
        int id = 3;

        GroupDTO fetchedGroup = groupService.getGroupById(id);

        Assert.assertNull(fetchedGroup);
    }

    @Test
    public void testUpdateGroup_GroupExists() {
        int id = 1;
        GroupDTO groupDTO = new GroupDTO();
        groupDTO.setId(id);

        GroupDTO updatedGroupDTO = groupService.updateGroup(groupDTO);

        Assert.assertNotNull(updatedGroupDTO);
        Assert.assertEquals(groupDTO.getId(), updatedGroupDTO.getId());
    }

    @Test
    public void testUpdateGroup_GroupDoesNotExist() {
        int id = 3; // Assuming this ID doesn't exist
        GroupDTO groupDTO = new GroupDTO();
        groupDTO.setId(id);

        GroupDTO updatedGroupDTO = groupService.updateGroup(groupDTO);

        Assert.assertNull(updatedGroupDTO);
    }

    @Test
    public void testDeleteGroup_GroupExists() {
        int id = 1;

        boolean isDeleted = groupService.deleteGroup(id);

        Assert.assertTrue(isDeleted);
    }

    @Test
    public void testDeleteGroup_GroupDoesNotExist() {
        int id = 3;

        boolean isDeleted = groupService.deleteGroup(id);

        Assert.assertFalse(isDeleted);
    }
}
