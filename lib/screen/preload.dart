import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class Preload extends StatefulWidget {
  const Preload({super.key});

  @override
  State<Preload> createState() => _PreloadState();
}

class _PreloadState extends State<Preload> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: colorApp,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorWhite,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                color: colorApp,
                //height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            images1,
                            // height: 100,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            images8,
                            // height: 100,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            images3,
                            // height: 100,
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    verticalViewBig(),
                    Image.asset(
                      appIcon,
                      height: 100,
                      width: 100,
                    ),
                    verticalViewBig(),
                    Text(
                      sWelcomePreload,
                      style: heading2(colorBlack),
                    ),
                    verticalView(),
                    InkWell(
                        onTap: (() {
                          Get.toNamed('/login');
                        }),
                        child: btn(context, sSignIn)),
                    verticalView(),
                    InkWell(
                        onTap: (() {
                          Get.toNamed('/product');
                        }),
                        child: btn(context, sDashboard)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
