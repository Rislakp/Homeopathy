import 'package:flutter/material.dart';
import 'package:homeopathy/pages/blog/blog_screen.dart';
import 'package:homeopathy/pages/course/course_screen.dart';
import 'package:homeopathy/pages/faculty/faculty.dart';
import 'package:homeopathy/pages/live_classes/live_class.dart';
import 'package:homeopathy/pages/mock_test/mock_test.dart';
import 'package:homeopathy/pages/pricing/price_screen.dart';
import 'package:homeopathy/pages/stories/sucess_stories.dart';
import 'package:homeopathy/widgets/common_widgetts.dart/size.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 80,
      titleSpacing: 30,
      title: Row(
        children: [
          // Logo
          CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xff1F7A3D),
            child: Icon(Icons.water_drop, color: Colors.white),
          ),
          AppSpacing.w10,

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Homoeo",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "ACADEMY",
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        _menuItem(context, "Courses", const CourseScreen()),
        _menuItem(context, "Live Classes", const LiveClassSection()),
        _menuItem(context, "Mock Tests", const MockTest()),
        _menuItem(context, "Faculty", const FacultyScreen()),
        _menuItem(context, "Success Stories", const SucessStories()),
        _menuItem(context, "Blog", const BlogScreen()),
        _menuItem(context, "Pricing", const PriceScreen()),

        // _menuItem( context,"More", const MoreScreen() ),
        AppSpacing.w20,
        IconButton(
          icon: Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),

      AppSpacing.w20,

        TextButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) =>
            //     const SignupScreen(),
            //   ),
            // );
          },
          child: const Text(
            "Sign in",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
       AppSpacing.w20,

        Container(
          margin: EdgeInsets.only(right: 30),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff1F7A3D),
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              shape: StadiumBorder(),
            ),
            onPressed: () {},
            icon: Icon(Icons.school, color: Colors.white),
            label: Text(
              "Start Learning",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _menuItem(BuildContext context, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        child: Text(
          title,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
