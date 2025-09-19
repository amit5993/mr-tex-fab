import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:td/model/common_response.dart';
import 'package:td/model/filter_response.dart';

import '../model/config_app_menu_response.dart';
import '../model/role_response.dart';
import '../presenter/configuration_presenter.dart';
import '../presenter/filter_presenter.dart';
import '../presenter/role_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/string.dart';
import '../utils/widget.dart';
import 'package:share_plus/share_plus.dart';

class ShareApp extends StatefulWidget {
  const ShareApp({super.key});

  @override
  State<ShareApp> createState() => _ShareAppState();
}

class _ShareAppState extends State<ShareApp>  {

  var androidAppLink = 'https://play.google.com/store/apps/details?id=com.mrtex.fab';
  var iosAppLink = 'https://apps.apple.com/app/id1556868598';



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorLightGrayBG,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: colorText,
                        // border: Border.all(color: colorText, width: 0.5),
                        borderRadius: const BorderRadius.all(Radius.circular(50))),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              // color: colorText,
                              border: Border.all(color: colorWhite, width: 0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(100))),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              icApple,
                              color: colorWhite,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Available on the',
                                style: bodyText1(colorWhite),
                              ),
                              Text(
                                'APPLE STORE',
                                style: displayTitle1(colorWhite),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                            onTap: (() async {
                              await Clipboard.setData(ClipboardData(text: iosAppLink));
                              toastMassage('Copied to your clipboard !');
                            }),
                            child: const Icon(Icons.copy, color: colorWhite)),
                        const SizedBox(width: 10),
                        InkWell(
                            onTap: (() async {
                              Share.share(iosAppLink);
                            }),
                            child: const Icon(Icons.share, color: colorWhite)),
                        const SizedBox(width: 15),
                      ],
                    ),
                  ),
                  verticalViewBig(),
                  Container(
                    decoration: BoxDecoration(
                        color: colorText,
                        // border: Border.all(color: colorText, width: 0.5),
                        borderRadius: const BorderRadius.all(Radius.circular(50))),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            // color: colorText,
                              border: Border.all(color: colorWhite, width: 0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(100))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10,10,0,10),
                            child: Image.asset(
                              icAndroid,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Android App on',
                                style: bodyText1(colorWhite),
                              ),
                              Text(
                                'GOOGLE PLAY',
                                style: displayTitle1(colorWhite),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                            onTap: (() async {
                              await Clipboard.setData(ClipboardData(text: androidAppLink));
                              toastMassage('Copied to your clipboard !');
                            }),
                            child: const Icon(Icons.copy, color: colorWhite)),
                        const SizedBox(width: 10),
                        InkWell(
                            onTap: (() async {
                              Share.share(androidAppLink);
                            }),
                            child: const Icon(Icons.share, color: colorWhite)),
                        const SizedBox(width: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
