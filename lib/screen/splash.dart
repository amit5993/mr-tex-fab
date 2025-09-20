import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../utils/images.dart';
import '../utils/preference.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    PreferenceData.getInstance();

    // Setup fade animation for smooth transition
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeIn,
      ),
    );

    _initializeVideo();

    // Fallback timer in case video initialization fails
    Timer(const Duration(seconds: 5), () {
      _openNextScreen();
    });
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset(splashGIF)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
            // Start playing the video as soon as it's initialized
            _controller.play();
            _fadeAnimationController.forward();
          });

          // Add a listener to detect when the video finishes playing
          _controller.addListener(() {
            if (_controller.value.position >= _controller.value.duration) {
              _openNextScreen();
            }
          });
        }
      }).catchError((error) {
        // If video fails to load, navigate to next screen after a short delay
        Timer(const Duration(milliseconds: 1500), () {
          _openNextScreen();
        });
      });
  }

  _openNextScreen() {
    if (mounted && (!_isVideoInitialized || !_controller.value.isPlaying)) {
      if (PreferenceData.getToken().isNotEmpty) {
        Get.offAllNamed('/main_screen');
      } else {
        if (Platform.isIOS) {
          Get.offNamed('/preload');
        } else {
          Get.offNamed('/login');
        }
      }
    }
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed from black to white for better initial appearance
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Static splash image that shows immediately
          Image.asset(
            appIcon, // Use your app icon or a static splash image
            fit: BoxFit.contain,
          ),

          // Video player with fade-in animation
          if (_isVideoInitialized)
            FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}