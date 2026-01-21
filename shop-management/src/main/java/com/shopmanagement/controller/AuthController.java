package com.shopmanagement.controller;

import com.shopmanagement.config.JwtUtil;
import com.shopmanagement.service.OtpService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final OtpService otpService;
    private final JwtUtil jwtUtil;

    @PostMapping("/send-otp")
    public String sendOtp(@RequestParam String phone) {
        return otpService.sendOtp(phone);
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<Map<String, String>> verifyOtp(
            @RequestParam String phone,
            @RequestParam String otp) {

        otpService.validateOtp(phone, otp);
        String token = jwtUtil.generateToken(phone);

        return ResponseEntity.ok(Map.of("token", token));
    }
}

