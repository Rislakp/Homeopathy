import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 16 * (1 - value)),
              child: child,
              
            ),
          );
        },
        child: ResponsiveLayout(
          // Mobile Layout
          mobile: const SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              physics: ClampingScrollPhysics(),
              child: LoginForm(),
            ),
          ),
          // Tablet Layout: Split screen 45 / 55
          tablet: const Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 45,
                child: LeftBrandPanel(),
              ),
              Expanded(
                flex: 55,
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
                    child: LoginForm(),
                  ),
                ),
              ),
            ],
          ),
          // Desktop Layout: Split screen 50 / 50
          desktop: const Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 50,
                child: LeftBrandPanel(),
              ),
              Expanded(
                flex: 50,
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
                    child: LoginForm(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
