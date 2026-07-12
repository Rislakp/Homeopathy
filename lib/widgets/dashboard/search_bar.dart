import 'package:flutter/material.dart';

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
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Find Courses"),
        )
      ],
    );
  }
}