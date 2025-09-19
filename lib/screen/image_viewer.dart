import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/color.dart';
import '../utils/widget.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({super.key});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  var reportName = '';
  var url = '';

  String savePath = '';
  double progress = 0;
  bool didDownloadPDF = false;

  @override
  void initState() {
    super.initState();

    reportName = Get.arguments[0];
    url = Get.arguments[1];

    download(url);
  }

  Future download(String url) async {
    if (url.isEmpty) return;

    var tempDir = await getTemporaryDirectory();
    String fileName = url.split('/').last;
    savePath = '${tempDir.path}/$fileName';

    try {
      var response = await Dio().get(
        url,
        onReceiveProgress: updateProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      var file = File(savePath).openSync(mode: FileMode.write);
      file.writeFromSync(response.data);
      await file.close();
      print('file downloaded');
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProgress(done, total) async {
    progress = done / total;

    if (progress >= 1) {
      //Get.toNamed('/pdf_viewer', arguments: savePath);
      setState(() {
        didDownloadPDF = true;
      });
    } else {
      // progressString = 'Download progress: ' + (progress * 100).toStringAsFixed(0) + '% done.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Share.shareXFiles([XFile(savePath)]);
              // Share.shareFiles([savePath], text: 'Share Image');
            },
            backgroundColor: colorApp,
            child: const Icon(Icons.share),
          ),
          body: Column(
            children: [
              actionBar(context, reportName, true),
              Expanded(
                child: didDownloadPDF
                    //? Image.file(File(savePath))
                    ? PhotoView(
                        imageProvider: NetworkImage(url),
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text('Image load fail'),
                          );
                        },
                      )
                    : const Center(
                        child: Text('Please Wait...'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
