package com.shopmanagement.service.impl;

import com.shopmanagement.dto.BatteryDto;
import com.shopmanagement.entity.InverterBattery;
import com.shopmanagement.exception.ResourceNotFoundException;
import com.shopmanagement.repository.BatteryRepository;
import com.shopmanagement.service.BatteryService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BatteryServiceImpl implements BatteryService {

    private final BatteryRepository repository;

    @Override
    public BatteryDto addBattery(BatteryDto dto) {
        InverterBattery entity = new InverterBattery();
        BeanUtils.copyProperties(dto, entity);
        return mapToDto(repository.save(entity));
    }

    @Override
    public BatteryDto updateBattery(Long id, BatteryDto dto) {
        InverterBattery entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Battery not found with id: " + id));

        entity.setName(dto.getName()!= null ? dto.getName() : entity.getName());
        entity.setModelNumber(dto.getModelNumber()!= null ? dto.getModelNumber() : entity.getModelNumber());
        entity.setCapacity(dto.getCapacity()!= null ? dto.getCapacity() : entity.getCapacity());
        entity.setDealerPrice(dto.getDealerPrice()!= null ? dto.getDealerPrice() : entity.getDealerPrice());
        entity.setCustomerPrice(dto.getCustomerPrice()!= null ? dto.getCustomerPrice() : entity.getCustomerPrice());
        entity.setVoltage(dto.getVoltage()!= null ? dto.getVoltage() : entity.getVoltage());
        entity.setWarrantyPeriodInMonths(dto.getWarrantyPeriodInMonths()!= null ? dto.getWarrantyPeriodInMonths() : entity.getWarrantyPeriodInMonths());
        entity.setQuantity(dto.getQuantity()!= null ? dto.getQuantity() : entity.getQuantity());
        entity.setImageUrl(dto.getImageUrl()!= null ? dto.getImageUrl() : entity.getImageUrl());

        return mapToDto(repository.save(entity));
    }

    @Override
    public void deleteBattery(Long id) {
        if (!repository.existsById(id)) {
            throw new ResourceNotFoundException("Battery not found with id: " + id);
        }
        repository.deleteById(id);
    }

    @Override
    public BatteryDto getBatteryById(Long id) {
        InverterBattery entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Battery not found with id: " + id));
        return mapToDto(entity);
    }

    @Override
    public List<BatteryDto> getAllBatteries() {
        return repository.findAll().stream().map(this::mapToDto).collect(Collectors.toList());
    }

    private BatteryDto mapToDto(InverterBattery entity) {
        BatteryDto dto = new BatteryDto();
        BeanUtils.copyProperties(entity, dto);
        return dto;
    }
}