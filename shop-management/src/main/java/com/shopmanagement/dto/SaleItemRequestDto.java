package com.shopmanagement.dto;

import com.shopmanagement.entity.ProductType;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class SaleItemRequestDto {
    @NotNull(message = "Product Type is required")
    private ProductType productType;

    @NotNull(message = "Product ID is required")
    private Long productId;

    @NotNull(message = "Quantity is required")
    @Min(value = 1, message = "Quantity must be at least 1")
    private Integer quantity;

    @NotNull(message = "Dealer Price is required")
    private BigDecimal dealerPrice;

    @NotNull(message = "Customer Price is required")
    private BigDecimal customerPrice;

}