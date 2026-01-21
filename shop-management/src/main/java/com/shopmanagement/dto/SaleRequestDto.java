package com.shopmanagement.dto;

import com.shopmanagement.entity.PaymentStatus;
import com.shopmanagement.entity.PaymentType;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.util.List;

@Data
public class SaleRequestDto {
    @NotEmpty(message = "Sale items cannot be empty")
    @Valid
    private List<SaleItemRequestDto> items;

    @NotNull(message = "Payment Type is required")
    private PaymentType paymentType;

    @NotNull(message = "Payment Status is required")
    private PaymentStatus paymentStatus;

    private String customerName;

    private String customerPhone;

    private String customerAddress;
}