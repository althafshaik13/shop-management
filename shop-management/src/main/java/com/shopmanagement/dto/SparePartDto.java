package com.shopmanagement.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class SparePartDto {
    private Long id;

    @NotBlank(message = "Name is required")
    private String name;

    private String category;

    @NotNull(message = "Dealer Price is required")
    @Min(value = 0, message = "Price cannot be negative")
    private BigDecimal dealerPrice;

    @NotNull(message = "Customer Price is required")
    @Min(value = 0, message = "Price cannot be negative")
    private BigDecimal customerPrice;

    @NotNull(message = "Quantity is required")
    @Min(value = 0, message = "Quantity cannot be negative")
    private Integer quantity;

    private String imageUrl;

    private LocalDateTime createdAt;
}