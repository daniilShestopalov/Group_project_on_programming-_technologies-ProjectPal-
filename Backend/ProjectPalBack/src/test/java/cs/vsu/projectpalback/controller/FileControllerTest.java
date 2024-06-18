package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.service.FileService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.Objects;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
public class FileControllerTest {

    private MockMvc mockMvc;

    @Mock
    private FileService fileService;

    @InjectMocks
    private FileController fileController;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(fileController).build();
    }

    @Test
    void uploadAvatar_ValidFile_ReturnsOk() throws Exception {
        MockMultipartFile file = new MockMultipartFile("file", "avatar.jpg", MediaType.IMAGE_JPEG_VALUE, "some image data".getBytes());

        when(fileService.saveAvatar(any(), anyInt())).thenReturn("avatar.jpg");

        mockMvc.perform(multipart("/file/upload/avatar")
                        .file(file)
                        .param("id", "1")
                        .contentType(MediaType.MULTIPART_FORM_DATA))
                .andExpect(status().isOk())
                .andExpect(content().string("Avatar uploaded successfully"));
    }

    @Test
    void uploadAvatar_InvalidFile_ReturnsUnsupportedMediaType() throws Exception {
        MockMultipartFile file = new MockMultipartFile("file", "avatar.txt", MediaType.TEXT_PLAIN_VALUE, "some text data".getBytes());

        mockMvc.perform(multipart("/file/upload/avatar")
                        .file(file)
                        .param("id", "1")
                        .contentType(MediaType.MULTIPART_FORM_DATA))
                .andExpect(status().isUnsupportedMediaType())
                .andExpect(content().string("Only image files are allowed for avatars"));
    }

    @Test
    void uploadTaskFile_ValidFile_ReturnsOk() throws Exception {
        MockMultipartFile file = new MockMultipartFile("file", "task.pdf", MediaType.APPLICATION_PDF_VALUE, "pdf content".getBytes());

        when(fileService.saveTaskFile(any(), anyInt())).thenReturn("task.pdf");

        mockMvc.perform(multipart("/file/upload/task")
                        .file(file)
                        .param("id", "1")
                        .contentType(MediaType.MULTIPART_FORM_DATA))
                .andExpect(status().isOk())
                .andExpect(content().string("Task file uploaded successfully"));
    }


    @Test
    void deleteTaskFile_ExistingFile_ReturnsOk() throws Exception {
        String filename = "1_task.pdf";
        doNothing().when(fileService).deleteTaskFile(filename);

        mockMvc.perform(delete("/file/delete/task/1/task.pdf"))
                .andExpect(status().isOk())
                .andExpect(content().string("Task file deleted successfully"));
    }
}
