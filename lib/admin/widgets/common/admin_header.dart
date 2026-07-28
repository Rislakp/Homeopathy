import 'package:homeopathy/admin/theme/admin_colors.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class AdminHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showSearch;
  final VoidCallback? onMenuPressed;
  final bool showMenuButton;

  const AdminHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showSearch = true,
    this.onMenuPressed,
    this.showMenuButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final showSmall = MediaQuery.of(context).size.width < 1100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          if (showMenuButton) ...[
            IconButton(onPressed: onMenuPressed, icon: const Icon(Icons.menu)),
            const SizedBox(width: 12),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
          ),

          if (showSearch && !showSmall) ...[
            SizedBox(
              width: 260,
              height: 42,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          // theme
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.dark_mode_outlined),
          ),

          // Notifications
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const NotificationsScreen(),
              //   ),
              // );
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline_rounded),
          ),

          const SizedBox(width: 16),

          Container(
  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: Colors.grey.shade300,
    ),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(
        radius: 18,
        backgroundColor:AdminColors.primaryDark,
        child: const Text(
          "DR",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      const SizedBox(width: 12),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "Dr. Renu Sharma",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "Super Admin",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),

      const SizedBox(width: 10),

      const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.grey,
      ),
    ],
  ),
)
        ],
      ),
    );
  }
}
