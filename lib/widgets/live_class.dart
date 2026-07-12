import 'package:flutter/material.dart';

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

            const SizedBox(height: 20),

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

            const SizedBox(height: 20),

            const Text(
              "Organon Aphorism 1-70 — Deep Analysis",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

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
