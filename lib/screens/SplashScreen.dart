// ignore: file_names
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset("assets/splashscreen.mp4")
      ..initialize().then((_) {
        setState(() => _ready = true);
        _controller.play();
      }).catchError((e) {
        print("VIDEO ERROR: $e");
      });

    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >= _controller.value.duration) {
        _goNext();
      }
    });
  }

  void _goNext() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, "/scan");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goNext,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _ready
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                )
              : Image.asset("assets/logo.png"),
        ),
      ),
    );
  }
}
