package com.shopmanagement.service.impl;

import com.shopmanagement.dto.SparePartDto;
import com.shopmanagement.entity.SparePart;
import com.shopmanagement.exception.ResourceNotFoundException;
import com.shopmanagement.repository.SparePartRepository;
import com.shopmanagement.service.SparePartService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SparePartServiceImpl implements SparePartService {

    private final SparePartRepository repository;

    @Override
    public SparePartDto addSparePart(SparePartDto dto) {
        SparePart entity = new SparePart();
        BeanUtils.copyProperties(dto, entity);
        SparePart saved = repository.save(entity);
        return mapToDto(saved);
    }

    @Override
    public SparePartDto updateSparePart(Long id, SparePartDto dto) {
        SparePart entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Spare Part not found with id: " + id));

        entity.setName(dto.getName());
        entity.setCategory(dto.getCategory());
        entity.setDealerPrice(dto.getDealerPrice());
        entity.setCustomerPrice(dto.getCustomerPrice());
        entity.setQuantity(dto.getQuantity());
        entity.setImageUrl(dto.getImageUrl());

        return mapToDto(repository.save(entity));
    }

    @Override
    public void deleteSparePart(Long id) {
        if (!repository.existsById(id)) {
            throw new ResourceNotFoundException("Spare Part not found with id: " + id);
        }
        repository.deleteById(id);
    }

    @Override
    public SparePartDto getSparePartById(Long id) {
        SparePart entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Spare Part not found with id: " + id));
        return mapToDto(entity);
    }

    @Override
    public List<SparePartDto> getAllSpareParts() {
        return repository.findAll().stream().map(this::mapToDto).collect(Collectors.toList());
    }

    private SparePartDto mapToDto(SparePart entity) {
        SparePartDto dto = new SparePartDto();
        BeanUtils.copyProperties(entity, dto);
        return dto;
    }
}