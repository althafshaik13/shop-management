package com.shopmanagement.service;

import com.shopmanagement.dto.SaleRequestDto;
import com.shopmanagement.dto.SaleResponseDto;
import com.shopmanagement.entity.ProductType;

import java.time.LocalDate;
import java.util.List;

public interface SaleService {
    SaleResponseDto createSale(SaleRequestDto saleRequest);
    List<SaleResponseDto> getSalesByDateRange(LocalDate startDate, LocalDate endDate, ProductType productType);
}