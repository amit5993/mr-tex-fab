import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/account_master_response.dart';
import '../model/common_response.dart';
import '../model/filter_response.dart';
import '../model/login_response.dart';
import '../model/party_response.dart';
import '../model/report_by_menu_response.dart';
import '../model/role_response.dart';
import '../model/user_manager_response.dart';
import '../presenter/add_edit_account_master_presenter.dart';
import '../presenter/add_edit_user_presenter.dart';
import '../utils/color.dart';
import '../utils/preference.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class AddEditAccountMaster extends StatefulWidget {
  const AddEditAccountMaster({super.key});

  @override
  State<AddEditAccountMaster> createState() => _AddEditAccountMasterState();
}

class _AddEditAccountMasterState extends State<AddEditAccountMaster> implements AddEditAccountMasterView {
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

  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController accountHeadController = TextEditingController();
  TextEditingController customerTypeController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController registrationTypeController = TextEditingController();

  TextEditingController add1Controller = TextEditingController();
  TextEditingController add2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController marketController = TextEditingController();
  TextEditingController landLineController = TextEditingController();
  TextEditingController altNumberController = TextEditingController();
  TextEditingController smsNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();

  TextEditingController bankNamePersonController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();

  TextEditingController tanNoController = TextEditingController();
  TextEditingController panNoController = TextEditingController();
  TextEditingController dharaController = TextEditingController();
  TextEditingController mudatController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  TextEditingController crDaysController = TextEditingController();
  TextEditingController teejaController = TextEditingController();
  TextEditingController melaController = TextEditingController();
  TextEditingController incController = TextEditingController();

  TextEditingController agentController = TextEditingController();
  TextEditingController transportController = TextEditingController();
  TextEditingController stationController = TextEditingController();
  TextEditingController retNameController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController brokerageController = TextEditingController();
  TextEditingController rDController = TextEditingController();
  TextEditingController firstPaymentController = TextEditingController();

  var userDataId = 0;
  var agentId = 0;
  var transportId = 0;
  var categoryId = 0;
  var accountHeadId = 0;
  // var customerTypeId = 0;
  var groupId = 0;
  var cityId = 0;
  var stationId = 0;
  var districtId = 0;
  var marketId = 0;

  String entryMode = 'Insert';

  bool isEdit = false;

  bool isContact = false;
  bool isBank = false;
  bool isTaxation = false;
  bool isOther = false;
  AccountMasterData? userData;

  AddEditAccountMasterPresenter? _presenter;

  _AddEditAccountMasterState() {
    _presenter = AddEditAccountMasterPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    userData = Get.arguments;

    if (userData != null) {
      userDataId = userData!.id!;
      //nameController.text = userData!.name!;
      categoryId = userData!.type!;
      categoryController.text = userData!.typeName!;
      nameController.text = userData!.name!;
      accountHeadId = userData!.schdId!;
      accountHeadController.text = userData!.schdName!;
      customerTypeController.text = userData!.custType!;
      registrationTypeController.text = userData!.registrationType!;
      groupId = userData!.group!;
      groupController.text = userData!.groupName!;
      gstController.text = userData!.gst!;
      add1Controller.text = userData!.add1!;
      add2Controller.text = userData!.add2!;
      cityController.text = userData!.city!;
      stateController.text = userData!.state!;
      districtController.text = userData!.district!;
      marketController.text = userData!.market!;
      pincodeController.text = userData!.pinCode!;
      landLineController.text = userData!.phone!;
      altNumberController.text = userData!.mobile!;
      smsNumberController.text = userData!.mobileSMS!;
      emailController.text = userData!.email!;
      contactPersonController.text = userData!.contactPerson!;
      bankNamePersonController.text = userData!.bankName!;
      accountNoController.text = userData!.acountNumber!;
      ifscCodeController.text = userData!.ifscCode!;
      branchNameController.text = userData!.branchName!;
      tanNoController.text = userData!.tanNo!;
      panNoController.text = userData!.panNo!;
      dharaController.text = userData!.dhara!;
      mudatController.text = userData!.mudat!;
      interestRateController.text = userData!.interestRate!.toString();
      crDaysController.text = userData!.crDays!;

      teejaController.text = userData!.dhara1!;
      melaController.text = userData!.dhara2!;
      incController.text = userData!.dhara3!;

      brokerageController.text = userData!.reftxt1!;
      rDController.text = userData!.reftxt2!;
      firstPaymentController.text = userData!.reftxt3!;

      transportId = userData!.transport!;
      transportController.text = userData!.transportName!;
      stationController.text = userData!.station!;
      retNameController.text = userData!.refName!;
      remarkController.text = userData!.remark!;

      agentId = userData!.agentId!;
      agentController.text = userData!.agentName!;



      entryMode = 'Update';
    }
  }

  void onClickSubmit() {
    if (nameController.text.toString().trim().isEmpty) {
      toastMassage('Please enter name');
      return;
    }

    if (categoryId == 0) {
      toastMassage('Please select category');
      return;
    }

    if (emailController.text.toString().trim().isNotEmpty) {
      if (!validateEmail(emailController.text.toString().trim())) {
        toastMassage(sEmailError);
        return;
      }
    }

    _presenter!.updateAccountMaster(
        nameController.text.toString().trim(),
        categoryId,
        gstController.text.toString().trim(),
        add1Controller.text.toString().trim(),
        add2Controller.text.toString().trim(),
        cityController.text.toString().trim(),
        stateController.text.toString().trim(),
        pincodeController.text.toString().trim(),
        altNumberController.text.toString().trim(),
        landLineController.text.toString().trim(),
        emailController.text.toString().trim(),
        smsNumberController.text.toString().trim(),
        transportId,
        stationId,
        agentId,
        groupId,
        0, //actionBy,
        userDataId, //id,
        accountHeadId, //schdId,
        customerTypeController.text.toString().trim(),
        registrationTypeController.text.toString().trim(),
        districtController.text.toString().trim(),
        marketController.text.toString().trim(),
        contactPersonController.text.toString().trim(),
        bankNamePersonController.text.toString().trim(),
        accountNoController.text.toString().trim(),
        ifscCodeController.text.toString().trim(),
        branchNameController.text.toString().trim(),
        tanNoController.text.toString().trim(),
        panNoController.text.toString().trim(),
        dharaController.text.toString().trim(),
        mudatController.text.toString().trim(),
        interestRateController.text.toString().trim(),
        crDaysController.text.toString().trim(),
        teejaController.text.toString().trim(), //dhara1
        melaController.text.toString().trim(), //dhara2
        incController.text.toString().trim(), //dhara3
        retNameController.text.toString().trim(),
        remarkController.text.toString().trim(),
        brokerageController.text.toString().trim(), //reftxt1
        rDController.text.toString().trim(), //reftxt2
        firstPaymentController.text.toString().trim(), //reftxt3
        entryMode);


  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorLightGrayBG,
          body: Column(
            children: [
              actionBar(context, 'Account Master', true),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalViewBig(),
                        cellUI(
                          sName,
                          textField(context, nameController, sName, '', false, !isEdit),
                        ),
                        cellUI(
                          sCategory,
                          InkWell(
                              onTap: (() async {
                                FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sCategory, 'PrcGetAllCategory']) as FilterData;
                                if (rData != null) {
                                  setState(() {
                                    categoryController.text = rData.name!;
                                    categoryId = rData.id!;

                                    //refresh account head value from category
                                    try {
                                      accountHeadId = int.parse(rData.line1!);
                                      accountHeadController.text = rData.line2!;
                                    } on Exception catch (error) {
                                      print(error);
                                    }

                                  });
                                }
                              }),
                              child: textField(context, categoryController, sCategory, '', false, false)),
                        ),
                        cellUI(
                          sAccountHead,
                          InkWell(
                              onTap: (() async {
                                FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sAccountHead, 'PrcGetSchdule']) as FilterData;
                                if (rData != null) {
                                  setState(() {
                                    accountHeadController.text = rData.name!;
                                    accountHeadId = rData.id!;
                                  });
                                }
                              }),
                              child: textField(context, accountHeadController, sAccountHead, '', false, false)),
                        ),
                        cellUI(
                          sCustomerType,
                          InkWell(
                              onTap: (() async {
                                FilterData rData =
                                    await Get.toNamed('/all_filter_screen', arguments: [sCustomerType, 'PrcGetCustType']) as FilterData;
                                if (rData != null) {
                                  setState(() {
                                    customerTypeController.text = rData.name!;
                                    // customerTypeId = rData.id!;
                                  });
                                }
                              }),
                              child: textField(context, customerTypeController, sCustomerType, '', false, false)),
                        ),
                        cellUI(
                          sGroup,
                          InkWell(
                              onTap: (() async {
                                FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sGroup, 'PrcGetAllGroup']) as FilterData;
                                if (rData != null) {
                                  setState(() {
                                    groupController.text = rData.name!;
                                    groupId = rData.id!;
                                  });
                                }
                              }),
                              child: textField(context, groupController, sGroup, '', false, false)),
                        ),
                        cellUI(
                          sGst,
                          textField(context, gstController, sGst, '', false, true),
                        ),
                        cellUI(
                          sRType,
                          textField(context, registrationTypeController, sRType, '', false, true),
                        ),
                        InkWell(
                          onTap: (() {
                            setState(() {
                              isContact = !isContact;
                            });
                          }),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                sContactDetails,
                                style: heading1(colorApp),
                              ),
                              const Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Divider(height: 0.5, thickness: 1, color: colorPrimary),
                              )),
                              Text(
                                'View All',
                                style: bodyText1(colorGray),
                              ),
                              const Icon(
                                Icons.arrow_drop_down_outlined,
                                size: 25,
                                color: colorGray,
                              ),
                            ],
                          ),
                        ),
                        verticalView(),
                        Visibility(visible: isContact, child: contactDetails()),
                        InkWell(
                          onTap: (() {
                            setState(() {
                              isBank = !isBank;
                            });
                          }),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                sBankDetails,
                                style: heading1(colorApp),
                              ),
                              const Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Divider(height: 0.5, thickness: 1, color: colorPrimary),
                              )),
                              Text(
                                'View All',
                                style: bodyText1(colorGray),
                              ),
                              const Icon(
                                Icons.arrow_drop_down_outlined,
                                size: 25,
                                color: colorGray,
                              ),
                            ],
                          ),
                        ),
                        verticalView(),
                        Visibility(visible: isBank, child: bankDetails()),
                        InkWell(
                          onTap: (() {
                            setState(() {
                              isTaxation = !isTaxation;
                            });
                          }),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                sTaxationDetails,
                                style: heading1(colorApp),
                              ),
                              const Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Divider(height: 0.5, thickness: 1, color: colorPrimary),
                              )),
                              Text(
                                'View All',
                                style: bodyText1(colorGray),
                              ),
                              const Icon(
                                Icons.arrow_drop_down_outlined,
                                size: 25,
                                color: colorGray,
                              ),
                            ],
                          ),
                        ),
                        verticalView(),
                        Visibility(visible: isTaxation, child: taxationDetails()),
                        InkWell(
                          onTap: (() {
                            setState(() {
                              isOther = !isOther;
                            });
                          }),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                sOtherDetails,
                                style: heading1(colorApp),
                              ),
                              const Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Divider(height: 0.5, thickness: 1, color: colorPrimary),
                              )),
                              Text(
                                'View All',
                                style: bodyText1(colorGray),
                              ),
                              const Icon(
                                Icons.arrow_drop_down_outlined,
                                size: 25,
                                color: colorGray,
                              ),
                            ],
                          ),
                        ),
                        verticalView(),
                        Visibility(visible: isOther, child: otherDetails()),
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

  Widget cellUI(String title, Widget textField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: blackRegular(),
        ),
        verticalView(),
        textField,
        verticalViewBig(),
      ],
    );
  }

  Widget contactDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cellUI(
          sAddress1,
          textField(context, add1Controller, sAddress1, '', false, true),
        ),
        cellUI(
          sAddress2,
          textField(context, add2Controller, sAddress2, '', false, true),
        ),
        cellUI(
          sCity,
          InkWell(
              onTap: (() async {
                FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sCity, 'PrcGetCity']) as FilterData;
                if (rData != null) {
                  setState(() {
                    cityController.text = rData.name!;
                    cityId = rData.id!;
                  });
                }
              }),
              child: textField(context, cityController, sCity, '', false, false)),
        ),
        cellUI(
          sState,
          InkWell(
              onTap: (() async {
                FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sState, 'PrcGetState']) as FilterData;
                if (rData != null) {
                  setState(() {
                    stateController.text = rData.name!;
                    stationId = rData.id!;
                  });
                }
              }),
              child: textField(context, stateController, sState, '', false, false)),
        ),
        cellUI(
          sDistrict,
          InkWell(
              onTap: (() async {
                FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sDistrict, 'PrcGetDistict']) as FilterData;
                if (rData != null) {
                  setState(() {
                    districtController.text = rData.name!;
                    districtId == rData.id!;
                  });
                }
              }),
              child: textField(context, districtController, sDistrict, '', false, false)),
        ),
        cellUI(
          sPincode,
          textFieldNumber(context, pincodeController, sPincode, '', false, true),
        ),
        cellUI(
          sMarket,
          InkWell(
              onTap: (() async {
                FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sMarket, 'PrcGetMarket']) as FilterData;
                if (rData != null) {
                  setState(() {
                    marketController.text = rData.name!;
                    marketId = rData.id!;
                  });
                }
              }),
              child: textField(context, marketController, sMarket, '', false, false)),
        ),
        cellUI(
          sLandline,
          textFieldNumber(context, landLineController, sLandline, '', false, true),
        ),
        cellUI(
          sAltNumber,
          textFieldNumber(context, altNumberController, sAltNumber, '', false, true),
        ),
        cellUI(
          sSmsNumber,
          textFieldNumber(context, smsNumberController, sSmsNumber, '', false, true),
        ),
        cellUI(
          sEmail,
          textField(context, emailController, sEmail, '', false, true),
        ),
        cellUI(
          sContactPerson,
          textField(context, contactPersonController, sContactPerson, '', false, true),
        ),
      ],
    );
  }

  Widget bankDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cellUI(
          sBankName,
          textField(context, bankNamePersonController, sBankName, '', false, true),
        ),
        cellUI(
          sAccountNo,
          textField(context, accountNoController, sAccountNo, '', false, true),
        ),
        cellUI(
          sIfscCode,
          textField(context, ifscCodeController, sIfscCode, '', false, true),
        ),
        cellUI(
          sBranchName,
          textField(context, branchNameController, sBranchName, '', false, true),
        ),
      ],
    );
  }

  Widget taxationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cellUI(
          sTanNo,
          textField(context, tanNoController, sTanNo, '', false, true),
        ),
        cellUI(
          sPanNo,
          textField(context, panNoController, sPanNo, '', false, true),
        ),
        Row(
          children: [
            Expanded(
              child: cellUI(
                sDhara,
                textField(context, dharaController, sDhara, '', false, true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: cellUI(
                sMudat,
                textField(context, mudatController, sMudat, '', false, true),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: cellUI(
                sInterestRate,
                textField(context, interestRateController, sInterestRate, '', false, true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: cellUI(
                sCrDays,
                textField(context, crDaysController, sCrDays, '', false, true),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: cellUI(
                sTeeja,
                textField(context, teejaController, sTeeja, '', false, true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: cellUI(
                sMela,
                textField(context, melaController, sMela, '', false, true),
              ),
            ),
          ],
        ),
        cellUI(
          sInc,
          textField(context, incController, sInc, '', false, true),
        ),
      ],
    );
  }

  Widget otherDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cellUI(
          sAgent,
          InkWell(
              onTap: (() async {
                FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sAgent, 'PrcGetAgent']) as FilterData;
                if (rData != null) {
                  setState(() {
                    agentController.text = rData.name!;
                    agentId = rData.id!;
                  });
                }
              }),
              child: textField(context, agentController, sAgent, '', false, false)),
        ),
        cellUI(
          sTransport,
          InkWell(
              onTap: (() async {
                FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sTransport, 'PrcGetTransport']) as FilterData;
                if (rData != null) {
                  setState(() {
                    transportController.text = rData.name!;
                    transportId = rData.id!;
                  });
                }
              }),
              child: textField(context, transportController, sTransport, '', false, false)),
        ),
        cellUI(
          sStation,
          InkWell(
              onTap: (() async {
                FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sStation, 'PrcGetStation']) as FilterData;
                if (rData != null) {
                  setState(() {
                    stationController.text = rData.name!;
                    stationId = rData.id!;
                  });
                }
              }),
              child: textField(context, stationController, sStation, '', false, false)),
        ),
        cellUI(
          sRetName,
          textField(context, retNameController, sRetName, '', false, true),
        ),
        cellUI(
          sRemark,
          textField(context, remarkController, sRemark, '', false, true),
        ),
        cellUI(
          sBrokerage,
          textField(context, brokerageController, sBrokerage, '', false, true),
        ),
        cellUI(
          sRD,
          textField(context, rDController, sRD, '', false, true),
        ),
        cellUI(
          sFirstPayment,
          textField(context, firstPaymentController, sFirstPayment, '', false, true),
        ),
      ],
    );
  }

  @override
  void onError(int errorCode) {
    // TODO: implement onError
  }

  @override
  void onSuccess(CommonResponse data) {
    if (data.success!) {
      toastMassage(data.resultMessage!);
      Get.back(result: true);
    } else {
      toastMassage(data.resultMessage!);
    }
  }
}
