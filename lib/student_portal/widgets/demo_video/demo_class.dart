import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class DemoClassVideo extends StatefulWidget {
  const DemoClassVideo({super.key});

  @override
  State<DemoClassVideo> createState() => _DemoClassVideoState();
}

class _DemoClassVideoState extends State<DemoClassVideo> {
  late VideoPlayerController _controller;

  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/video/demo.mp4');

    _controller
        .initialize()
        .then((_) {
          if (!mounted) return;

          setState(() {});
          _controller
            ..setLooping(true)
            ..play();
        })
        .catchError((error) {
          debugPrint("Video Error: $error");
        });

    _controller.addListener(_onVideo);
  }

  void _onVideo() {
    if (!_controller.value.isInitialized) return;

    if (_controller.value.position.inSeconds >= 120 && !_dialogShown) {
      _dialogShown = true;

      _controller.pause();

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Preview Ended"),
            content: const Text(
              "Your 2 minute demo has ended.\n\nSubscribe to watch the full live class.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Later"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  // TODO:
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => const SubscriptionScreen(),
                  //   ),
                  // );
                },
                child: const Text("Subscribe"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideo);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "LIVE NOW",
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),

            AppSpacing.h25,

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_controller),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    ),
            ),

            AppSpacing.h20,

            const Text(
              "Organon Aphorism 1-70 — Deep Analysis",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            AppSpacing.h16,

            const ListTile(
              contentPadding: EdgeInsets.zero,
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
