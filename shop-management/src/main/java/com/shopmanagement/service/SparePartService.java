package com.shopmanagement.service;

import com.shopmanagement.dto.SparePartDto;
import java.util.List;

public interface SparePartService {
    SparePartDto addSparePart(SparePartDto dto);
    SparePartDto updateSparePart(Long id, SparePartDto dto);
    void deleteSparePart(Long id);
    SparePartDto getSparePartById(Long id);
    List<SparePartDto> getAllSpareParts();
}
