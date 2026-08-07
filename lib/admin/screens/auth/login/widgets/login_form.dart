import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final credentials = LoginCredentials(
      email: _emailController.text,
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );

    if (credentials.isEmailEmpty) {
      _showErrorSnackbar('Email is required');
      return;
    }

    if (credentials.isPasswordEmpty) {
      _showErrorSnackbar('Password is required');
      return;
    }

    // Success - Show a clean snackbar and navigate to dashboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              'Welcome, login successful!',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF08B653),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      ),
    );

    // Simple delay for Snackbar to be readable, then navigate to Dashboard shell layout
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AdminShellLayout(),
          ),
        );
      }
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveLayout.isMobile(context);
    const Color brandColor = Color(0xFF08B653);
    const Color darkColor = Color(0xFF101828);
    const Color textGrey = Color(0xFF667085);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 460),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 16,
          vertical: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Logo - ONLY shown on Mobile layout
            if (isMobile) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: brandColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: brandColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.medical_services_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'White Coat Academy',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: darkColor,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        'Homeopathy E-Learning Platform',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 48),
            ],

            // Heading & Subtitle
            Text(
              'Welcome back, Admin 👋',
              style: GoogleFonts.outfit(
                fontSize: isMobile ? 28 : 32,
                fontWeight: FontWeight.w700,
                color: darkColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to manage your academy dashboard.',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: textGrey,
              ),
            ),
            const SizedBox(height: 36),

            // Email field
            CustomTextField(
              label: 'Email Address',
              hintText: 'admin@whitecoatacademy.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            const SizedBox(height: 20),

            // Password field
            CustomTextField(
              label: 'Password',
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 24),

            // Remember Me Row
            RememberMeSection(
              value: _rememberMe,
              onChanged: (val) {
                setState(() {
                  _rememberMe = val ?? false;
                });
              },
              onForgotPasswordPressed: () {
                _showErrorSnackbar(
                  'Password recovery flow is disabled for the demo admin account.',
                );
              },
            ),
            const SizedBox(height: 32),

            // Login Button
            LoginButton(
              onPressed: _handleLogin,
              text: 'Login to Dashboard',
            ),
            const SizedBox(height: 48),

            // Footer Text (Centered horizontally)
            const Center(
              child: FooterText(),
            ),
          ],
        ),
      ),
    );
  }
}
