import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:td/utils/color.dart';
import 'package:td/utils/preference.dart';
import 'package:td/utils/widget.dart';
import 'package:video_player/video_player.dart';

class VideoAds extends StatefulWidget {
  const VideoAds({super.key});

  @override
  State<VideoAds> createState() => _VideoAdsState();
}

class _VideoAdsState extends State<VideoAds> {
  VideoPlayerController? _controller;
  String videoUrl = '';
  bool canPlay = false;

  @override
  void initState() {
    super.initState();

    var fileName = Get.arguments[0];
    videoUrl = Get.arguments[1];

    initVideoPlayer(fileName);

    // _controller = VideoPlayerController.file(File(localVideoPath))
    //   ..initialize().then((_) {
    //     setState(() {});
    //     _controller.play();
    //   });
    //
    // _controller.addListener(() {
    //   if (_controller.value.position == _controller.value.duration) {
    //     _navigateToMainScreen();
    //   }
    // });

    // BetterPlayerDataSource dataSource = BetterPlayerDataSource(
    //   BetterPlayerDataSourceType.file,
    //   localVideoPath,
    // );
    // _betterPlayerController = BetterPlayerController(
    //   const BetterPlayerConfiguration(
    //     aspectRatio: 16 / 9,
    //     autoPlay: true,
    //     // looping: true,
    //     controlsConfiguration: BetterPlayerControlsConfiguration(
    //       showControls: false,
    //     ),
    //   ),
    //   betterPlayerDataSource: dataSource,
    // );
    //
    // // Add event listener
    // _betterPlayerController.addEventsListener((event) {
    //   if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
    //     print("Video playback finished!");
    //     // Handle video finish event here
    //     _navigateToMainScreen();
    //   }
    // });
  }

  initVideoPlayer(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();

    final localVideoPath = "${directory.path}/$fileName";

    print("Constructed video path: $localVideoPath");

    File videoFile = File(localVideoPath);
    if (videoFile.existsSync()) {
      _controller = VideoPlayerController.file(videoFile)
        ..initialize().then((_) {
          setState(() {});
          _controller!.play();
          _controller!.addListener(() {
            if (_controller!.value.position == _controller!.value.duration) {
              _navigateToMainScreen();
            }
          });
        });
    } else {
      print("Video file does not exist.");
      // Handle file not found scenario
      // If video doesn't exist locally, play from the URL
      _controller = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          setState(() {});
          _controller!.play();

          _controller!.addListener(() {
            if (_controller!.value.position == _controller!.value.duration) {
              _navigateToMainScreen();
            }
          });
        });
    }
    canPlay = true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorBlack,
          body: Stack(
            children: [
              canPlay
                  ? Center(
                      child: _controller!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: VideoPlayer(_controller!),
                            )
                          : const CircularProgressIndicator(),
                    )
                  : const SizedBox(),
              // Skip Button
              Positioned(
                top: 40,
                right: 20,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 6.0, backgroundColor: colorApp, textStyle: const TextStyle(color: colorWhite)),
                  onPressed: () {
                    _navigateToMainScreen();
                  },
                  child: Text(
                    "Skip",
                    style: bodyText1(colorWhite),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMainScreen() {
    // _controller.pause();
    Get.back();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}
