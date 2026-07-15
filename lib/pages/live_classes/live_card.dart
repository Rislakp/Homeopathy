import 'package:flutter/material.dart';

class LiveCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const LiveCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
    );
  }
}
