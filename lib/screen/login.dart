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
    initUniqueIdentifierState();

    // Set system UI overlay style to match the blue background
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: const Color(0xFF0D47A1), // Deep blue for navigation bar
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
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
    // Define the deep blue color to match the screenshot
    final deepBlueColor = const Color(0xFF0D47A1);

    return Scaffold(
      // Remove default safe area to allow color to extend to the top
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: deepBlueColor,
      body: Container(
        // Make sure this container fills the entire screen
        width: double.infinity,
        height: double.infinity,
        color: deepBlueColor,
        child: SafeArea(
          // Set bottom to false to extend color behind the bottom system navigation
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top Logo Section
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            appIcon,
                            height: 80,
                            width: 80,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Please enter login details to continue..",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Login Form Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: deepBlueColor,
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Username Field
                        _buildInputField(
                          controller: userNameController,
                          label: "Username",
                          icon: Icons.person_outline,
                          deepBlueColor: deepBlueColor,
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        Visibility(
                          visible: isUserVerify,
                          child: _buildPasswordField(deepBlueColor),
                        ),
                        const SizedBox(height: 25),

                        // Client Radio Buttons
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildRadioOption(
                                  title: "Aadhat",
                                  value: 1,
                                  icon: Icons.business,
                                  deepBlueColor: deepBlueColor,
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              Expanded(
                                child: _buildRadioOption(
                                  title: "Agency",
                                  value: 2,
                                  icon: Icons.store,
                                  deepBlueColor: deepBlueColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Remember Me & Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: isChecked,
                                    activeColor: deepBlueColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Remember Me",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                // Forgot password action
                              },
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                  color: deepBlueColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: onClickSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: deepBlueColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Add extra space at the bottom to ensure the blue color extends
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom input field builder
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color deepBlueColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: InputBorder.none,
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: deepBlueColor),
        ),
      ),
    );
  }

  // Password field with visibility toggle
  Widget _buildPasswordField(Color deepBlueColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: passwordController,
        obscureText: _passwordVisible,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: InputBorder.none,
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.lock_outline, color: deepBlueColor),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
      ),
    );
  }

  // Radio option builder
  Widget _buildRadioOption({
    required String title,
    required int value,
    required IconData icon,
    required Color deepBlueColor,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedOption = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: deepBlueColor, size: 20),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Radio(
              value: value,
              groupValue: selectedOption,
              activeColor: deepBlueColor,
              onChanged: (int? newValue) {
                setState(() {
                  selectedOption = newValue!;
                });
              },
            ),
          ],
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
      toastMassage('Invalid credentials');
    } else {
      CheckResponseCode.getResponseCode(errorCode, context);
    }
  }
}