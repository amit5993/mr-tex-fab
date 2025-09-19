import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td/model/login_response.dart';
import 'package:td/model/otp_response.dart';
import 'package:td/presenter/otp_presenter.dart';

import '../model/user_verification_response.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/preference.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> implements OtpView {
  TextEditingController otpController = TextEditingController();
  var uName = '';
  var cCode = '';
  var otpCode = '';
  var deviceId = '';
  LoginData? loginData;

  OtpPresenter? _presenter;

  int secondsRemaining = 60;
  bool enableResend = false;
  Timer? timer;

  _PhoneAuthState() {
    _presenter = OtpPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    uName = Get.arguments[0];
    cCode = Get.arguments[1];
    loginData = Get.arguments[2];
    sendCode();

    getDevice();
  }

  getDevice() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      deviceId = deviceInfo.id;
    } else {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor!;
    }
  }

  sendCode() {
    if (loginData != null) {
      if (loginData!.smsurl!.isNotEmpty) {
        secondsRemaining = 60;
        otpCode = loginData!.otp!;
        _presenter!.callOtpUrl(loginData!.smsurl!);

        startTime();
      }
    }
  }

  void _resetTime() {
    //other code here
    setState(() {
      secondsRemaining = 60;
      enableResend = false;
    });
  }

  onClickSubmit() {
    var otp = otpController.text.toString().trim();
    if (otp.isEmpty) {
      toastMassage(sUserNameError);
      return;
    }

    if (otp != otpCode) {
      toastMassage('Wrong OTP entered');
      return;
    }

    _presenter!.doLogin(uName, cCode, '${uName}_$cCode', deviceId);
  }

  startTime() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorApp,
          body: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            appIcon,
                            height: 100,
                            width: 100,
                          ),
                          verticalViewBig(),
                          Text(
                            sPhoneAuthentication,
                            style: heading2(colorWhite),
                          ),
                          // verticalView(),
                          // Text(
                          //   sWelcomeDesc,
                          //   style: bodyText2(colorWhite),
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      decoration: const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.only(topLeft: Radius.circular(100))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 80,
                            ),
                            TextField(
                              //focusNode: myFocusNode,
                              enabled: true,
                              obscureText: false,
                              textAlign: TextAlign.left,
                              controller: otpController,
                              autofocus: false,
                              onChanged: (text) {},
                              style: blackTitle(),
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                                /*focusedBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.green, width: 5.0),
                                 ),*/
                                labelStyle: heading1(colorApp),
                                labelText: sOTP,
                                hintText: sOTP,
                                hintStyle: heading1(colorGray),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                //isDense: true,
                              ),
                            ),
                            verticalViewBig(),
                            InkWell(
                              onTap: (() {
                                if (enableResend) {
                                  _resetTime();
                                  sendCode();
                                }
                              }),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  enableResend ? sResend : 'Resend code after $secondsRemaining seconds',
                                  style: bodyText2(colorBlue),
                                ),
                              ),
                            ),
                            verticalView(),
                            InkWell(
                                onTap: (() {
                                  onClickSubmit();
                                }),
                                child: btnHalf(context, sSubmit)),
                            verticalViewBig(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onError(int errorCode) {
    // TODO: implement onError
  }

  @override
  void onOtpSendSuccess(OtpResponse data) {
    // if(data != null){
    //   if(data.status == 'success'){
    //     if(secondsRemaining != 0){
    //       startTime();
    //     }else{
    //       _resetTime();
    //     }
    //   }
    // }
  }

  @override
  void onLoginSuccess(LoginResponse data) {
    if (data.success!) {
      PreferenceData.setToken(data.value!.token!);
      PreferenceData.setUserInfo(jsonEncode(data));

      Get.offAllNamed('/main_screen');
    } else {
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }

  @override
  dispose() {
    timer!.cancel();
    super.dispose();
  }
}
