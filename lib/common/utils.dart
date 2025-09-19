import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/color.dart';
import '../utils/preference.dart';
import '../utils/string.dart';
import '../utils/widget.dart';
import 'common_log.dart';

class Utils {
  static logoutUser401(BuildContext context, String message) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: AlertDialog(
              backgroundColor: colorWhite,
              title: const Text("Your session has expired", style: TextStyle(fontSize: 19.0, color: colorBlack, decoration: TextDecoration.none)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(message, style: regularBlackText()),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: mediumTitle(),
                  ),
                  onPressed: () {
                    PreferenceData.clearData();
                    Get.offAllNamed('/login');
                  },
                ),
              ],
            ),
          );
        });
  }

  static showProgress() {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.show(status: 'loading...');
  }

  static hideProgress() {
    EasyLoading.dismiss();
  }

  static Future<bool> checkInternetConnection() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.mobile) {
    //   return Future<bool>.value(true);
    // } else if (connectivityResult == ConnectivityResult.wifi) {
    //   return Future<bool>.value(true);
    // } else {
    //   return Future<bool>.value(false);
    // }

    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    // This condition is for demo purposes only to explain every connection type.
    // Use conditions which work for your requirements.
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available.
      return Future<bool>.value(true);
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
      return Future<bool>.value(true);
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      // Ethernet connection available.
      return Future<bool>.value(true);
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      // Vpn connection active.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
      return Future<bool>.value(true);
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available.
      return Future<bool>.value(false);
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      // Connected to a network which is not in the above mentioned networks.
      return Future<bool>.value(false);
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      // No available network types
      return Future<bool>.value(false);
    } else {
      return Future<bool>.value(false);
    }
  }

  static check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      CommonLog.printLog("connected to a network.");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      CommonLog.printLog("connected to a network.");
    } else {
      CommonLog.printLog("NOT connected to a network.");
    }
  }

  static checkNetworkKillDialog(BuildContext context) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: AlertDialog(
              backgroundColor: colorOffWhite,
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(checkInternetPermission, style: blackTitle()),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Ok',
                    style: blackTitle(),
                  ),
                  onPressed: () {
                    ///For kill application
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    Navigator.pop(context, false);
                  },
                ),
              ],
            ),
          );
        });
  }

  static String setQtyLabel(String s) {
    String returnString = '';
    if (s.isEmpty) return sQuantity;
    switch (s[0].toLowerCase()) {
      case 'p':
        returnString = 'Pcs';
      case 'm':
        returnString = 'Mtr';
      case 'k':
        returnString = 'Weight';
      default:
        returnString = sQuantity;
    }
    return returnString;
  }

  static String formatAmount(String amount) {
    try {
      // Convert the string to a double
      double parsedAmount = double.parse(amount);
      // Format the double to the desired format
      return NumberFormat("##,##,##0").format(parsedAmount);
    } catch (e) {
      // Handle errors (e.g., invalid input)
      return "Invalid amount";
    }
  }


/*static int daysBetween(String endDate) {
    DateTime to = DateFormat("dd/MM/yyyy").parse(endDate);

    DateTime from = DateTime.now();

    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  static String dateFormatChange(String endDate) {
    DateTime to = DateFormat("dd-MM-yyyy HH:mm:ss a").parse(endDate);
    return to.toString();
  }*/
}
