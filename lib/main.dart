import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:td/proxy/custom_proxy.dart';

import 'package:td/routes/router.dart' as RouterFile;
import 'package:td/screen/splash.dart';
import 'package:td/utils/color.dart';
import 'package:system_proxy/system_proxy.dart';

void main() async {
  await init();

  // if (!kReleaseMode) {
  Map<String, String>? proxy = await SystemProxy.getProxySettings();
  proxy ??= {'host': '', 'port': ''};

  if (proxy['host']!.isNotEmpty) {
    final setProxy = CustomProxy(ipAddress: proxy['host']!, port: int.parse(proxy['port']!));
    // final proxy = CustomProxy(ipAddress: "10.68.101.71", port: 8888);
    setProxy.enable();
  }
  // }

  runApp(const MyApp());

  // final systemTheme = SystemUiOverlayStyle.light.copyWith(
  //   systemNavigationBarColor: colorApp,
  //   systemNavigationBarIconBrightness: Brightness.light,
  //   statusBarColor: colorApp,
  //   statusBarIconBrightness: Brightness.light,
  // );

  const systemTheme = SystemUiOverlayStyle(
    statusBarColor: colorPrimary, // <-- SEE HERE
    statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
    statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
  );

  // SystemChrome.setSystemUIOverlayStyle(systemTheme);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: colorPrimary, //or set color with: Color(0xFF0000FF)
  ));
}

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  void initState() {
    // super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M.R. Tex Fab',
      home: const Splash(),
      builder: EasyLoading.init(),
      getPages: RouterFile.Router.route,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorPrimary,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        )),
        primaryColor: colorBlack,
        brightness: Brightness.light,
        scaffoldBackgroundColor: colorWhite,
        dialogBackgroundColor: colorBlack,
        dividerColor: Colors.black12,
        cardColor: colorWhite,
        canvasColor: colorWhite,
        hintColor: colorGray,
        // accentColor: colorApp,
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
        fontFamily: "Regular",
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(secondary: colorWhite),
      ),
    );
  }
}
