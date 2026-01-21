package com.shopmanagement.service.impl;

import com.shopmanagement.config.SecurityProperties;
import com.shopmanagement.entity.Otp;
import com.shopmanagement.repository.OtpRepository;
import com.shopmanagement.service.OtpService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class OtpServiceImpl implements OtpService {
    private final OtpRepository otpRepository;
    private final SecurityProperties securityProperties;

    @Override
    @Transactional
    public String sendOtp(String phone) {
        if (!securityProperties.getAllowedPhones().contains(phone)) {
            throw new RuntimeException("Phone number not allowed");
        }

        otpRepository.deleteByPhone(phone);

        String otp = String.valueOf(new Random().nextInt(9000) + 1000);

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime expiresAt = now.plusHours(24);
        System.out.println("OTP generated at: " + now + ", expires at: " + expiresAt);

        Otp entity = new Otp(
                null,
                phone,
                otp,
                expiresAt
        );

        otpRepository.save(entity);

        return otp;
    }

    @Override
    @Transactional
    public void validateOtp(String phone, String otp) {
        Otp entity = otpRepository.findByPhoneAndOtp(phone, otp)
                .orElseThrow(() -> new RuntimeException("Invalid OTP"));

        if (entity.getExpiresAt().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("OTP expired");
        }

        otpRepository.deleteByPhone(phone);
    }
}
