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
    public ResponseEntity<String> uploadAvatar(@RequestParam("file") MultipartFile file) {
        if (!FileUtils.isImage(file)) {
            return ResponseEntity.status(415).body("Only image files are allowed for avatars");
        }
        if (file.getSize() > FileUtils.MAX_IMAGE_FILE_SIZE) {
            return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE).body("File size must be less than 2MB");
        }
        try {
            String filename = fileService.saveAvatar(file);
            return ResponseEntity.ok(filename);
        } catch (RuntimeException e) {
            LOGGER.error("Error uploading avatar", e);
            return ResponseEntity.status(500).body("Error uploading avatar");
        }
    }

    @Operation(summary = "Upload task file", description = "Upload a task file. Only PDF files are allowed.")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/upload/task")
    public ResponseEntity<String> uploadTaskFile(@RequestParam("file") MultipartFile file) {
        if (!FileUtils.isPdf(file)) {
            return ResponseEntity.status(415).body("Only PDF files are allowed for tasks");
        }
        try {
            String filename = fileService.saveTaskFile(file);
            return ResponseEntity.ok(filename);
        } catch (RuntimeException e) {
            LOGGER.error("Error uploading task file", e);
            return ResponseEntity.status(500).body("Error uploading task file");
        }
    }

    @Operation(summary = "Upload project file", description = "Upload a project file. Only PDF files are allowed.")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/upload/project")
    public ResponseEntity<String> uploadProjectFile(@RequestParam("file") MultipartFile file) {
        if (!FileUtils.isPdf(file)) {
            return ResponseEntity.status(415).body("Only PDF files are allowed for projects");
        }
        try {
            String filename = fileService.saveProjectFile(file);
            return ResponseEntity.ok(filename);
        } catch (RuntimeException e) {
            LOGGER.error("Error uploading project file", e);
            return ResponseEntity.status(500).body("Error uploading project file");
        }
    }

    @Operation(summary = "Upload task answer file", description = "Upload a task answer file. Only PDF files are allowed.")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/upload/task-answer")
    public ResponseEntity<String> uploadTaskAnswerFile(@RequestParam("file") MultipartFile file) {
        if (!FileUtils.isPdf(file)) {
            return ResponseEntity.status(415).body("Only PDF files are allowed for task answers");
        }
        try {
            String filename = fileService.saveTaskAnswerFile(file);
            return ResponseEntity.ok(filename);
        } catch (RuntimeException e) {
            LOGGER.error("Error uploading task answer file", e);
            return ResponseEntity.status(500).body("Error uploading task answer file");
        }
    }

    @Operation(summary = "Upload project answer file", description = "Upload a project answer file. Only PDF files are allowed.")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/upload/project-answer")
    public ResponseEntity<String> uploadProjectAnswerFile(@RequestParam("file") MultipartFile file) {
        if (!FileUtils.isPdf(file)) {
            return ResponseEntity.status(415).body("Only PDF files are allowed for project answers");
        }
        try {
            String filename = fileService.saveProjectAnswerFile(file);
            return ResponseEntity.ok(filename);
        } catch (RuntimeException e) {
            LOGGER.error("Error uploading project answer file", e);
            return ResponseEntity.status(500).body("Error uploading project answer file");
        }
    }

    @Operation(summary = "Download avatar image", description = "Download an avatar image file.")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/download/avatar/{filename}")
    public ResponseEntity<Resource> getAvatar(@PathVariable String filename) {
        return FileUtils.getFileResponse(fileService.getAvatar(filename), filename);
    }

    @Operation(summary = "Download task file", description = "Download a task file.")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/download/task/{filename}")
    public ResponseEntity<Resource> getTaskFile(@PathVariable String filename) {
        return FileUtils.getFileResponse(fileService.getTaskFile(filename), filename);
    }

    @Operation(summary = "Download project file", description = "Download a project file.")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/download/project/{filename}")
    public ResponseEntity<Resource> getProjectFile(@PathVariable String filename) {
        return FileUtils.getFileResponse(fileService.getProjectFile(filename), filename);
    }

    @Operation(summary = "Download task answer file", description = "Download a task answer file.")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/download/task-answer/{filename}")
    public ResponseEntity<Resource> getTaskAnswerFile(@PathVariable String filename) {
        return FileUtils.getFileResponse(fileService.getTaskAnswerFile(filename), filename);
    }

    @Operation(summary = "Download project answer file", description = "Download a project answer file.")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/download/project-answer/{filename}")
    public ResponseEntity<Resource> getProjectAnswerFile(@PathVariable String filename) {
        return FileUtils.getFileResponse(fileService.getProjectAnswerFile(filename), filename);
    }
}
