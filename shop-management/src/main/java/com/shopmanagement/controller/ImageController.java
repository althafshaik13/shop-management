package com.shopmanagement.controller;

import com.shopmanagement.service.ImageStorageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/images")
@RequiredArgsConstructor
public class ImageController {

    private final ImageStorageService imageStorageService;

    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, String>> uploadImage(
            @RequestParam("file") MultipartFile file,
            @RequestParam("folderType") String folderType) {

        String imageUrl = imageStorageService.storeFile(file, folderType);

        Map<String, String> response = new HashMap<>();
        response.put("imageUrl", imageUrl);

        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }
}