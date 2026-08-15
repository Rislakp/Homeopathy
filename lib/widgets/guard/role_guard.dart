import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/services/auth_service.dart';

/// Reusable Role Guard Widget that conditionally renders [child] if the authenticated
/// user has [requiredRole] ('admin' or 'student').
class RoleGuard extends StatefulWidget {
  final String requiredRole;
  final Widget child;
  final Widget? fallback;

  const RoleGuard({
    super.key,
    required this.requiredRole,
    required this.child,
    this.fallback,
  });

  @override
  State<RoleGuard> createState() => _RoleGuardState();
}

class _RoleGuardState extends State<RoleGuard> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  bool _isAuthorized = false;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _checkAuthorization();
  }

  Future<void> _checkAuthorization() async {
    final token = await _authService.getToken();
    final role = await _authService.getUserRole();

    if (!mounted) return;

    if (token != null && token.isNotEmpty && role != null) {
      final cleanRole = role.toLowerCase().trim();
      final cleanRequired = widget.requiredRole.toLowerCase().trim();

      final bool hasPermission = cleanRequired == 'admin'
          ? (cleanRole == 'admin' || cleanRole == 'superadmin')
          : cleanRole == cleanRequired;

      setState(() {
        _userRole = role;
        _isAuthorized = hasPermission;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isAuthorized = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isAuthorized) {
      return widget.child;
    }

    return widget.fallback ??
        AccessDeniedScreen(
          requiredRole: widget.requiredRole,
          currentRole: _userRole,
        );
  }
}

/// Access Denied UI when a user attempts to access an unauthorized route or module.
class AccessDeniedScreen extends StatelessWidget {
  final String requiredRole;
  final String? currentRole;

  const AccessDeniedScreen({
    super.key,
    required this.requiredRole,
    this.currentRole,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 40,
            vertical: 32,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF334155),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Header
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.gpp_bad_rounded,
                    color: Color(0xFFEF4444),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),

                // Error Code
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "HTTP 403 FORBIDDEN",
                    style: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  "Access Denied",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  "You do not have the required permissions (${requiredRole.toUpperCase()}) to access this portal.",
                  style: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8),
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/',
                            (route) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF475569)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Return Home",
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          AuthService().logout(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Sign In Again",
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
