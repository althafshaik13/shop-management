package com.shopmanagement.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "inverter_batteries")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class InverterBattery {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(name = "model_number")
    private String modelNumber;

    private String capacity;

    @Column(name = "dealer_price")
    private BigDecimal dealerPrice;

    @Column(name = "customer_price")
    private BigDecimal customerPrice;

    private String voltage;

    @Column(name = "warranty_period_in_months")
    private Long warrantyPeriodInMonths;

    @Column(nullable = false)
    private Integer quantity;

    private String imageUrl;

    @CreationTimestamp
    private LocalDateTime createdAt;
}