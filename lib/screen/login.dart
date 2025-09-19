// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../common/check_response_code.dart';
import '../model/login_response.dart';
import '../model/user_verification_response.dart';
import '../presenter/login_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/preference.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> implements LoginView {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController clientCodeController = TextEditingController();
  bool isChecked = false;

  FocusNode focusNodeUserName = FocusNode();

  LoginPresenter? _presenter;

  var _passwordVisible = true;
  var isUserVerify = true;
  int selectedOption = 0;
  var deviceId = '';

  _LoginState() {
    _presenter = LoginPresenter(this);
  }

  void onClickSignIn() {
    // Get.toNamed('/main_screen');

    if(selectedOption == 0){
      toastMassage('Please select any client');
      return;
    }

    if (selectedOption == 1) {
      clientCodeController.text = 'MRTexAdhat';
    } else {
      clientCodeController.text = 'MRTexAgency';
    }

    var uName = userNameController.text.toString().trim();
    var cCode = clientCodeController.text.toString().trim();
    var pass = passwordController.text.toString().trim();

    if (uName.isEmpty) {
      toastMassage(sUserNameError);
      return;
    }
    if (cCode.isEmpty) {
      toastMassage(sClientCodeError);
      return;
    }
    if (isChecked) {
      PreferenceData.setUserName(uName);
      PreferenceData.setClientCode(cCode);
    }
    if (isUserVerify) {
      if (pass.isEmpty) {
        toastMassage(sPasswordError);
        return;
      }
      _presenter!.doLogin(uName, cCode, pass, deviceId);
      return;
    }
    _presenter!.doUserVerification(uName, cCode, deviceId);
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;

    userNameController.text = PreferenceData.getUserName();

    // if (PreferenceData.getClientCode().isNotEmpty) {
    //   if (PreferenceData.getClientCode() == 'MPFabTrad') {
    //     selectedOption = 1;
    //   } else {
    //     selectedOption = 2;
    //   }
    // }
    initUniqueIdentifierState();
  }

  initUniqueIdentifierState() async {
    try {
      deviceId = (await UniqueIdentifier.serial)!;
    } on PlatformException {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final deviceInfo = await deviceInfoPlugin.androidInfo;
        deviceId = deviceInfo.id;
      } else {
        final deviceInfo = await deviceInfoPlugin.iosInfo;
        deviceId = deviceInfo.identifierForVendor!;
      }
    }

    if (!mounted) return '';

    print(deviceId);
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return colorApp;
      }
      return colorApp;
    }

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
                                height: 135,
                                width: 135,
                              ),
                              verticalViewBig(),
                              Text(
                                sWelcome,
                                style: heading2(colorWhite),
                              ),
                              verticalView(),
                              Text(
                                sWelcomeDesc,
                                style: bodyText2(colorWhite),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.65,
                          decoration: const BoxDecoration(
                              color: colorWhite, borderRadius: BorderRadius.only(topLeft: Radius.circular(100))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 80,
                                ),
                                TextField(
                                  //focusNode: myFocusNode,
                                  enabled: true,
                                  obscureText: false,
                                  textAlign: TextAlign.left,
                                  controller: userNameController,
                                  autofocus: false,
                                  onChanged: (text) {},
                                  style: blackTitle(),
                                  decoration: InputDecoration(
                                    // border: InputBorder.none,
                                    /*focusedBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.green, width: 5.0),
                                 ),*/
                                    labelStyle: heading1(colorApp),
                                    labelText: sUserName,
                                    hintText: sUserName,
                                    hintStyle: heading1(colorGray),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                    //isDense: true,
                                  ),
                                ),
                                verticalViewBig(),
                                Visibility(
                                  visible: isUserVerify,
                                  child: Stack(
                                    children: [
                                      TextField(
                                        //focusNode: myFocusNode,
                                        obscureText: _passwordVisible,
                                        textAlign: TextAlign.left,
                                        controller: passwordController,
                                        autofocus: false,
                                        onChanged: (text) {},
                                        style: heading2(colorText),
                                        decoration: InputDecoration(
                                          // border: InputBorder.none,
                                          /*focusedBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.green, width: 5.0),
                                        ),*/
                                          labelStyle: heading1(colorApp),
                                          labelText: sPassword,
                                          hintText: sPassword,
                                          hintStyle: heading1(colorGray),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                          //isDense: true,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 10,
                                        child: InkWell(
                                          onTap: (() {
                                            setState(() {
                                              _passwordVisible = !_passwordVisible;
                                            });
                                          }),
                                          child: Icon(
                                            // Based on passwordVisible state choose the icon
                                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                            color: colorBlack,
                                          ),
                                        ),
                                      ),
                                      //const SizedBox(width: 5)
                                    ],
                                  ),
                                ),
                                verticalViewBig(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                                        visualDensity: VisualDensity(horizontal: -4, vertical: 0),
                                        title: Text(
                                          'Adhat',
                                          style: blackTitle(),
                                        ),
                                        leading: Radio(
                                          value: 1,
                                          groupValue: selectedOption,
                                          activeColor: colorApp,
                                          // Change the active radio button color here
                                          fillColor: MaterialStateProperty.all(colorApp),
                                          // Change the fill color when selected
                                          splashRadius: 25,
                                          // Change the splash radius when clicked
                                          onChanged: (value) {
                                            setState(() {
                                              selectedOption = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                                        visualDensity: VisualDensity(horizontal: -4, vertical: 0),
                                        title: Text(
                                          'Agency',
                                          style: blackTitle(),
                                        ),
                                        leading: Radio(
                                          value: 2,
                                          groupValue: selectedOption,
                                          activeColor: colorApp,
                                          // Change the active radio button color here
                                          fillColor: MaterialStateProperty.all(colorApp),
                                          // Change the fill color when selected
                                          splashRadius: 25,
                                          // Change the splash radius when clicked
                                          onChanged: (value) {
                                            setState(() {
                                              selectedOption = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // TextField(
                                //   //focusNode: myFocusNode,
                                //   enabled: true,
                                //   obscureText: false,
                                //   textAlign: TextAlign.left,
                                //   controller: clientCodeController,
                                //   autofocus: false,
                                //   onChanged: (text) {},
                                //   style: blackTitle(),
                                //   decoration: InputDecoration(
                                //     // border: InputBorder.none,
                                //     /*focusedBorder: const OutlineInputBorder(
                                //     borderSide: const BorderSide(color: Colors.green, width: 5.0),
                                //      ),*/
                                //     labelStyle: heading1(colorApp),
                                //     labelText: sClientCode,
                                //     hintText: sClientCode,
                                //     hintStyle: heading1(colorGray),
                                //     contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                //     //isDense: true,
                                //   ),
                                // ),

                                verticalView(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColor),
                                            value: isChecked,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked = value!;
                                              });
                                            },
                                          ),
                                          Text(
                                            sRememberMe,
                                            style: heading1(colorSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (() {
                                        // Get.toNamed('/service_request_plc');
                                      }),
                                      child: Text(
                                        '$sForgotPassword ?',
                                        style: const TextStyle(
                                            decoration: TextDecoration.underline,
                                            fontSize: 14,
                                            fontFamily: "Medium",
                                            color: colorSecondary),
                                      ),
                                    ),
                                  ],
                                ),
                                verticalView(),
                                InkWell(
                                    onTap: (() {
                                      onClickSignIn();
                                    }),
                                    child: btnHalf(context, sLogin)),
                                verticalViewBig(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))

              // Expanded(
              //   child: Stack(
              //     children: [
              //       Container(
              //         height: MediaQuery.of(context).size.height * 0.4,
              //         decoration: BoxDecoration(
              //             color: colorApp,
              //             border: Border.all(color: colorApp),
              //             borderRadius: const BorderRadius.only(
              //                 bottomRight: Radius.circular(8),
              //                 bottomLeft: Radius.circular(8))),
              //       ),
              //       SingleChildScrollView(
              //           child: Column(
              //         children: [
              //           SizedBox(
              //             height: MediaQuery.of(context).size.height * 0.3,
              //           ),
              //           Card(
              //             margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              //             elevation: 2,
              //             shape: const RoundedRectangleBorder(
              //               borderRadius: BorderRadius.all(Radius.circular(10)),
              //             ),
              //             child: Padding(
              //               padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.stretch,
              //                 children: [
              //                   verticalViewBig(),
              //                   Center(
              //                     child: Text(
              //                       sLogin.toUpperCase(),
              //                       style: const TextStyle(
              //                           fontSize: 20,
              //                           fontFamily: "Medium",
              //                           color: colorApp),
              //                     ),
              //                   ),
              //                   verticalViewBig(),
              //                   textField(context, userNameController,
              //                       sUserName, '', false,true),
              //                   verticalView(),
              //                   textField(context, clientCodeController,
              //                       sClientCode, '', false,true),
              //                   verticalView(),
              //                   /*textField(
              //                       context,
              //                       passwordController,
              //                       '',
              //                       icPassword,
              //                       false,
              //                     ),*/
              //
              //                   Visibility(
              //                     visible: isUserVerify,
              //                     child: Container(
              //                       decoration: BoxDecoration(
              //                           color: colorOffWhite,
              //                           border: Border.all(color: colorGray),
              //                           borderRadius: const BorderRadius.all(
              //                             Radius.circular(5),
              //                           )),
              //                       child: Padding(
              //                         padding: const EdgeInsets.only(
              //                             left: 10, right: 10),
              //                         child: Row(
              //                           children: [
              //                             Expanded(
              //                               child: TextField(
              //                                 //focusNode: myFocusNode,
              //                                 obscureText: _passwordVisible,
              //                                 textAlign: TextAlign.left,
              //                                 controller: passwordController,
              //                                 autofocus: false,
              //                                 onChanged: (text) {},
              //                                 style: heading2(colorText),
              //                                 decoration: InputDecoration(
              //                                   border: InputBorder.none,
              //                                   hintText: sPassword,
              //                                   hintStyle: heading1(colorGray),
              //                                   contentPadding:
              //                                       EdgeInsets.symmetric(
              //                                           horizontal: 0,
              //                                           vertical: 0),
              //                                   //isDense: true,
              //                                 ),
              //                               ),
              //                             ),
              //                             InkWell(
              //                               onTap: (() {
              //                                 setState(() {
              //                                   _passwordVisible =
              //                                       !_passwordVisible;
              //                                 });
              //                               }),
              //                               child: Icon(
              //                                 // Based on passwordVisible state choose the icon
              //                                 _passwordVisible
              //                                     ? Icons.visibility
              //                                     : Icons.visibility_off,
              //                                 color: colorBlack,
              //                               ),
              //                             ),
              //                             const SizedBox(width: 5)
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                   verticalView(),
              //                   Row(
              //                     mainAxisAlignment: MainAxisAlignment.start,
              //                     children: [
              //                       Expanded(
              //                         child: Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.start,
              //                           children: [
              //                             Checkbox(
              //                               checkColor: Colors.white,
              //                               fillColor: MaterialStateProperty
              //                                   .resolveWith(getColor),
              //                               value: isChecked,
              //                               onChanged: (bool? value) {
              //                                 setState(() {
              //                                   isChecked = value!;
              //                                 });
              //                               },
              //                             ),
              //                             Text(
              //                               sRememberMe,
              //                               style: heading1(colorSecondary),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                       InkWell(
              //                         onTap: (() {
              //                           // Get.toNamed('/service_request_plc');
              //                         }),
              //                         child: Text(
              //                           '$sForgotPassword ?',
              //                           style: const TextStyle(
              //                               decoration:
              //                                   TextDecoration.underline,
              //                               fontSize: 14,
              //                               fontFamily: "Medium",
              //                               color: colorSecondary),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   verticalView(),
              //                   InkWell(
              //                       onTap: (() {
              //                         onClickSignIn();
              //                       }),
              //                       child: btnHalf(context, sLogin)),
              //                   verticalViewBig(),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ],
              //       )),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onUserVerifySuccess(UserVerificationResponse data) {
    print(data);

    if (data.success!) {
      if (data.loginData!.isOTP!) {
        var uName = userNameController.text.toString().trim();
        var cCode = clientCodeController.text.toString().trim();

        Get.toNamed('/phone_auth', arguments: [uName, cCode, data.loginData!]);
      } else {
        setState(() {
          isUserVerify = true;
        });
      }
    } else {
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
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
  void onError(int errorCode) {
    if (errorCode == 401) {
      //Utils.howMyDialogNew(context, loginAlert);
      toastMassage('invalid credentials');
    } else {
      CheckResponseCode.getResponseCode(errorCode, context);
    }
  }
}
