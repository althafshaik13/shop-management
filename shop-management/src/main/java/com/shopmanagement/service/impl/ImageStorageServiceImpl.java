package com.shopmanagement.service.impl;

import com.shopmanagement.exception.InvalidImageException;
import com.shopmanagement.service.ImageStorageService;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
public class ImageStorageServiceImpl implements ImageStorageService {

    @Value("${app.file.storage-dir}")
    private String uploadDir;

    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList("jpg", "jpeg", "png");
    private static final List<String> ALLOWED_MIME_TYPES = Arrays.asList("image/jpeg", "image/png");

    @PostConstruct
    public void init() {
        try {
            Files.createDirectories(Paths.get(uploadDir));
            Files.createDirectories(Paths.get(uploadDir + "/spare-parts"));
            Files.createDirectories(Paths.get(uploadDir + "/batteries"));
        } catch (IOException e) {
            throw new RuntimeException("Could not initialize storage location", e);
        }
    }

    @Override
    public String storeFile(MultipartFile file, String folderType) {
        if (file.isEmpty()) {
            throw new InvalidImageException("Failed to store empty file.");
        }

        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_MIME_TYPES.contains(contentType)) {
            throw new InvalidImageException("Invalid file type. Only JPG, JPEG, and PNG are allowed.");
        }

        String originalFilename = file.getOriginalFilename();
        String fileExtension = getFileExtension(originalFilename);

        if (!ALLOWED_EXTENSIONS.contains(fileExtension.toLowerCase())) {
            throw new InvalidImageException("Invalid file extension. Only JPG, JPEG, and PNG are allowed.");
        }

        String subFolder = validateAndGetSubFolder(folderType);

        String newFilename = UUID.randomUUID().toString() + "." + fileExtension;

        try {
            Path targetLocation = Paths.get(uploadDir).resolve(subFolder).resolve(newFilename);

            try (InputStream inputStream = file.getInputStream()) {
                Files.copy(inputStream, targetLocation, StandardCopyOption.REPLACE_EXISTING);
            }

            return "/uploads/" + subFolder + "/" + newFilename;

        } catch (IOException e) {
            throw new RuntimeException("Failed to store file " + newFilename, e);
        }
    }

    private String validateAndGetSubFolder(String folderType) {
        if ("SPARE_PART".equalsIgnoreCase(folderType)) {
            return "spare-parts";
        } else if ("BATTERY".equalsIgnoreCase(folderType)) {
            return "batteries";
        } else {
            throw new InvalidImageException("Invalid folder type. Accepted values: SPARE_PART, BATTERY");
        }
    }

    private String getFileExtension(String filename) {
        if (filename == null || filename.lastIndexOf(".") == -1) {
            return "";
        }
        return filename.substring(filename.lastIndexOf(".") + 1);
    }
}