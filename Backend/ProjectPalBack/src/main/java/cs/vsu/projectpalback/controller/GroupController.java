package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.dto.GroupDTO;
import cs.vsu.projectpalback.service.GroupService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/group")
@Tag(name = "GroupController", description = "Authorized users only.")
@AllArgsConstructor
public class GroupController {

    private static final Logger LOGGER = LoggerFactory.getLogger(AuthController.class);

    private final GroupService groupService;

    @GetMapping
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get all groups", description = "Returns a list of all groups")
    public ResponseEntity<List<GroupDTO>> getAllGroups() {
        try {
            LOGGER.info("Fetching all groups");
            List<GroupDTO> groups = groupService.getAllGroups();
            return ResponseEntity.ok(groups);
        } catch (Exception e) {
            LOGGER.error("Error fetching groups: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get group by ID", description = "Returns a group by the given ID")
    public ResponseEntity<GroupDTO> getGroupById(@PathVariable Integer id) {
        LOGGER.info("Fetching group with ID: {}", id);
        GroupDTO groupDTO = groupService.getGroupById(id);
        if (groupDTO != null) {
            return ResponseEntity.ok(groupDTO);
        } else {
            LOGGER.warn("No group found with ID: {}", id);
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('АДМИН', 'ПРЕПОДАВАТЕЛЬ')")
    @Operation(summary = "Create a new group (admin, teacher)", description = "Creates a new group. Preferably 0 in the id")
    public ResponseEntity<GroupDTO> createGroup(@RequestBody GroupDTO groupDTO) {
        try {
            LOGGER.info("Creating a new group");
            GroupDTO createdGroup = groupService.createGroup(groupDTO);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdGroup);
        } catch (Exception e) {
            LOGGER.error("Could not create a new group: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PutMapping
    @PreAuthorize("hasAnyRole('АДМИН', 'ПРЕПОДАВАТЕЛЬ')")
    @Operation(summary = "Update a group", description = "Updates an existing group")
    public ResponseEntity<GroupDTO> updateGroup(@RequestBody GroupDTO groupDTO) {
        LOGGER.info("Updating group with ID: {}", groupDTO.getId());
        GroupDTO updatedGroup = groupService.updateGroup(groupDTO);
        if (updatedGroup != null) {
            return ResponseEntity.ok(updatedGroup);
        } else {
            LOGGER.warn("No group found with ID: {}", groupDTO.getId());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('АДМИН', 'ПРЕПОДАВАТЕЛЬ')")
    @Operation(summary = "Delete a group (admin, teacher)", description = "Deletes a group by the given ID")
    public ResponseEntity<Void> deleteGroup(@PathVariable Integer id) {
        LOGGER.info("Deleting group with ID: {}", id);
        boolean isDeleted = groupService.deleteGroup(id);
        if (isDeleted) {
            return ResponseEntity.ok().build();
        } else {
            LOGGER.warn("No group found with ID: {} for deletion", id);
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

}
