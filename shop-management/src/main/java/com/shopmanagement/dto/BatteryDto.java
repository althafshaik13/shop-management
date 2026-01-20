package com.shopmanagement.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class BatteryDto {
    private Long id;

    @NotBlank(message = "Name is required")
    private String name;

    @NotNull(message = "Model Number is required")
    private String modelNumber;

    @NotNull(message = "Capacity is required")
    private String capacity;

    @NotNull(message = "Voltage is required")
    private String voltage;

    @NotNull(message = "Warranty Period is required")
    private Long warrantyPeriodInMonths;

    @NotNull(message = "Dealer Price is required")
    private BigDecimal dealerPrice;

    @NotNull(message = "Customer Price is required")
    private BigDecimal customerPrice;

    @NotNull(message = "Quantity is required")
    @Min(value = 0, message = "Quantity cannot be negative")
    private Integer quantity;

    private String imageUrl;
}