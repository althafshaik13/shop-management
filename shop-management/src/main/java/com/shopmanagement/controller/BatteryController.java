package com.shopmanagement.controller;

import com.shopmanagement.dto.BatteryDto;
import com.shopmanagement.service.BatteryService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/batteries")
@RequiredArgsConstructor
public class BatteryController {

    private final BatteryService service;

    @PostMapping
    public ResponseEntity<BatteryDto> addBattery(@Valid @RequestBody BatteryDto dto) {
        return new ResponseEntity<>(service.addBattery(dto), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<BatteryDto> updateBattery(@PathVariable Long id, @Valid @RequestBody BatteryDto dto) {
        return ResponseEntity.ok(service.updateBattery(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBattery(@PathVariable Long id) {
        service.deleteBattery(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<BatteryDto> getBatteryById(@PathVariable Long id) {
        return ResponseEntity.ok(service.getBatteryById(id));
    }

    @GetMapping
    public ResponseEntity<List<BatteryDto>> getAllBatteries() {
        return ResponseEntity.ok(service.getAllBatteries());
    }
}