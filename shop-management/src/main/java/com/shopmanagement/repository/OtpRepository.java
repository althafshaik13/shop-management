package com.shopmanagement.repository;

import com.shopmanagement.entity.Otp;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface OtpRepository extends JpaRepository<Otp, Long> {
    Optional<Otp> findByPhoneAndOtp(String phone, String otp);
    void deleteByPhone(String phone);
}

