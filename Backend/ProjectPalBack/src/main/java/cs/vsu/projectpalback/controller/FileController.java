package cs.vsu.projectpalback.controller;

import cs.vsu.projectpalback.service.FileService;
import cs.vsu.projectpalback.utils.FileUtils;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/file")
@Tag(name = "FileController", description = "Authorized users only.")
@AllArgsConstructor
public class FileController {

    private static final Logger LOGGER = LoggerFactory.getLogger(FileController.class);

    private final FileService fileService;

    @Operation(summary = "Upload avatar image", description = "Upload an avatar image file. Only image files are allowed.")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/upload/avatar")
    public ResponseEntity<String> uploadAvatar(@RequestParam("file") MultipartFile file, @RequestParam("id") int id) {
        if (!FileUtils.isImage(file)) {
            LOGGER.warn("Upload attempt with non-image file for avatar");
            return ResponseEntity.status(415).body("Only image files are allowed for avatars");
        }
        if (file.getSize() > FileUtils.MAX_IMAGE_FILE_SIZE) {
            LOGGER.warn("Upload attempt with file larger than allowed size for avatar");
            return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE).body("File size must be less than 2MB");
        }
        try {
            String filename = fileService.saveAvatar(file, id);
            LOGGER.info("Avatar uploaded successfully: {}", filename);
            return ResponseEntity.ok("Avatar uploaded successfully");
        } catch (RuntimeException e) {
            LOGGER.error("Error uploading avatar", e);
            return ResponseEntity.status(500).body("Error uploading avatar");
        }
    }

    @Operation(summary = "Upload task file", description = "Upload a task file. Only PDF files are allowed.")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/upload/task")
    public ResponseEntity<String> uploadTaskFile(@RequestParam("file") MultipartFile file, @RequestParam("id") int id) {
        if (!FileUtils.isPdf(file)) {
            LOGGER.warn("Upload attempt with non-PDF file for task");
            return ResponseEntity.status(415).body("Only PDF files are allowed for tasks");
        }
        try {
            String filename = fileService.saveTaskFile(file, id);
            LOGGER.info("Task file uploaded successfully: {}", filename);
            return ResponseEntity.ok("Task file uploaded successfully");
        } catch (RuntimeException e) {
            LOGGER.error("Error uploading task file", e);
            return ResponseEntity.status(500).body("Error uploading task file");
        }
    }

    @Operation(summary = "Upload project file", description = "Upload a project file. Only PDF files are allowed.")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/upload/project")
    public ResponseEntity<String> uploadProjectFile(@RequestParam("file") MultipartFile file, @RequestParam("id") int id) {
        if (!FileUtils.isPdf(file)) {
            LOGGER.warn("Upload attempt with non-PDF file for project");
            return ResponseEntity.status(415).body("Only PDF files are allowed for projects");
        }
        try {
            String filename = fileService.saveProjectFile(file, id);
            LOGGER.info("Project file uploaded successfully: {}", filename);
            return ResponseEntity.ok("Project file uploaded successfully");
        } catch (RuntimeException e) {
            LOGGER.error("Error uploading project file", e);
            return ResponseEntity.status(500).body("Error uploading project file");
        }
    }

    @Operation(summary = "Upload task answer file", description = "Upload a task answer file. Only PDF files are allowed.")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/upload/task-answer")
    public ResponseEntity<String> uploadTaskAnswerFile(@RequestParam("file") MultipartFile file, @RequestParam("id") int id) {
        if (!FileUtils.isPdf(file)) {
            LOGGER.warn("Upload attempt with non-PDF file for task answer");
            return ResponseEntity.status(415).body("Only PDF files are allowed for task answers");
        }
        try {
            String filename = fileService.saveTaskAnswerFile(file, id);
            LOGGER.info("Task answer file uploaded successfully: {}", filename);
            return ResponseEntity.ok("Task answer file uploaded successfully");
        } catch (RuntimeException e) {
            LOGGER.error("Error uploading task answer file", e);
            return ResponseEntity.status(500).body("Error uploading task answer file");
        }
    }

    @Operation(summary = "Upload project answer file", description = "Upload a project answer file. Only PDF files are allowed.")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/upload/project-answer")
    public ResponseEntity<String> uploadProjectAnswerFile(@RequestParam("file") MultipartFile file, @RequestParam("id") int id) {
        if (!FileUtils.isPdf(file)) {
            LOGGER.warn("Upload attempt with non-PDF file for project answer");
            return ResponseEntity.status(415).body("Only PDF files are allowed for project answers");
        }
        try {
            String filename = fileService.saveProjectAnswerFile(file, id);
            LOGGER.info("Project answer file uploaded successfully: {}", filename);
            return ResponseEntity.ok("Project answer file uploaded successfully");
        } catch (RuntimeException e) {
            LOGGER.error("Error uploading project answer file", e);
            return ResponseEntity.status(500).body("Error uploading project answer file");
        }
    }

    @Operation(summary = "Download avatar image", description = "Download an avatar image file.")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/download/avatar/{id}/{filename}")
    public ResponseEntity<Resource> getAvatar(@PathVariable int id, @PathVariable String filename) {
        String fullFilename = id + "_" + filename;
        LOGGER.info("Downloading avatar image: {}", fullFilename);
        return FileUtils.getFileResponse(fileService.getAvatar(fullFilename), filename);
    }

    @Operation(summary = "Download task file", description = "Download a task file.")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/download/task/{id}/{filename}")
    public ResponseEntity<Resource> getTaskFile(@PathVariable int id, @PathVariable String filename) {
        String fullFilename = id + "_" + filename;
        LOGGER.info("Downloading task file: {}", fullFilename);
        return FileUtils.getFileResponse(fileService.getTaskFile(fullFilename), filename);
    }

    @Operation(summary = "Download project file", description = "Download a project file.")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/download/project/{id}/{filename}")
    public ResponseEntity<Resource> getProjectFile(@PathVariable int id, @PathVariable String filename) {
        String fullFilename = id + "_" + filename;
        LOGGER.info("Downloading project file: {}", fullFilename);
        return FileUtils.getFileResponse(fileService.getProjectFile(fullFilename), filename);
    }

    @Operation(summary = "Download task answer file", description = "Download a task answer file.")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/download/task-answer/{id}/{filename}")
    public ResponseEntity<Resource> getTaskAnswerFile(@PathVariable int id, @PathVariable String filename) {
        String fullFilename = id + "_" + filename;
        LOGGER.info("Downloading task answer file: {}", fullFilename);
        return FileUtils.getFileResponse(fileService.getTaskAnswerFile(fullFilename), filename);
    }

    @Operation(summary = "Download project answer file", description = "Download a project answer file.")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/download/project-answer/{id}/{filename}")
    public ResponseEntity<Resource> getProjectAnswerFile(@PathVariable int id, @PathVariable String filename) {
        String fullFilename = id + "_" + filename;
        LOGGER.info("Downloading project answer file: {}", fullFilename);
        return FileUtils.getFileResponse(fileService.getProjectAnswerFile(fullFilename), filename);
    }

    @Operation(summary = "Delete avatar image", description = "Delete an avatar image file.")
    @PreAuthorize("isAuthenticated()")
    @DeleteMapping("/delete/avatar/{id}/{filename}")
    public ResponseEntity<String> deleteAvatar(@PathVariable int id, @PathVariable String filename) {
        String fullFilename = id + "_" + filename;
        try {
            fileService.deleteAvatar(fullFilename);
            LOGGER.info("Avatar deleted successfully: {}", fullFilename);
            return ResponseEntity.ok("Avatar deleted successfully");
        } catch (RuntimeException e) {
            LOGGER.error("Error deleting avatar", e);
            return ResponseEntity.status(500).body("Error deleting avatar");
        }
    }

    @Operation(summary = "Delete task file", description = "Delete a task file.")
    @PreAuthorize("isAuthenticated()")
    @DeleteMapping("/delete/task/{id}/{filename}")
    public ResponseEntity<String> deleteTaskFile(@PathVariable int id, @PathVariable String filename) {
        String fullFilename = id + "_" + filename;
        try {
            fileService.deleteTaskFile(fullFilename);
            LOGGER.info("Task file deleted successfully: {}", fullFilename);
            return ResponseEntity.ok("Task file deleted successfully");
        } catch (RuntimeException e) {
            LOGGER.error("Error deleting task file", e);
            return ResponseEntity.status(500).body("Error deleting task file");
        }
    }

    @Operation(summary = "Delete project file", description = "Delete a project file.")
    @PreAuthorize("isAuthenticated()")
    @DeleteMapping("/delete/project/{id}/{filename}")
    public ResponseEntity<String> deleteProjectFile(@PathVariable int id, @PathVariable String filename) {
        String fullFilename = id + "_" + filename;
        try {
            fileService.deleteProjectFile(fullFilename);
            LOGGER.info("Project file deleted successfully: {}", fullFilename);
            return ResponseEntity.ok("Project file deleted successfully");
        } catch (RuntimeException e) {
            LOGGER.error("Error deleting project file", e);
            return ResponseEntity.status(500).body("Error deleting project file");
        }
    }

    @Operation(summary = "Delete task answer file", description = "Delete a task answer file.")
    @PreAuthorize("isAuthenticated()")
    @DeleteMapping("/delete/task-answer/{id}/{filename}")
    public ResponseEntity<String> deleteTaskAnswerFile(@PathVariable int id, @PathVariable String filename) {
        String fullFilename = id + "_" + filename;
        try {
            fileService.deleteTaskAnswerFile(fullFilename);
            LOGGER.info("Task answer file deleted successfully: {}", fullFilename);
            return ResponseEntity.ok("Task answer file deleted successfully");
        } catch (RuntimeException e) {
            LOGGER.error("Error deleting task answer file", e);
            return ResponseEntity.status(500).body("Error deleting task answer file");
        }
    }

    @Operation(summary = "Delete project answer file", description = "Delete a project answer file.")
    @PreAuthorize("isAuthenticated()")
    @DeleteMapping("/delete/project-answer/{id}/{filename}")
    public ResponseEntity<String> deleteProjectAnswerFile(@PathVariable int id, @PathVariable String filename) {
        String fullFilename = id + "_" + filename;
        try {
            fileService.deleteProjectAnswerFile(fullFilename);
            LOGGER.info("Project answer file deleted successfully: {}", fullFilename);
            return ResponseEntity.ok("Project answer file deleted successfully");
        } catch (RuntimeException e) {
            LOGGER.error("Error deleting project answer file", e);
            return ResponseEntity.status(500).body("Error deleting project answer file");
        }
    }
}
