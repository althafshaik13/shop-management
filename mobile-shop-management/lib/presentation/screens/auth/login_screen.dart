import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.sendOtp(_phoneController.text);

      if (mounted && authProvider.otpMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authProvider.otpMessage!)));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(phoneNumber: _phoneController.text),
          ),
        );
      } else if (mounted && authProvider.errorMessage != null) {
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
                          Icons.store,
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'SMS Battery Works',
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
                          'Enter 10-digit number',
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
                          label: 'Phone Number',
                          hint: 'Enter 10-digit phone number',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: Validators.validatePhone,
                          prefixIcon: const Icon(Icons.phone),
                          maxLength: 10,
                        ),
                        const SizedBox(height: 24),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return CustomButton(
                              text: 'Send OTP',
                              onPressed: _sendOtp,
                              isLoading:
                                  authProvider.status == AuthStatus.loading,
                              icon: Icons.send,
                              backgroundColor: const Color(0xFFCC0000),
                              textColor: Colors.white,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'An OTP will be sent to your phone number',
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          )
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white70),
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
