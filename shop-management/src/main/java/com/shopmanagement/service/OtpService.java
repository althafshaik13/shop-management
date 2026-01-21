package com.shopmanagement.service;

public interface OtpService {
     String sendOtp(String phone);
     void validateOtp(String phone, String otp);
}
