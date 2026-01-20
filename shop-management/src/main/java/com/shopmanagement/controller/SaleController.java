package com.shopmanagement.controller;

import com.shopmanagement.dto.SaleRequestDto;
import com.shopmanagement.dto.SaleResponseDto;
import com.shopmanagement.entity.ProductType;
import com.shopmanagement.service.SaleService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/sales")
@RequiredArgsConstructor
public class SaleController {

    private final SaleService service;

    @PostMapping
    public ResponseEntity<SaleResponseDto> createSale(@Valid @RequestBody SaleRequestDto request) {
        return new ResponseEntity<>(service.createSale(request), HttpStatus.CREATED);
    }

    @GetMapping()
    public ResponseEntity<List<SaleResponseDto>> getSalesByDateRange(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) ProductType productType) {
        return ResponseEntity.ok(service.getSalesByDateRange(startDate, endDate, productType));
    }
}