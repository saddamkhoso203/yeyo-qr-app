import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _videoReady = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Delay initialization to avoid startup crash
    Future.microtask(_initVideo);

    // Fallback navigation (in case video fails or hangs)
    Future.delayed(const Duration(seconds: 4), _goNext);
  }

  Future<void> _initVideo() async {
    try {
      final controller = VideoPlayerController.asset('assets/splashscreen.mp4');

      await controller.initialize();

      if (!mounted) return;

      controller.setLooping(false);
      controller.play();

      controller.addListener(() {
        if (controller.value.isInitialized &&
            controller.value.position >= controller.value.duration) {
          _goNext();
        }
      });

      setState(() {
        _controller = controller;
        _videoReady = true;
      });
    } catch (e) {
      debugPrint('Splash video error: $e');
      _goNext();
    }
  }

  void _goNext() {
    if (_navigated || !mounted) return;
    _navigated = true;

    Navigator.pushReplacementNamed(context, '/scan');
  }

  // Handle app lifecycle (prevents black screen / crash)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller?.pause();
    } else if (state == AppLifecycleState.resumed) {
      _controller?.play();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goNext,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _videoReady && _controller != null
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
              : Image.asset('assets/logo.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
