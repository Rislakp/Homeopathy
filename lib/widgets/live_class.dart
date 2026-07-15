import 'package:flutter/material.dart';
import 'package:homeopathy/widgets/common_widgetts.dart/size.dart';

class LiveClassCard extends StatelessWidget {
  const LiveClassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "LIVE NOW",
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

           AppSpacing.h25,

            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: CircleAvatar(radius: 35, child: Icon(Icons.play_arrow)),
              ),
            ),

          AppSpacing.h20,

            const Text(
              "Organon Aphorism 1-70 — Deep Analysis",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

         AppSpacing.h16,
            const ListTile(
              leading: CircleAvatar(),
              title: Text("Dr. Anjali Menon"),
              subtitle: Text("MD • 18 years"),
            ),
          ],
        ),
      ),
    );
  }
}
