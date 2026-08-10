import 'package:flutter/material.dart';

class DemoVideoCard extends StatefulWidget {
  const DemoVideoCard({super.key});

  @override
  State<DemoVideoCard> createState() => _DemoVideoCardState();
}

class _DemoVideoCardState extends State<DemoVideoCard> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Demo Video Preview',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),

          // Player Mockup
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?q=80&w=600&auto=format&fit=crop'),
                fit: BoxFit.cover,
                opacity: 0.4,
              ),
            ),
            child: Stack(
              children: [
                // Inner green shade overlay
                Container(
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Play/Pause Button
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.teal.withOpacity(0.9),
                      child: Icon(
                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Timer & Controls Overlay
                Positioned(
                  bottom: 8,
                  left: 12,
                  right: 12,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Slider Mockup
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
                          activeTrackColor: Colors.teal,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.teal,
                        ),
                        child: Slider(
                          value: _isPlaying ? 0.35 : 0.0,
                          onChanged: (v) {},
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isPlaying ? '04:12 / 12:00' : '00:00 / 12:00',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.volume_up_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Action Button
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _isPlaying = !_isPlaying;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isPlaying ? 'Playing video preview...' : 'Paused video preview.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
            label: Text(_isPlaying ? 'Pause Demo' : 'Preview Demo Video'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.teal),
              foregroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
