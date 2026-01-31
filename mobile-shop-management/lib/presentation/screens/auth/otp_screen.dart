import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../home/home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.verifyOtp(
        widget.phoneNumber,
        _otpController.text,
      );

      if (mounted) {
        if (success) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        } else if (authProvider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _resendOtp() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.sendOtp(widget.phoneNumber);

    if (mounted) {
      if (authProvider.otpMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authProvider.otpMessage!)));
      } else if (authProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A1A1A),
                Color(0xFF2B2B2B),
                Color(0xFF8B0000),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0A), // Deep black
              Color(0xFF1C1C1C), // Dark grey
              Color(0xFF330000), // Very dark red
              Color(0xFF5C0000), // Dark red
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Stack(
                children: [
                  // Large transparent background text
                  Positioned.fill(
                    child: Center(
                      child: Opacity(
                        opacity: 0.05,
                        child: Text(
                          'SMS\nBATTERY\nWORKS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 120,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Main form content
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.verified_user,
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Enter OTP',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 32,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.red.withOpacity(0.5),
                                offset: const Offset(0, 2),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'OTP sent to ${widget.phoneNumber}',
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          )
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 48),
                        CustomTextField(
                          label: 'OTP',
                          hint: 'Enter 6-digit OTP',
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          validator: Validators.validateOtp,
                          prefixIcon: const Icon(Icons.lock),
                          maxLength: 6,
                        ),
                        const SizedBox(height: 24),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return CustomButton(
                              text: 'Verify OTP',
                              onPressed: _verifyOtp,
                              isLoading:
                                  authProvider.status == AuthStatus.loading,
                              icon: Icons.check,
                              backgroundColor: const Color(0xFFCC0000),
                              textColor: Colors.white,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _resendOtp,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                          ),
                          child: const Text('Resend OTP'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
