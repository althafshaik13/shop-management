package com.shopmanagement.service.impl;

import com.shopmanagement.dto.SaleItemRequestDto;
import com.shopmanagement.dto.SaleRequestDto;
import com.shopmanagement.dto.SaleResponseDto;
import com.shopmanagement.entity.*;
import com.shopmanagement.exception.InsufficientStockException;
import com.shopmanagement.exception.ResourceNotFoundException;
import com.shopmanagement.repository.BatteryRepository;
import com.shopmanagement.repository.SaleRepository;
import com.shopmanagement.repository.SparePartRepository;
import com.shopmanagement.service.SaleService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SaleServiceImpl implements SaleService {

    private final SaleRepository saleRepository;
    private final SparePartRepository sparePartRepository;
    private final BatteryRepository batteryRepository;

    @Override
    @Transactional
    public SaleResponseDto createSale(SaleRequestDto saleRequest) {
        Sale sale = new Sale();
        sale.setSaleDate(LocalDateTime.now());

        BigDecimal totalAmount = BigDecimal.ZERO;

        for (SaleItemRequestDto itemDto : saleRequest.getItems()) {

            if (itemDto.getProductType() == ProductType.SPARE_PART) {
                processSparePartSale(itemDto);
            } else if (itemDto.getProductType() == ProductType.BATTERY) {
                processBatterySale(itemDto);
            }

            SaleItem saleItem = new SaleItem();
            BeanUtils.copyProperties(itemDto, saleItem);
            saleItem.setDealerPrice(itemDto.getDealerPrice());
            saleItem.setCustomerPrice(itemDto.getCustomerPrice());

            // Calculate line total: customerPrice * qty
            BigDecimal lineTotal = itemDto.getCustomerPrice().multiply(BigDecimal.valueOf(itemDto.getQuantity()));
            totalAmount = totalAmount.add(lineTotal);


            sale.addSaleItem(saleItem);
        }

        sale.setPaymentType(saleRequest.getPaymentType());
        sale.setPaymentStatus(saleRequest.getPaymentStatus());
        sale.setCustomerName(saleRequest.getCustomerName());
        sale.setCustomerPhone(saleRequest.getCustomerPhone());
        sale.setCustomerAddress(saleRequest.getCustomerAddress());
        sale.setTotalAmount(totalAmount);
        Sale savedSale = saleRepository.save(sale);

        return mapToResponseDto(savedSale, null);
    }

    private void processSparePartSale(SaleItemRequestDto itemDto) {
        SparePart part = sparePartRepository.findById(itemDto.getProductId())
                .orElseThrow(() -> new ResourceNotFoundException("Spare Part not found: " + itemDto.getProductId()));

        if (part.getQuantity() < itemDto.getQuantity()) {
            throw new InsufficientStockException("Insufficient stock for Spare Part: " + part.getName());
        }

        part.setQuantity(part.getQuantity() - itemDto.getQuantity());
        sparePartRepository.save(part);
    }

    private void processBatterySale(SaleItemRequestDto itemDto) {
        InverterBattery battery = batteryRepository.findById(itemDto.getProductId())
                .orElseThrow(() -> new ResourceNotFoundException("Battery not found: " + itemDto.getProductId()));

        if (battery.getQuantity() < itemDto.getQuantity()) {
            throw new InsufficientStockException("Insufficient stock for Battery: " + battery.getName());
        }

        battery.setQuantity(battery.getQuantity() - itemDto.getQuantity());
        batteryRepository.save(battery);
    }

    @Override
    public List<SaleResponseDto> getSalesByDateRange(LocalDate startDate, LocalDate endDate, ProductType productType, PaymentStatus paymentStatus) {
        LocalDateTime start = startDate!= null ? startDate.atTime(LocalTime.MIN): null;
        LocalDateTime end = endDate!= null ? endDate.atTime(LocalTime.MAX): null;

        List<Sale> sales;
        if (productType != null) {
            sales = saleRepository.findBySaleDateBetweenAndProductTypeOrderBySaleDateDesc(start, end, productType);
        } else if(paymentStatus != null) {
            sales = saleRepository.findBySaleDateBetweenAndPaymentStatusOrderBySaleDateDesc(start, end, paymentStatus);
        } else if(startDate!= null && endDate != null) {
            sales = saleRepository.findBySaleDateBetweenOrderBySaleDateDesc(start, end);
        } else {
            sales = saleRepository.findAllByOrderBySaleDateDesc();
        }

        return sales.stream()
                .map(sale -> mapToResponseDto(sale, productType))
                .collect(Collectors.toList());
    }

    private SaleResponseDto mapToResponseDto(Sale sale, ProductType filterType) {
        SaleResponseDto dto = new SaleResponseDto();
        BeanUtils.copyProperties(sale, dto);

        List<SaleItemRequestDto> saleItemRequestDtos = sale.getItems().stream()
                .filter(item -> filterType == null || item.getProductType() == filterType)
                .map(item -> {
                    SaleItemRequestDto itemDto = new SaleItemRequestDto();
                    BeanUtils.copyProperties(item, itemDto);
                    return itemDto;
                })
                .collect(Collectors.toList());

        // Recalculate totalAmount for filtered items
        BigDecimal filteredTotal = sale.getItems().stream()
                .filter(item -> filterType == null || item.getProductType() == filterType)
                .map(item -> item.getCustomerPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        dto.setTotalAmount(filteredTotal);

        dto.setItems(saleItemRequestDtos);
        return dto;
    }
}