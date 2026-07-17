import 'package:homeopathy/Admin_portal/screens/Dashboard/dashboard.dart';
import 'package:homeopathy/Admin_portal/widgets/common_widgets/App_text.dart';
import 'package:homeopathy/Admin_portal/widgets/dashboard/login/side_drawe.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class LoginPanel extends StatefulWidget {
  const LoginPanel({super.key});

  @override
  State<LoginPanel> createState() => _LoginPanelState();
}

class _LoginPanelState extends State<LoginPanel> {
  bool remember = true;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Welcome back, Admin 👋",
                fontWeight: FontWeight.bold,
                fontSize: 36,
                color: Colors.black,
                fontFamily: "Poppins",
              ),

              const SizedBox(height: 3),

              AppText(
                text: "Sign in to manage your academy dashboard",
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontFamily: "Poppins",
              ),

              const SizedBox(height: 40),

              // const Text(
              //   "Email Address",
              //   style: TextStyle(
              //     fontWeight: FontWeight.w600),
              // ),
              AppText(
                text: "Email Address",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: "Poppins",
              ),

              const SizedBox(height: 10),

              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail_outline),
                  hintText: "admin@whitecoatacademy.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              AppText(
                text: "Password",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: "Poppins",
              ),

              const SizedBox(height: 10),

              TextField(
                obscureText: obscure,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Checkbox(
                    value: remember,
                    activeColor: Colors.green,
                    onChanged: (v) {
                      setState(() {
                        remember = v!;
                      });
                    },
                  ),

                  const Text("Remember me"),

                  const Spacer(),

                  TextButton(
                    onPressed: () {},
                    child: const Text("Forgot password?"),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff07B44C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Admin_Portal_Dashboard(),
                      ),
                    );
                  },

                  child: AppText(
                    text: "Login to Dashboard",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: Text(
                  "Protected by enterprise-grade encryption 🔒",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
