package cs.vsu.projectpalback.utils;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class FileUtils {

    public static final long MAX_IMAGE_FILE_SIZE = 2 * 1024 * 1024;

    public static boolean isImage(MultipartFile file) {
        String contentType = file.getContentType();
        return contentType != null && (contentType.equals("image/jpeg") || contentType.equals("image/png") || contentType.equals("image/gif"));
    }

    public static boolean isPdf(MultipartFile file) {
        String contentType = file.getContentType();
        return contentType != null && contentType.equals("application/pdf");
    }

    public static ResponseEntity<Resource> getFileResponse(byte[] fileData, String filename) {
        if (fileData != null) {
            ByteArrayResource resource = new ByteArrayResource(fileData);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                    .body(resource);
        } else {
            return ResponseEntity.status(404).body(null);
        }
    }
}
