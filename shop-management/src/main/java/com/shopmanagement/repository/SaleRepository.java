package com.shopmanagement.repository;

import com.shopmanagement.entity.PaymentStatus;
import com.shopmanagement.entity.ProductType;
import com.shopmanagement.entity.Sale;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDateTime;
import java.util.List;

public interface SaleRepository extends JpaRepository<Sale, Long> {

    List<Sale> findAllByOrderBySaleDateDesc();

    List<Sale> findBySaleDateBetweenOrderBySaleDateDesc(LocalDateTime start, LocalDateTime end);

    @Query("SELECT DISTINCT s FROM Sale s JOIN s.items i WHERE s.saleDate BETWEEN :start AND :end AND i.productType = :productType ORDER BY s.saleDate DESC")
    List<Sale> findBySaleDateBetweenAndProductTypeOrderBySaleDateDesc(LocalDateTime start, LocalDateTime end, ProductType productType);

    List<Sale> findBySaleDateBetweenAndPaymentStatusOrderBySaleDateDesc(LocalDateTime start, LocalDateTime end, PaymentStatus paymentStatus);
}