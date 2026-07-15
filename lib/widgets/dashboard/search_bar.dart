import 'package:flutter/material.dart';
import 'package:homeopathy/widgets/common_widgetts.dart/size.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search AIAPGET, Organon...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        ),
      AppSpacing.w20,
        ElevatedButton(
          child:  Text("Find Courses",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w200
          ),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
           onPressed: () {},
        )
      ],
    );
  }
}