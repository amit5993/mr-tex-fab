import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:td/api/constant.dart';
import 'package:td/model/user_verification_response.dart';
import '../../common/check_response_code.dart';
import '../../model/app_initial_response.dart';
import '../../model/login_response.dart';
import '../../presenter/login_presenter.dart';
import '../color.dart';
import '../preference.dart';
import 'dart:convert';

import '../widget.dart';

class ClientLoginDialog extends StatefulWidget {
  final ExtraClient client;
  final Function(String) onLoginSuccess;

  const ClientLoginDialog({
    Key? key,
    required this.client,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  _ClientLoginDialogState createState() => _ClientLoginDialogState();
}

class _ClientLoginDialogState extends State<ClientLoginDialog> implements LoginView {
  TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  LoginPresenter? _presenter;

  _ClientLoginDialogState() {
    _presenter = LoginPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _usernameController.text = PreferenceData.getUserName();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: colorApp,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Client logo
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: widget.client.clientLogo != null && widget.client.clientLogo!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              widget.client.clientLogo!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.business, color: colorApp, size: 30);
                              },
                            ),
                          )
                        : Icon(Icons.business, color: colorApp, size: 30),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Login to ${widget.client.clientName}',
                    style: heading2(colorWhite),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Login form
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Username field
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person, color: colorApp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: colorApp, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock, color: colorApp),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: colorText,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: colorApp, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorApp,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Login',
                              style: heading2(colorWhite),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cancel button
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: bodyText1(colorText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    // Validate inputs
    if (_usernameController.text.isEmpty) {
      toastMassage('Please enter username');
      return;
    }

    if (_passwordController.text.isEmpty) {
      toastMassage('Please enter password');
      return;
    }

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    var clientCode = '';
    if (widget.client.clientName == 'Adhat' || widget.client.clientName == 'Aadhat') {
      clientCode = Constant.adhat;
    } else if (widget.client.clientName == 'Agency') {
      clientCode = Constant.agency;
    }

    _presenter!.doLogin(
        _usernameController.text,
        clientCode,
        _passwordController.text,
        PreferenceData.getDeviceId()
    );

  }

  @override
  void onLoginSuccess(LoginResponse data) {
    if (data.success!) {
      PreferenceData.setToken(data.value!.token!);
      PreferenceData.setUserInfo(jsonEncode(data));

      // Save client information
      // PreferenceData.setCurrentClientId(widget.client.clientId.toString());
      // PreferenceData.setCurrentClientName(widget.client.clientName ?? '');

      // Call the success callback with the token
      widget.onLoginSuccess(data.value!.token!);

      // Close the dialog
      Navigator.pop(context);

      //Get.offAllNamed('/main_screen');
    } else {
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onError(int errorCode) {
    setState(() {
      _isLoading = false;
    });
    if (errorCode == 401) {
      toastMassage('Invalid credentials');
    } else {
      CheckResponseCode.getResponseCode(errorCode, context);
    }
  }

  @override
  void onUserVerifySuccess(UserVerificationResponse data) {}
}
