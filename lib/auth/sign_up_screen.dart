import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/auth/login_screen.dart';
import 'package:homeopathy/auth/widgets/custom_text_field.dart';
import 'package:homeopathy/core/constants/api_constants.dart';
import 'package:homeopathy/services/auth_service.dart';
import 'package:homeopathy/student_portal/pages/home/dashboard.dart';
import 'package:http/http.dart' as http;

// IMPORTANT:
// This is SIGN UP, so use REGISTER API, not LOGIN API.
String get kStudentRegisterApiUrl => ApiConstants.register;

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  static Future<void> show(BuildContext context) {

    return showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (_) => const SignInDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.5),
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: SignInModalCard(),
          ),
        ),
      ),
    );
  }
}

class SignInDialog extends StatelessWidget {
  const SignInDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isMobile = mediaQuery.size.width < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 16 : 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: mediaQuery.size.height * 0.92,
        ),
        child: const SignInModalCard(),
      ),
    );
  }
}

class SignInModalCard extends StatefulWidget {
  const SignInModalCard({super.key});

  @override
  State<SignInModalCard> createState() => _SignInModalCardState();
}

class _SignInModalCardState extends State<SignInModalCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _dobController =
      TextEditingController();

  final TextEditingController _phoneController =
      TextEditingController();

  final TextEditingController _qualificationController =
      TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _qualificationController.dispose();
    super.dispose();
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D3B8E),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();

      setState(() {
        _dobController.text = '$day/$month/$year';
      });
    }
  }

  // ============================================================
  // SIGN UP API
  // ============================================================

  Future<void> _handleSignUp() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String dateOfBirth = _dobController.text.trim();
    final String contactNumber = _phoneController.text.trim();
    final String qualification = _qualificationController.text.trim();

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final responseData = await _authService.registerStudent(
        name: name,
        email: email,
        password: password,
        dateOfBirth: dateOfBirth,
        contactNumber: contactNumber,
        qualification: qualification,
      );

      if (!mounted) return;

      final String message =
          responseData['message']?.toString() ?? 'Registration Successful';

      _showSnackBar(
        message,
        isError: false,
      );

      // Close dialog if open as a popup modal
      Navigator.of(context).maybePop();

      // Navigate user to the main dashboard or Login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const StudentDashboardScreen(),
        ),
      );
    } on http.ClientException catch (e) {
      _showSnackBar(
        e.message.startsWith('Network error') ||
                e.message.startsWith('Unable to')
            ? e.message
            : 'Network error: ${e.message}',
        isError: true,
      );
    } catch (e) {
      debugPrint('SIGN UP ERROR: $e');

      // Strip "Exception: " prefix from Exception message if present
      final String errorMessage =
          e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');

      _showSnackBar(
        errorMessage,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showSnackBar(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? const Color(0xFFEF4444)
            : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final double width =
        MediaQuery.of(context).size.width;

    final bool isSmallScreen = width < 480;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: 500,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.15,
            ),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),
          padding: EdgeInsets.all(
            isSmallScreen ? 20 : 28,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                // ==================================================
                // HEADER
                // ==================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: isSmallScreen ? 40 : 46,
                      height: isSmallScreen ? 40 : 46,
                      decoration:
                          const BoxDecoration(
                        color: Color(0xFF0D3B8E),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size:
                            isSmallScreen ? 22 : 26,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign up',
                            style: GoogleFonts.inter(
                              fontSize:
                                  isSmallScreen
                                      ? 20
                                      : 22,
                              fontWeight:
                                  FontWeight.w700,
                              color:
                                  const Color(
                                0xFF0F172A,
                              ),
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            'Create your student account.',
                            style: GoogleFonts.inter(
                              fontSize:
                                  isSmallScreen
                                      ? 12
                                      : 13,
                              color:
                                  const Color(
                                0xFF64748B,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context)
                              .maybePop(),
                      child: Container(
                        padding:
                            const EdgeInsets.all(6),
                        decoration:
                            const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color:
                              Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height:
                      isSmallScreen ? 18 : 24,
                ),

                // ==================================================
                // NAME
                // ==================================================

                CustomTextFormField(
                  label: 'Name',
                  controller:
                      _nameController,
                  hintText:
                      'Enter your full name',
                  prefixIcon:
                      Icons.person_outline,
                  isSmallScreen:
                      isSmallScreen,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // ==================================================
                // EMAIL
                // ==================================================

                CustomTextFormField(
                  label: 'Email ID',
                  controller:
                      _emailController,
                  hintText:
                      'student@test.com',
                  prefixIcon:
                      Icons.mail_outline,
                  keyboardType:
                      TextInputType.emailAddress,
                  isSmallScreen:
                      isSmallScreen,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your email ID';
                    }

                    final emailRegex = RegExp(
                      r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$',
                    );

                    if (!emailRegex.hasMatch(
                      value.trim(),
                    )) {
                      return 'Please enter a valid email address';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // ==================================================
                // PASSWORD
                // ==================================================

                CustomTextFormField(
                  label: 'Password',
                  controller:
                      _passwordController,
                  hintText:
                      'Enter your password',
                  prefixIcon:
                      Icons.lock_outline,
                  keyboardType:
                      TextInputType.visiblePassword,
                  isPassword: true,
                  obscureText: true,
                  isSmallScreen:
                      isSmallScreen,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Please enter your password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // ==================================================
                // DOB
                // ==================================================

                CustomTextFormField(
                  label: 'Date of Birth',
                  controller:
                      _dobController,
                  hintText:
                      'DD / MM / YYYY',
                  prefixIcon:
                      Icons.calendar_today_outlined,
                  trailingIcon:
                      Icons.calendar_month,
                  readOnly: true,
                  onTap: () =>
                      _selectDate(context),
                  onTrailingTap: () =>
                      _selectDate(context),
                  isSmallScreen:
                      isSmallScreen,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please select your date of birth';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // ==================================================
                // PHONE
                // ==================================================

                CustomTextFormField(
                  label: 'Contact Number',
                  controller:
                      _phoneController,
                  hintText:
                      'Enter your contact number',
                  prefixIcon:
                      Icons.phone_outlined,
                  keyboardType:
                      TextInputType.phone,
                  isSmallScreen:
                      isSmallScreen,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your contact number';
                    }

                    if (value.trim().length < 8) {
                      return 'Please enter a valid contact number';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // ==================================================
                // QUALIFICATION
                // ==================================================

                CustomTextFormField(
                  label: 'Qualification',
                  controller:
                      _qualificationController,
                  hintText:
                      'Enter your qualification',
                  prefixIcon:
                      Icons.school_outlined,
                  isSmallScreen:
                      isSmallScreen,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your qualification';
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height:
                      isSmallScreen ? 20 : 26,
                ),

                // ==================================================
                // SIGN UP BUTTON
                // ==================================================

                SizedBox(
                  height:
                      isSmallScreen ? 46 : 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _handleSignUp,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF0D3B8E,
                      ),
                      foregroundColor:
                          Colors.white,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<
                                      Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Sign Up',
                            style:
                                GoogleFonts.inter(
                              fontSize:
                                  isSmallScreen
                                      ? 15
                                      : 16,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                SizedBox(
                  height:
                      isSmallScreen ? 16 : 20,
                ),

                // ==================================================
                // FOOTER
                // ==================================================

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize:
                          isSmallScreen ? 11 : 12,
                      color:
                          const Color(0xFF64748B),
                      height: 1.45,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            'By continuing, you agree to our ',
                      ),

                      TextSpan(
                        text:
                            'Terms & Conditions',
                        style:
                            GoogleFonts.inter(
                          color:
                              const Color(
                            0xFF2563EB,
                          ),
                          fontWeight:
                              FontWeight.w600,
                          decoration:
                              TextDecoration
                                  .underline,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {},
                      ),

                      const TextSpan(
                        text: ' and ',
                      ),

                      TextSpan(
                        text:
                            'Privacy Policy',
                        style:
                            GoogleFonts.inter(
                          color:
                              const Color(
                            0xFF2563EB,
                          ),
                          fontWeight:
                              FontWeight.w600,
                          decoration:
                              TextDecoration
                                  .underline,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {},
                      ),

                      const TextSpan(text: '.'),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: isSmallScreen ? 12 : 13,
                        color: const Color(0xFF64748B),
                      ),
                      children: [
                        const TextSpan(
                          text: 'Already have an account? ',
                        ),
                        TextSpan(
                          text: 'Sign in',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF2563EB),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).maybePop();
                              LoginScreen.show(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Note: CustomTextField / CustomTextFormField is now extracted into lib/auth/widgets/custom_text_field.dart