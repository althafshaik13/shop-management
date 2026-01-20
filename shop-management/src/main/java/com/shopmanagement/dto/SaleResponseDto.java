package com.shopmanagement.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class SaleResponseDto {
    private Long id;
    private LocalDateTime saleDate;
    private BigDecimal totalAmount;
    private List<SaleItemRequestDto> items;
}