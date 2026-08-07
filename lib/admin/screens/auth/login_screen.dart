
import 'package:flutter/material.dart';
import 'package:homeopathy/admin/admin_shell_layout.dart';
import 'package:homeopathy/admin/service/auth/login_auth.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


// Future<void> _login() async {
//   final email = _emailController.text.trim();
//   final password = _passwordController.text;

//   if (email.isEmpty || password.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Enter email and password'),
//       ),
//     );
//     return;
//   }

//   setState(() {
//     isLoading = true;
//   });

//   try {
//     final result = await AuthService.login(
//       email: email,
//       password: password,
//     );

//     if (!mounted) return;

//     debugPrint('LOGIN RESPONSE: $result');

//     // LOGIN SUCCESS
//     if (result['success'] == true) {
//       // Optional success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Login successful'),
//           duration: Duration(seconds: 1),
//         ),
//       );

//       // Go to Admin Dashboard
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const AdminShellLayout(),
//         ),
//       );
//     } else {
//       // LOGIN FAILED
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             result['message'] ?? 'Invalid email or password',
//           ),
//         ),
//       );
//     }
//   } catch (e) {
//     if (!mounted) return;

//     debugPrint('LOGIN ERROR: $e');

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           e.toString().replaceFirst('Exception: ', ''),
//         ),
//       ),
//     );
//   } finally {
//     if (mounted) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1100,
                  ),
                  child: isDesktop
                      ? _buildDesktopLayout()
                      : _buildMobileLayout(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildWelcomePanel(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(55),
              child: _buildLoginForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 25,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.07),
          ),
        ],
      ),
      child: _buildLoginForm(),
    );
  }

  Widget _buildWelcomePanel() {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: const BoxDecoration(
        color: Color(0xFF2563EB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Admin Portal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Manage your platform with a simple, powerful and secure administration panel.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 16,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 35),

          _buildFeature(
            Icons.dashboard_rounded,
            'Dashboard Management',
          ),
          _buildFeature(
            Icons.quiz_rounded,
            'Question Bank Management',
          ),
          _buildFeature(
            Icons.people_alt_rounded,
            'User Management',
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Sign in to your admin account',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF6B7280),
          ),
        ),

        const SizedBox(height: 35),

        const Text(
          'Email Address',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            prefixIcon: const Icon(Icons.email_outlined),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Password',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              activeColor: const Color(0xFF2563EB),
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
            ),
            const Text(
              'Remember me',
              style: TextStyle(
                color: Color(0xFF4B5563),
                fontSize: 14,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed:(){
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const AdminShellLayout()),
);
            },
            // _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 25),

        const Center(
          child: Text(
            'Admin access only',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ),
      ],
    );
  }
}
