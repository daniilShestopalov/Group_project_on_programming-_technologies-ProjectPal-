package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.dto.ComplaintDTO;
import cs.vsu.projectpalback.service.ComplaintService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.Arrays;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
public class ComplaintControllerTest {

    private MockMvc mockMvc;

    @Mock
    private ComplaintService complaintService;

    @InjectMocks
    private ComplaintController complaintController;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(complaintController).build();
    }

    @Test
    void getAllComplaints_AdminRole_ReturnsComplaintsList() throws Exception {
        // Mocking the service response
        List<ComplaintDTO> complaints = Arrays.asList(
                new ComplaintDTO(),
                new ComplaintDTO()
        );
        when(complaintService.getAllComplaints()).thenReturn(complaints);

        mockMvc.perform(get("/complaint")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.size()").value(complaints.size()));
    }

    @Test
    void getComplaintById_Authenticated_ReturnsComplaintDTO() throws Exception {
        // Mocking the service response
        ComplaintDTO complaint = new ComplaintDTO();
        complaint.setId(1);
        complaint.setComplaintSenderUserId(123);
        complaint.setComplainedAboutUserId(456);

        when(complaintService.getComplaintById(1)).thenReturn(complaint);

        mockMvc.perform(get("/complaint/{id}", 1)
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(complaint.getId()))
                .andExpect(jsonPath("$.complaintSenderUserId").value(complaint.getComplaintSenderUserId()))
                .andExpect(jsonPath("$.complainedAboutUserId").value(complaint.getComplainedAboutUserId()));
    }

    @Test
    void createComplaint_Authenticated_ReturnsCreatedComplaintDTO() throws Exception {
        // Mocking the service response
        ComplaintDTO newComplaint = new ComplaintDTO();
        newComplaint.setId(1);
        newComplaint.setComplaintSenderUserId(123);
        newComplaint.setComplainedAboutUserId(456);

        when(complaintService.createComplaint(any(ComplaintDTO.class))).thenReturn(newComplaint);

        mockMvc.perform(post("/complaint")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"complaintSenderUserId\": 123, \"complainedAboutUserId\": 456}")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(newComplaint.getId()))
                .andExpect(jsonPath("$.complaintSenderUserId").value(newComplaint.getComplaintSenderUserId()))
                .andExpect(jsonPath("$.complainedAboutUserId").value(newComplaint.getComplainedAboutUserId()));
    }

    @Test
    void deleteComplaint_AdminRole_ReturnsOk() throws Exception {
        // Mocking the service response
        when(complaintService.deleteComplaint(1)).thenReturn(true);

        mockMvc.perform(delete("/complaint/{id}", 1))
                .andExpect(status().isOk());
    }

    @Test
    void deleteComplaint_ComplaintNotFound_ReturnsNotFound() throws Exception {
        // Mocking the service response
        when(complaintService.deleteComplaint(1)).thenReturn(false);

        mockMvc.perform(delete("/complaint/{id}", 1))
                .andExpect(status().isNotFound());
    }
}
