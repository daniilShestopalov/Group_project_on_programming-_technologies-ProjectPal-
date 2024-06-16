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

    public String saveAvatar(MultipartFile file, int id) {
        return saveFile(file, Path.of(avatarDirectory), id);
    }

    public String saveTaskFile(MultipartFile file, int id) {
        return saveFile(file, Path.of(taskFilesDirectory), id);
    }

    public String saveProjectFile(MultipartFile file, int id) {
        return saveFile(file, Path.of(projectFilesDirectory), id);
    }

    public String saveTaskAnswerFile(MultipartFile file, int id) {
        return saveFile(file, Path.of(taskAnswersDirectory), id);
    }

    public String saveProjectAnswerFile(MultipartFile file, int id) {
        return saveFile(file, Path.of(projectAnswersDirectory), id);
    }

    private String saveFile(MultipartFile file, Path directory, int id) {
        try {
            String originalFilename = file.getOriginalFilename();
            String filename = id + "_" + Objects.requireNonNull(originalFilename);
            Path filepath = directory.resolve(filename);
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

    public void deleteAvatar(String filename) {
        deleteFile(Path.of(avatarDirectory), filename);
    }

    public void deleteTaskFile(String filename) {
        deleteFile(Path.of(taskFilesDirectory), filename);
    }

    public void deleteProjectFile(String filename) {
        deleteFile(Path.of(projectFilesDirectory), filename);
    }

    public void deleteTaskAnswerFile(String filename) {
        deleteFile(Path.of(taskAnswersDirectory), filename);
    }

    public void deleteProjectAnswerFile(String filename) {
        deleteFile(Path.of(projectAnswersDirectory), filename);
    }

    private void deleteFile(Path directory, String filename) {
        try {
            Path filepath = directory.resolve(filename);
            Files.delete(filepath);
            LOGGER.info("File deleted: {}", filepath);
        } catch (IOException e) {
            LOGGER.error("Error deleting file: {}", e.getMessage());
            throw new RuntimeException("Error deleting file", e);
        }
    }

}
