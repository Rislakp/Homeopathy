import 'package:flutter/material.dart';
import 'package:homeopathy/pages/live_classes/live_card.dart';
import 'package:homeopathy/provider/live_classes.dart';
import 'package:provider/provider.dart';


class LiveClassSection extends StatelessWidget {
  const LiveClassSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LiveClassProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 10, color: Colors.green.shade700),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Live Classes",
                  style: TextStyle(color: Colors.green.shade700),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const Text("Learn Live from India's top \n faculty.",
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),),
        const SizedBox(height: 16),
      const Text(
        "Interactive sessions, doubt-solving, and recorded playback — all included.",
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
      const SizedBox(height: 40),

       GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
       itemCount: provider.liveClasses.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          mainAxisExtent: 220,
        ),
         itemBuilder: (context , index){
         final  LiveClass = provider.liveClasses[index];

          return LiveCard(
            title: LiveClass.title,
             description: LiveClass.description,
              date: LiveClass.endTime,
          );
         }
        )
      ],
    );
  }
}
