import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:td/model/common_response.dart';

import '../common/utils.dart';
import '../presenter/change_password_presenter.dart';
import '../utils/color.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    implements ChangePasswordView {
  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  ChangePasswordPresenter? _presenter;

  _ChangePasswordState() {
    _presenter = ChangePasswordPresenter(this);
  }

  @override
  void initState() {
    super.initState();
  }

  onClickSubmit() {
    FocusScope.of(context).unfocus();
    var oldPass = oldController.text.toString().trim();
    var newPass = newController.text.toString().trim();
    var confirmPass = confirmController.text.toString().trim();

    if (oldPass.isEmpty) {
      toastMassage(sOldPasswordError);
      return;
    }

    if (newPass.isEmpty) {
      toastMassage(sNewPasswordError);
      return;
    }

    if (confirmPass.isEmpty) {
      toastMassage(sConfirmPasswordError);
      return;
    }

    if (newPass != confirmPass) {
      toastMassage(sMatchPasswordError);
      return;
    }

    _presenter!.changePassword(oldPass, newPass, '', '');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorLightGrayBG,
          body: Column(
            children: [
              // actionBar(context, sChangePassword, true),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalViewBig(),
                        Text(
                          sOldPassword,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        textField(context, oldController, sOldPassword, '',
                            false, true),
                        verticalViewBig(),
                        Text(
                          sNewPassword,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        textField(context, newController, sNewPassword, '',
                            true, true),
                        verticalViewBig(),
                        Text(
                          sConfirmPassword,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        textField(context, confirmController, sConfirmPassword,
                            '', true, true),
                        verticalViewBig(),
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
              )
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
  void onSuccess(CommonResponse data) {
    if (data.success!) {
      toastMassage('Success');
      Utils.logoutUser401(context, "Password has been changed successfully, Please sign in again");

    } else {
      toastMassage(data.resultMessage!);
    }
  }
}
