package cs.vsu.projectpalback.service;

import cs.vsu.projectpalback.dto.ComplaintDTO;
import cs.vsu.projectpalback.mapper.ComplaintMapper;
import cs.vsu.projectpalback.model.Complaint;
import cs.vsu.projectpalback.repository.ComplaintRepository;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@SpringBootTest
@ActiveProfiles("test")
@Rollback(true)
public class ComplaintServiceTest {

    @Autowired
    private ComplaintRepository complaintRepository;

    @Autowired
    private ComplaintMapper complaintMapper;

    @Autowired
    private ComplaintService complaintService;

    @Before
    public void setUp() {
        complaintRepository.deleteAll();
    }

    @Test
    public void testGetAllComplaints() {
        Complaint complaint1 = new Complaint();
        complaint1.setId(1);
        Complaint complaint2 = new Complaint();
        complaint1.setId(2);
        complaintRepository.saveAll(Arrays.asList(complaint1, complaint2));

        List<ComplaintDTO> result = complaintService.getAllComplaints();

        assertEquals(2, result.size());
        assertEquals(1, result.get(0).getId());
        assertEquals(2, result.get(1).getId());
    }

    @Test
    public void testGetComplaintById_ComplaintExists() {
        Complaint complaint = new Complaint();
        complaint.setId(1);

        complaintRepository.save(complaint);

        ComplaintDTO result = complaintService.getComplaintById(1);

        assertNotNull(result);
        assertEquals(1, result.getId());
    }

    @Test
    public void testGetComplaintById_ComplaintNotExists() {
        ComplaintDTO result = complaintService.getComplaintById(1);

        assertNull(result);
    }

    @Test
    public void testDeleteComplaint_ComplaintExists() {
        Complaint complaint = new Complaint();
        complaint.setId(1);

        complaintRepository.save(complaint);

        boolean result = complaintService.deleteComplaint(1);

        assertTrue(result);
        assertFalse(complaintRepository.findById(1).isPresent());
    }

    @Test
    public void testDeleteComplaint_ComplaintNotExists() {
        boolean result = complaintService.deleteComplaint(1);

        assertFalse(result);
    }

    @Test
    public void testCreateComplaint() {
        ComplaintDTO complaintDTO = new ComplaintDTO();
        complaintDTO.setId(1);

        ComplaintDTO result = complaintService.createComplaint(complaintDTO);

        assertNotNull(result);
        assertEquals(1, result.getId());
    }
}
