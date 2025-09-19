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

class _SplashState extends State<Splash> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    PreferenceData.getInstance();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset(splashGIF)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
          // Start playing the video as soon as it's initialized
          _controller.play();
        });

        // Add a listener to detect when the video finishes playing
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            _openNextScreen();
          }
        });
      });
  }

  _openNextScreen() {
    if (!_controller.value.isPlaying) {
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isVideoInitialized
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
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}