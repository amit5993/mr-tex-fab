import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:td/presenter/pdf_presenter.dart';

// import 'package:pdf_render/pdf_render.dart';
import 'package:pdfx/pdfx.dart';

import '../api/constant.dart';
import '../model/export_pdf_request.dart';
import '../model/export_pdf_response.dart';
import '../model/filter_response.dart';
import '../utils/color.dart';
import '../utils/widget.dart';

class PDFViewer extends StatefulWidget {
  const PDFViewer({super.key});

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> implements PDFView {
  String savePath = '';
  bool isConverting = false;

  var reportId = 0;
  var reportName = '';
  ExportPDFRequest? request;

  PDFPresenter? _presenter;
  final PdfViewerController _pdfViewerController = PdfViewerController();

  // Key for taking screenshot of the PDF viewer
  final GlobalKey _pdfViewerKey = GlobalKey();

  _PDFViewerState() {
    _presenter = PDFPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    var a = Get.arguments as List;

    if (a.length == 1) {
      _presenter!.getExportPDFFile(-1, a[0]);
    } else {
      reportId = a[0];
      reportName = a[1];
      if (a.length > 4) {
        _presenter!.getExportPDFFile(reportId, a[4]);
      } else if (a.length > 3) {
        download(a[3]);
      } else {
        request = a[2];
        _presenter!.getExportPDFFile(reportId, jsonEncode(request));
      }
    }
  }

  double progress = 0;
  bool didDownloadPDF = false;
  String progressString = 'File has not been downloaded yet.';

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

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

      print('Download completed successfully. File saved at: $savePath');
      print('Downloaded file size: ${File(savePath).lengthSync()} bytes');
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProgress(done, total) async {
    progress = done / total;

    print('Download: done $done total $total');

    if (progress >= 1) {
      print('File size : ${File(savePath).existsSync() && File(savePath).lengthSync() > 0}');
      setState(() {
        didDownloadPDF = true;
      });
    } else {
      print('Download progress: ${(progress * 100).toStringAsFixed(0)}% done.');
    }
  }

  // Take a screenshot of the current PDF page and share it
  Future<void> captureAndSharePdfPage() async {
    if (!File(savePath).existsSync()) {
      toastMassage('PDF file not found');
      return;
    }

    if (isConverting) {
      toastMassage('Already processing, please wait');
      return;
    }

    setState(() {
      isConverting = true;
    });

    try {
      // Show loading using EasyLoading
      EasyLoading.show(status: 'Capturing page image...');
      // Create directory for temporary images
      final tempDir = await getTemporaryDirectory();
      final imageDir = await Directory('${tempDir.path}/pdf_images').create(recursive: true);

      // Clear any existing files
      final existingFiles = await imageDir.list().toList();
      for (var file in existingFiles) {
        await file.delete();
      }

      try {
        // Get the current page number
        final currentPageNumber = _pdfViewerController.pageNumber;

        // Capture the screen using RepaintBoundary
        RenderRepaintBoundary boundary = _pdfViewerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null) {
          final Uint8List pngBytes = byteData.buffer.asUint8List();

          // Save the image to a file
          final imagePath = '${imageDir.path}/page_$currentPageNumber.png';
          final imageFile = File(imagePath);
          await imageFile.writeAsBytes(pngBytes);

          // Dismiss loading
          EasyLoading.dismiss();
          // Share the image
          await Share.shareXFiles(
            [XFile(imagePath)],
            text: 'PDF Page $currentPageNumber',
          );
        } else {
          throw Exception('Failed to capture page image');
        }
      } catch (e) {
        print('Error capturing PDF page: $e');
        // Dismiss loading
        EasyLoading.dismiss();
        EasyLoading.showError('Error: ${e.toString().split('\n')[0]}');
      }
    } catch (e) {
      print('Error: $e');
      // Dismiss loading
      EasyLoading.dismiss();
      EasyLoading.showError('Error: ${e.toString().split('\n')[0]}');
    } finally {
      setState(() {
        isConverting = false;
      });
    }
  }

  Future<void> captureAndShareAllPdfPages() async {
    if (!File(savePath).existsSync()) {
      toastMassage('PDF file not found');
      return;
    }

    if (isConverting) {
      toastMassage('Already processing, please wait');
      return;
    }

    setState(() {
      isConverting = true;
    });

    try {
      EasyLoading.show(status: 'Rendering PDF...');

      final pdfDoc = await PdfDocument.openFile(savePath);
      final pageCount = pdfDoc.pagesCount;

      final tempDir = await getTemporaryDirectory();
      final imageDir = await Directory('${tempDir.path}/pdf_images').create(recursive: true);

      List<XFile> imageFiles = [];

      for (int i = 1; i <= pageCount; i++) {
        final page = await pdfDoc.getPage(i);
        final pageImage = await page.render(
          width: page.width,
          height: page.height,
          forPrint: false,
          format: PdfPageImageFormat.jpeg,
        );

        final imagePath = '${imageDir.path}/page_$i.png';
        final imageFile = File(imagePath);
        // await imageFile.writeAsBytes(pageImage.bytes);

        if (pageImage?.bytes != null) {
          await imageFile.writeAsBytes(pageImage!.bytes);
          imageFiles.add(XFile(imagePath));
        } else {
          print('Failed to render page $i');
        }

        // imageFiles.add(XFile(imagePath));
        await page.close();
      }

      await pdfDoc.close();
      EasyLoading.dismiss();

      if (imageFiles.isNotEmpty) {
        await Share.shareXFiles(imageFiles, text: '');
      } else {
        toastMassage('No images generated');
      }
    } catch (e) {
      EasyLoading.dismiss();
      print('Error rendering PDF: $e');
      EasyLoading.showError('Failed to generate images');
    } finally {
      setState(() {
        isConverting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: SpeedDial(
            icon: Icons.share,
            backgroundColor: colorApp,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.picture_as_pdf, color: colorWhite),
                backgroundColor: colorApp,
                onTap: () {
                  if (File(savePath).existsSync()) {
                    Share.shareXFiles([XFile(savePath)]);
                  } else {
                    toastMassage('PDF file not available');
                  }
                },
                label: 'PDF',
              ),
              SpeedDialChild(
                child: const Icon(Icons.image, color: colorWhite),
                backgroundColor: colorApp,
                onTap: () {
                  captureAndShareAllPdfPages();
                },
                label: 'Image',
              ),
            ],
          ),
          body: Column(
            children: [
              actionBar(context, reportName, true),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: didDownloadPDF
                      ? openPDF()
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  openPDF() {
    if (File(savePath).existsSync()) {
      return RepaintBoundary(
        key: _pdfViewerKey,
        child: SfPdfViewer.file(
          File(savePath),
          controller: _pdfViewerController,
        ),
      );
    } else {
      return const Center(
        child: Text('PDF File is not available.'),
      );
    }
  }

  @override
  void onExportPDFSuccess(ExportPDFResponse data) {
    if (data.success!) {
      print(data);
      download(data.value!);
    } else {
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }

  @override
  void onError(int errorCode) {
    // TODO: implement onError
  }
}
