package com.shopmanagement.controller;

import com.shopmanagement.dto.SparePartDto;
import com.shopmanagement.service.SparePartService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/spare-parts")
@RequiredArgsConstructor
public class SparePartController {

    private final SparePartService service;

    @PostMapping
    public ResponseEntity<SparePartDto> addSparePart(@Valid @RequestBody SparePartDto dto) {
        return new ResponseEntity<>(service.addSparePart(dto), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<SparePartDto> updateSparePart(@PathVariable Long id, @Valid @RequestBody SparePartDto dto) {
        return ResponseEntity.ok(service.updateSparePart(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSparePart(@PathVariable Long id) {
        service.deleteSparePart(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<SparePartDto> getSparePartById(@PathVariable Long id) {
        return ResponseEntity.ok(service.getSparePartById(id));
    }

    @GetMapping
    public ResponseEntity<List<SparePartDto>> getAllSpareParts() {
        return ResponseEntity.ok(service.getAllSpareParts());
    }
}