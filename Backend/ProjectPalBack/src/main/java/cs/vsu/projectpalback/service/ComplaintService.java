package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.ComplaintDTO;
import cs.vsu.projectpalback.mapper.ComplaintMapper;
import cs.vsu.projectpalback.model.Complaint;
import cs.vsu.projectpalback.repository.ComplaintRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class ComplaintService {

    private final ComplaintRepository complaintRepository;

    private final ComplaintMapper complaintMapper;

    public List<ComplaintDTO> getAllComplaints() {
        return complaintMapper.toDtoList(complaintRepository.findAll());
    }

    public ComplaintDTO getComplaintById(int id) {
        Optional<Complaint> complaint = complaintRepository.findById(id);
        return complaint.map(complaintMapper::toDto).orElse(null);
    }

    public void deleteComplaint(int id) {
        complaintRepository.deleteById(id);
    }

    public void createComplaint(ComplaintDTO complaintDTO) {
        Complaint complaint = complaintMapper.toEntity(complaintDTO);
        complaintRepository.save(complaint);
    }
}
