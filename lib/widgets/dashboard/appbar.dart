import 'package:flutter/material.dart';

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
            child: Icon(
              Icons.water_drop,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "AirHomoeo",
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
        _menuItem("Courses"),
        _menuItem("Live Classes"),
        _menuItem("Mock Tests"),
        _menuItem("Faculty"),
        _menuItem("Success Stories"),
        _menuItem("Blog"),
        _menuItem("Pricing"),
        _menuItem("More"),

        SizedBox(width: 20),

        Icon(Icons.search, color: Colors.black),

        SizedBox(width: 20),

        Text(
          "Sign in",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),

        SizedBox(width: 20),

        Container(
          margin: EdgeInsets.only(right: 30),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff1F7A3D),
              padding: EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 18,
              ),
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

  Widget _menuItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}