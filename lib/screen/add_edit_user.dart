import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/common_response.dart';
import '../model/filter_response.dart';
import '../model/login_response.dart';
import '../model/party_response.dart';
import '../model/report_by_menu_response.dart';
import '../model/role_response.dart';
import '../model/user_manager_response.dart';
import '../presenter/add_edit_user_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/preference.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class AddEditUser extends StatefulWidget {
  const AddEditUser({super.key});

  @override
  State<AddEditUser> createState() => _AddEditUserState();
}

class _AddEditUserState extends State<AddEditUser> implements AddEditUserView {
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

  TextEditingController userNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  var _passwordVisible = true;

  bool isActive = true;
  bool isOTP = false;
  bool isDeviceLock = false;
  bool isEdit = false;
  bool isParty = false;

  int companyId = 0;
  String company = sCompany;
  int clientId = 0;
  String role = sRole;
  int roleId = 0;
  String party = sParty;
  int partyId = 0;
  AppUserListModel? userData;
  String entryMode = 'Insert';

  AddEditUserPresenter? _presenter;

  _AddEditUserState() {
    _presenter = AddEditUserPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    //http://ttms.turboinfotech.com/api/appusers/insertapiuser
    /*{
	"success": true,
	"resultMessage": "Turbo Infotech:record has been saved successfully"
}*/

    userData = Get.arguments;

    if (userData != null) {
      clientId = userData!.clientId!;
      userNameController.text = userData!.userName!;
      firstNameController.text = userData!.firstName!;
      lastNameController.text = userData!.lastName!;
      emailController.text = userData!.emailId!;
      mobileController.text = userData!.smSmobile!;
      passwordController.text = userData!.password!;
      role = userData!.roleName!;
      roleId = userData!.roleId!;
      companyId = userData!.companyId!;
      company = userData!.companyName!;
      entryMode = 'Update';

      isOTP = userData!.isOTP!;
      isActive = userData!.isActive!;
      isDeviceLock = userData!.isDeviceLock!;

      isEdit = true;

      if (userData!.roleName == "Agent" ||
          userData!.roleName == "AgentGroup" ||
          userData!.roleName == "Customer" ||
          userData!.roleName == "CustomerGroup" ||
          userData!.roleName == "Supplier" ||
          userData!.roleName == "SupplierGroup") {
        isParty = true;
        party = userData!.partyName!;
        partyId = userData!.partyId!;
      }
    } else {
      var lData = LoginResponse.fromJson(jsonDecode(PreferenceData.getUserInfo()));
      clientId = lData.value!.clientId!;
    }
  }

  void onClickSubmit() {
    // Get.toNamed('/main_screen');

    var uName = userNameController.text.toString().trim();
    var uFirstName = firstNameController.text.toString().trim();
    var uLastName = lastNameController.text.toString().trim();
    var uPassword = passwordController.text.toString().trim();
    var uEmail = emailController.text.toString().trim();
    var uMobile = mobileController.text.toString().trim();

    if (uName.isEmpty) {
      toastMassage(sUserNameError);
      return;
    }

    if (uFirstName.isEmpty) {
      toastMassage(sFirstNameError);
      return;
    }

    if (uLastName.isEmpty) {
      toastMassage(sLastNameError);
      return;
    }

    if (!isEdit) {
      if (uPassword.isEmpty) {
        toastMassage(sPasswordError);
        return;
      }
    }

    /*if (uEmail.isEmpty) {
      toastMassage(sEmailError);
      return;
    }*/
    if (uEmail.isNotEmpty) {
      if (!validateEmail(uEmail)) {
        toastMassage(sEmailError);
        return;
      }
    }

    if (uMobile.isEmpty) {
      toastMassage(sMobileError);
      return;
    }

    if (role == sRole) {
      toastMassage(sRoleError);
      return;
    }

    if (isParty) {
      if (party == sParty) {
        toastMassage(sPartyError);
        return;
      }
    } else {
      party = '';
    }

    _presenter!.updateUser(clientId, uName, uPassword, uFirstName, uLastName, uEmail, uMobile, roleId, partyId, party, companyId, company, isActive,
        isOTP, entryMode, isDeviceLock);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorLightGrayBG,
          body: Column(
            children: [
              actionBar(context, 'User', true),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalViewBig(),
                        Text(
                          sUserName,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        textField(context, userNameController, sUserName, '', false, !isEdit),
                        verticalViewBig(),
                        Text(
                          sFirstName,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        textField(context, firstNameController, sFirstName, '', false, true),
                        verticalViewBig(),
                        Text(
                          sLastName,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        textField(context, lastNameController, sLastName, '', false, true),
                        verticalViewBig(),
                        Text(
                          sCompany,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        InkWell(
                            onTap: (() async {
                              FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sCompany, 'PrcCompanyBtn']) as FilterData;
                              if (rData != null) {
                                setState(() {
                                  company = rData.name!;
                                  companyId = rData.id!;
                                });
                              }
                            }),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: colorOffWhite,
                                  border: Border.all(color: colorGray),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        company,
                                        style: company == sCompany ? heading1(colorGray) : blackTitle(),
                                      ),
                                    ),
                                    Visibility(
                                      visible: company != sCompany,
                                      child: InkWell(
                                        onTap: (() {
                                          setState(() {
                                            company = sCompany;
                                            companyId = 0;
                                          });
                                        }),
                                        child: Image.asset(
                                          icClose,
                                          color: colorRed,
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        verticalView(),
                        Container(
                          decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(color: colorLightGray, width: 0.2),
                              borderRadius: const BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    sOTP,
                                    style: blackRegular(),
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    // This bool value toggles the switch.
                                    value: isOTP,
                                    activeColor: colorApp,
                                    //thumbColor: const MaterialStatePropertyAll<Color>(colorApp),
                                    onChanged: (bool value) {
                                      isOTP = value;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true, //!isEdit,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              verticalViewBig(),
                              Text(
                                sPassword,
                                style: blackRegular(),
                              ),
                              verticalView(),
                              Container(
                                decoration: BoxDecoration(
                                    color: colorOffWhite,
                                    border: Border.all(color: colorGray),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          //focusNode: myFocusNode,
                                          enabled: true,
                                          obscureText: _passwordVisible,
                                          textAlign: TextAlign.left,
                                          controller: passwordController,
                                          autofocus: false,
                                          onChanged: (text) {},
                                          style: blackTitle(),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: sPassword,
                                            hintStyle: heading1(colorGray),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                            //isDense: true,
                                          ),
                                        ),
                                      ),
                                      InkWell(
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
                                      const SizedBox(width: 5)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalView(),
                        Container(
                          decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(color: colorLightGray, width: 0.2),
                              borderRadius: const BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        sDeviceLock,
                                        style: blackRegular(),
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Switch(
                                        // This bool value toggles the switch.
                                        value: isDeviceLock,
                                        activeColor: colorApp,
                                        //thumbColor: const MaterialStatePropertyAll<Color>(colorApp),
                                        onChanged: (bool value) {
                                          isDeviceLock = value;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: isDeviceLock,
                                  child: InkWell(
                                    onTap: (() {
                                      // _presenter!.doClearLogins(PreferenceData.getUserName(), PreferenceData.getClientCode());
                                    }),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: colorApp,
                                          // border: Border.all(color: colorGray),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                        child: Text(
                                          'Clear Logins',
                                          style: bodyText2(colorWhite),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(visible: isDeviceLock,child: verticalView()),
                              ],
                            ),
                          ),
                        ),
                        verticalViewBig(),
                        Text(
                          sEmail,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        textField(context, emailController, sEmail, '', false, true),
                        verticalViewBig(),
                        Text(
                          sMobile,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        textField(context, mobileController, sMobile, '', false, true),
                        verticalViewBig(),
                        Text(
                          sRole,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        InkWell(
                          onTap: (() async {
                            RoleData rData = await Get.toNamed('/role') as RoleData;
                            if (rData != null) {
                              setState(() {
                                role = rData.name!;
                                roleId = rData.id!;

                                if (role == "Agent" ||
                                    role == "AgentGroup" ||
                                    role == "Customer" ||
                                    role == "CustomerGroup" ||
                                    role == "Supplier" ||
                                    role == "SupplierGroup") {
                                  isParty = true;
                                } else {
                                  isParty = false;
                                }
                              });
                            }
                          }),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: colorOffWhite,
                                border: Border.all(color: colorGray),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                              child: Text(
                                role,
                                style: role == sRole ? heading1(colorGray) : blackTitle(),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isParty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              verticalViewBig(),
                              Text(
                                sParty,
                                style: blackRegular(),
                              ),
                              verticalView(),
                              InkWell(
                                onTap: (() async {
                                  PartyData rData = await Get.toNamed('/party', arguments: role) as PartyData;
                                  if (rData != null) {
                                    setState(() {
                                      party = rData.text!;
                                      partyId = rData.id!;
                                    });
                                  }
                                }),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: colorOffWhite,
                                      border: Border.all(color: colorGray),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                                    child: Text(
                                      party,
                                      style: party == sParty ? heading1(colorGray) : blackTitle(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalView(),
                        Container(
                          decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(color: colorLightGray, width: 0.2),
                              borderRadius: const BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    sActive,
                                    style: blackRegular(),
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    // This bool value toggles the switch.
                                    value: isActive,
                                    activeColor: colorApp,
                                    //thumbColor: const MaterialStatePropertyAll<Color>(colorApp),
                                    onChanged: (bool value) {
                                      isActive = value;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        verticalView(),
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
      Get.back(result: true);
    } else {
      toastMassage(data.resultMessage!);
    }
  }

  @override
  void onSuccessClearLogins(CommonResponse data) {
    if (data.success!) {
    } else {
      toastMassage(data.resultMessage!);
    }
  }
}
