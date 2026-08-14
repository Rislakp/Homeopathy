import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/admin_shell_layout.dart';
import 'package:homeopathy/auth/sign_up_screen.dart';
import 'package:homeopathy/auth/widgets/custom_text_field.dart';
import 'package:homeopathy/services/auth_service.dart';
import 'package:homeopathy/student_portal/pages/home/dashboard.dart';
import 'package:http/http.dart' as http;

/// Login Screen UI in Flutter that strictly follows the design system
/// and visual language of the existing Sign-up modal.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  /// Displays the Login Modal Dialog with a darkened, semi-transparent backdrop.
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (_) => const LoginDialog(),
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
            child: LoginModalCard(),
          ),
        ),
      ),
    );
  }
}

/// Dialog wrapper for the Login Modal Card.
class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key});

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
        child: const LoginModalCard(),
      ),
    );
  }
}

/// Modal Card containing the complete Login UI form and interactive state.
class LoginModalCard extends StatefulWidget {
  const LoginModalCard({super.key});

  @override
  State<LoginModalCard> createState() => _LoginModalCardState();
}

class _LoginModalCardState extends State<LoginModalCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGIN SUBMIT HANDLER
  // ============================================================

  Future<void> _handleSignIn() async {
    // Validate form inputs (ensures email and password are not empty)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(
        message: 'Please enter both email and password.',
        isError: true,
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      // Call AuthService login (universal) API to authenticate and get user role
      final res = await _authService.login(
        email: email,
        password: password,
      );

      if (!mounted) return;

      final role = (res['role'] ?? 'student').toString().toLowerCase().trim();
      final bool isAdmin = role == 'admin' || role == 'superadmin';

      _showSnackBar(
        message: isAdmin
            ? 'Admin authenticated successfully. Welcome!'
            : 'Sign in successful! Welcome back.',
        isError: false,
      );

      // Close modal on success and navigate to respective portal
      Navigator.of(context).maybePop();
      if (isAdmin) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const AdminShellLayout(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const StudentDashboardScreen(),
          ),
        );
      }
    } on http.ClientException catch (e) {
      if (!mounted) return;
      _showSnackBar(
        message: e.message.startsWith('Network error') ||
                e.message.startsWith('Unable to')
            ? e.message
            : 'Network error: ${e.message}',
        isError: true,
      );
    } catch (e) {
      if (!mounted) return;

      // Extract error message (handles 401 "Invalid email or password" and 403 "Invalid role: Student access only")
      final String errorMessage =
          e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');

      _showSnackBar(
        message: errorMessage.isEmpty
            ? 'Sign in failed. Please check your credentials.'
            : errorMessage,
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
  // FORGOT PASSWORD HANDLER
  // ============================================================

  void _handleForgotPassword() {
    _showSnackBar(
      message: 'Password reset link sent to your email (if registered).',
      isError: false,
    );
  }

  // ============================================================
  // SNACKBAR UTILITY
  // ============================================================

  void _showSnackBar({
    required String message,
    required bool isError,
  }) {
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
        backgroundColor:
            isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
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
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(
            isSmallScreen ? 20 : 28,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==================================================
                // HEADER SECTION
                // ==================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Solid dark blue circular icon with white profile silhouette
                    Container(
                      width: isSmallScreen ? 40 : 46,
                      height: isSmallScreen ? 40 : 46,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D3B8E),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: isSmallScreen ? 22 : 26,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Header Titles
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign in',
                            style: GoogleFonts.inter(
                              fontSize: isSmallScreen ? 20 : 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Welcome back to your account.',
                            style: GoogleFonts.inter(
                              fontSize: isSmallScreen ? 13 : 14,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Top-right circular close "X" icon
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: isSmallScreen ? 20 : 24,
                ),

                // ==================================================
                // FORM INPUT FIELDS
                // ==================================================

                // 1. Email ID Field
                CustomTextField(
                  label: 'Email ID',
                  controller: _emailController,
                  hintText: 'Enter your email',
                  prefixIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  isSmallScreen: isSmallScreen,
                  borderRadius: 8.0,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(
                      r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // 2. Password Field
                CustomTextField(
                  label: 'Password',
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  trailingIcon: _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onTrailingTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  isSmallScreen: isSmallScreen,
                  borderRadius: 8.0,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),

                // 3. Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.inter(
                        fontSize: isSmallScreen ? 12 : 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: isSmallScreen ? 20 : 24,
                ),

                // ==================================================
                // ACTION BUTTON (Sign In)
                // ==================================================

                SizedBox(
                  height: isSmallScreen ? 46 : 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D3B8E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Sign In',
                            style: GoogleFonts.inter(
                              fontSize: isSmallScreen ? 15 : 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                SizedBox(
                  height: isSmallScreen ? 16 : 20,
                ),

                // ==================================================
                // FOOTER (Don't have an account? Sign up)
                // ==================================================

                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: isSmallScreen ? 12 : 13,
                        color: const Color(0xFF64748B),
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(
                          text: "Don't have an account? ",
                        ),
                        TextSpan(
                          text: 'Sign up',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF2563EB),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).maybePop();
                              SignupScreen.show(context);
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
