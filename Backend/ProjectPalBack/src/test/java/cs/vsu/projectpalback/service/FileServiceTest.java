package cs.vsu.projectpalback.service;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@SpringBootTest
@ActiveProfiles("test")
@Rollback(true)
public class FileServiceTest {

    private static final String TEST_DIRECTORY = "test_files";
    private static final Logger LOGGER = LoggerFactory.getLogger(FileServiceTest.class);

    @Autowired
    private FileService fileService;

    @Before
    public void setUp() throws IOException {
        Files.createDirectories(Path.of(TEST_DIRECTORY));
    }

    @After
    public void tearDown() throws IOException {
        Files.walk(Path.of(TEST_DIRECTORY))
                .filter(Files::isRegularFile)
                .forEach(file -> {
                    try {
                        Files.deleteIfExists(file);
                    } catch (IOException e) {
                        LOGGER.error("Error deleting file: {}", file.toString(), e);
                    }
                });
    }

    @Test
    public void testSaveAndRetrieveAvatar() throws IOException {
        String filename = UUID.randomUUID().toString() + ".png";
        byte[] content = "Avatar content".getBytes();
        MockMultipartFile file = new MockMultipartFile("file", filename, "image/png", content);

        String savedFilename = fileService.saveAvatar(file);
        assertNotNull(savedFilename);

        byte[] retrievedContent = fileService.getAvatar(savedFilename);

        assertNotNull(retrievedContent);
        assertArrayEquals(content, retrievedContent);
    }

    @Test
    public void testSaveAndRetrieveTaskFile() throws IOException {
        String filename = UUID.randomUUID().toString() + ".txt";
        byte[] content = "Task file content".getBytes();
        MockMultipartFile file = new MockMultipartFile("file", filename, "text/plain", content);

        String savedFilename = fileService.saveTaskFile(file);
        assertNotNull(savedFilename);

        byte[] retrievedContent = fileService.getTaskFile(savedFilename);

        assertNotNull(retrievedContent);
        assertArrayEquals(content, retrievedContent);
    }

    @Test
    public void testSaveAndRetrieveProjectFile() throws IOException {
        String filename = UUID.randomUUID().toString() + ".pdf";
        byte[] content = "Project file content".getBytes();
        MockMultipartFile file = new MockMultipartFile("file", filename, "application/pdf", content);

        String savedFilename = fileService.saveProjectFile(file);
        assertNotNull(savedFilename);

        byte[] retrievedContent = fileService.getProjectFile(savedFilename);

        assertNotNull(retrievedContent);
        assertArrayEquals(content, retrievedContent);
    }

    @Test
    public void testSaveAndRetrieveTaskAnswerFile() throws IOException {
        String filename = UUID.randomUUID().toString() + ".docx";
        byte[] content = "Task answer file content".getBytes();
        MockMultipartFile file = new MockMultipartFile("file", filename, "application/vnd.openxmlformats-officedocument.wordprocessingml.document", content);

        String savedFilename = fileService.saveTaskAnswerFile(file);
        assertNotNull(savedFilename);

        byte[] retrievedContent = fileService.getTaskAnswerFile(savedFilename);

        assertNotNull(retrievedContent);
        assertArrayEquals(content, retrievedContent);
    }

    @Test
    public void testSaveAndRetrieveProjectAnswerFile() throws IOException {
        String filename = UUID.randomUUID().toString() + ".xlsx";
        byte[] content = "Project answer file content".getBytes();
        MockMultipartFile file = new MockMultipartFile("file", filename, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", content);

        String savedFilename = fileService.saveProjectAnswerFile(file);
        assertNotNull(savedFilename);

        byte[] retrievedContent = fileService.getProjectAnswerFile(savedFilename);

        assertNotNull(retrievedContent);
        assertArrayEquals(content, retrievedContent);
    }
}
