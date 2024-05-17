package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.GroupDTO;
import cs.vsu.projectpalback.mapper.GroupMapper;
import cs.vsu.projectpalback.model.Group;
import cs.vsu.projectpalback.repository.GroupRepository;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class GroupService {

    private final Logger LOGGER = LoggerFactory.getLogger(GroupService.class);

    private final GroupRepository groupRepository;

    private final GroupMapper groupMapper;

    public List<GroupDTO> getAllGroups() {
        List<Group> groups = groupRepository.findAll();
        return groupMapper.toDtoList(groups);
    }

    public GroupDTO getGroupById(Integer id) {
        LOGGER.info("Fetching group with ID: {}", id);
        Optional<Group> groupOptional = groupRepository.findById(id);
        if (groupOptional.isPresent()) {
            LOGGER.info("Group found with ID: {}", id);
            return groupMapper.toDto(groupOptional.get());
        } else {
            LOGGER.warn("No group found with ID: {}", id);
            return null;
        }
    }

    public GroupDTO createGroup(GroupDTO groupDTO) {
        try {
            Group group = groupRepository.save(groupMapper.toEntity(groupDTO));
            LOGGER.info("Group created with ID: {}", group.getId());
            return groupMapper.toDto(group);
        } catch (Exception e) {
            LOGGER.error("Error creating group: {}", e.getMessage(), e);
            throw new RuntimeException("Error creating group", e);
        }
    }

    public GroupDTO updateGroup(@NotNull GroupDTO groupDTO) {
        LOGGER.info("Updating group with ID: {}", groupDTO.getId());
        Optional<Group> existingGroup = groupRepository.findById(groupDTO.getId());
        if (existingGroup.isPresent()) {
            Group group = existingGroup.get();
            groupMapper.updateEntityFromDto(groupDTO, group);
            Group updatedGroup = groupRepository.save(group);
            LOGGER.info("Group updated with ID: {}", updatedGroup.getId());
            return groupMapper.toDto(updatedGroup);
        } else {
            LOGGER.warn("No group found with ID for update: {}", groupDTO.getId());
            return null;
        }
    }

    public boolean deleteGroup(Integer id) {
        try {
            LOGGER.info("Deleting group with ID: {}", id);
            Optional<Group> existingGroup = groupRepository.findById(id);
            if (existingGroup.isPresent()) {
                groupRepository.deleteById(id);
                LOGGER.info("Group deleted with ID: {}", id);
                return true;
            } else {
                LOGGER.warn("No group found with ID for delete: {}", id);
                return false;
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting group with ID: {}", id, e);
            throw new RuntimeException("Error deleting group", e);
        }
    }

}
