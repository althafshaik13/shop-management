package com.shopmanagement.repository;

import com.shopmanagement.entity.InverterBattery;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BatteryRepository extends JpaRepository<InverterBattery, Long> {
}