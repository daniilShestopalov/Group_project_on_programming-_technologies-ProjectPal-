package cs.vsu.projectpalback.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Objects;


@Service
public class FileService {

    private static final Logger LOGGER = LoggerFactory.getLogger(FileService.class);

    private final String avatarDirectory = "uploads/avatars";
    private final String taskFilesDirectory = "uploads/taskFiles";
    private final String projectFilesDirectory = "uploads/projectFiles";
    private final String taskAnswersDirectory = "uploads/taskAnswers";
    private final String projectAnswersDirectory = "uploads/projectAnswers";

    public FileService() {
        createDirectory(Path.of(avatarDirectory));
        createDirectory(Path.of(taskFilesDirectory));
        createDirectory(Path.of(projectFilesDirectory));
        createDirectory(Path.of(taskAnswersDirectory));
        createDirectory(Path.of(projectAnswersDirectory));
    }

    private void createDirectory(Path directory) {
        try {
            Files.createDirectories(directory);
            LOGGER.info("Created directory: {}", directory);
        } catch (IOException e) {
            LOGGER.error("Error creating directory: {}", directory, e);
            throw new RuntimeException("Error creating directory", e);
        }
    }

    public String saveAvatar(MultipartFile file) {
        return saveFile(file, Path.of(avatarDirectory));
    }

    public String saveTaskFile(MultipartFile file) {
        return saveFile(file, Path.of(taskFilesDirectory));
    }

    public String saveProjectFile(MultipartFile file) {
        return saveFile(file, Path.of(projectFilesDirectory));
    }

    public String saveTaskAnswerFile(MultipartFile file) {
        return saveFile(file, Path.of(taskAnswersDirectory));
    }

    public String saveProjectAnswerFile(MultipartFile file) {
        return saveFile(file, Path.of(projectAnswersDirectory));
    }

    private String saveFile(MultipartFile file, Path directory) {
        try {
            String filename = file.getOriginalFilename();
            Path filepath = directory.resolve(Objects.requireNonNull(filename));
            Files.write(filepath, file.getBytes());
            LOGGER.info("File saved: {}", filepath);
            return filename;
        } catch (IOException e) {
            LOGGER.error("Error saving file: {}", e.getMessage());
            throw new RuntimeException("Error saving file", e);
        }
    }

    public byte[] getFile(Path directory, String filename) {
        try {
            Path filepath = directory.resolve(filename);
            return Files.readAllBytes(filepath);
        } catch (IOException e) {
            LOGGER.error("Error reading file: {}", e.getMessage());
            throw new RuntimeException("Error reading file", e);
        }
    }

    public byte[] getAvatar(String filename) {
        return getFile(Path.of(avatarDirectory), filename);
    }

    public byte[] getTaskFile(String filename) {
        return getFile(Path.of(taskFilesDirectory), filename);
    }

    public byte[] getProjectFile(String filename) {
        return getFile(Path.of(projectFilesDirectory), filename);
    }

    public byte[] getTaskAnswerFile(String filename) {
        return getFile(Path.of(taskAnswersDirectory), filename);
    }

    public byte[] getProjectAnswerFile(String filename) {
        return getFile(Path.of(projectAnswersDirectory), filename);
    }

}
