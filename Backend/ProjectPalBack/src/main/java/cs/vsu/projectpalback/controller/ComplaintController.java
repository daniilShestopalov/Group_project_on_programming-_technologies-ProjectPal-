package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.dto.ComplaintDTO;
import cs.vsu.projectpalback.service.ComplaintService;
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
@RequestMapping("/complaint")
@Tag(name = "ComplaintController", description = "Authorized users only.")
@AllArgsConstructor
public class ComplaintController {

    private static final Logger LOGGER = LoggerFactory.getLogger(ComplaintController.class);

    private final ComplaintService complaintService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all complaints for admin", description = "Returns a list of all complaints")
    public ResponseEntity<List<ComplaintDTO>> getAllComplaints() {
        try {
            LOGGER.info("Fetching all complaints");
            List<ComplaintDTO> complaints = complaintService.getAllComplaints();
            return ResponseEntity.ok(complaints);
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get complaint by ID", description = "Returns a complaint by the given ID")
    public ResponseEntity<ComplaintDTO> getComplaintById(@PathVariable int id) {
        LOGGER.info("Fetching complaint with ID: {}", id);
        ComplaintDTO complaintDTO = complaintService.getComplaintById(id);
        if (complaintDTO != null) {
            return ResponseEntity.ok(complaintDTO);
        } else {
            LOGGER.warn("No complaint found with ID: {}", id);
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    @PostMapping
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Create a new complaint", description = "Creates a new complaint. Preferably 0 in the id")
    public ResponseEntity<ComplaintDTO> createComplaint(@RequestBody ComplaintDTO complaintDTO) {
        try {
            LOGGER.info("Creating a new complaint");
            ComplaintDTO createdComplaint = complaintService.createComplaint(complaintDTO);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdComplaint);
        } catch (Exception e) {
            LOGGER.error("Could not create a new complaint", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Delete a complaint for admin", description = "Deletes a complaint by the given ID")
    public ResponseEntity<Void> deleteComplaint(@PathVariable int id) {
        LOGGER.info("Deleting complaint with ID: {}", id);
        boolean isDeleted = complaintService.deleteComplaint(id);
        if (isDeleted) {
            return ResponseEntity.ok().build();
        } else {
            LOGGER.warn("No complaint found with ID: {} for deletion", id);
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    @GetMapping("/count")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get count of complaints", description = "Obtaining the count of complaints in the database")
    public ResponseEntity<Long> getCountOfComplaints() {
        try {
            LOGGER.info("Counting complaints");
            Long count = complaintService.getCountOfComplaints();
            return ResponseEntity.ok(count);
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
