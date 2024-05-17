package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.ComplaintDTO;
import cs.vsu.projectpalback.mapper.ComplaintMapper;
import cs.vsu.projectpalback.model.Complaint;
import cs.vsu.projectpalback.repository.ComplaintRepository;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class ComplaintService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ComplaintService.class);

    private final ComplaintRepository complaintRepository;

    private final ComplaintMapper complaintMapper;

    public List<ComplaintDTO> getAllComplaints() {
        LOGGER.info("Fetching all complaints");
        return complaintMapper.toDtoList(complaintRepository.findAll());
    }

    public ComplaintDTO getComplaintById(int id) {
        LOGGER.info("Fetching group with ID: {}", id);
        Optional<Complaint> complaintOptional = complaintRepository.findById(id);
        if (complaintOptional.isPresent()) {
            LOGGER.info("Complaint found with ID: {}", id);
            return complaintMapper.toDto(complaintOptional.get());
        } else {
            LOGGER.warn("No complaint found with ID: {}", id);
            return null;
        }
    }

    public boolean deleteComplaint(int id) {
        try {
            LOGGER.info("Deleting complaint with ID: {}", id);
            Optional<Complaint> existingComplaint = complaintRepository.findById(id);
            if (existingComplaint.isPresent()) {
                complaintRepository.deleteById(id);
                LOGGER.info("Complaint deleted with ID: {}", id);
                return true;
            } else {
                LOGGER.warn("No complaint found with ID for delete: {}", id);
                return false;
            }
        } catch (Exception e) {
            LOGGER.error("Error deleting complaint with ID: {}", id, e);
            throw new RuntimeException("Error deleting complaint", e);
        }
    }

    public ComplaintDTO createComplaint(ComplaintDTO complaintDTO) {
        try {
            Complaint complaint = complaintRepository.save(complaintMapper.toEntity(complaintDTO));
            LOGGER.info("Complaint created with ID: {}", complaint.getId());
            return complaintMapper.toDto(complaint);
        } catch (Exception e) {
            LOGGER.error("Error creating complaint: {}", e.getMessage(), e);
            throw new RuntimeException("Error creating complaint", e);
        }
    }

}
