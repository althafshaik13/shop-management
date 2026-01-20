package com.shopmanagement.service;

import org.springframework.web.multipart.MultipartFile;

public interface ImageStorageService {
    String storeFile(MultipartFile file, String folderType);
}