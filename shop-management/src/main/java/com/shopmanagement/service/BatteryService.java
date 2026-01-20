package com.shopmanagement.service;

import com.shopmanagement.dto.BatteryDto;
import java.util.List;

public interface BatteryService {
    BatteryDto addBattery(BatteryDto dto);
    BatteryDto updateBattery(Long id, BatteryDto dto);
    void deleteBattery(Long id);
    BatteryDto getBatteryById(Long id);
    List<BatteryDto> getAllBatteries();
}