import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:td/utils/images.dart';

import '../model/filter_response.dart';
import '../model/issue_item_detail_response.dart';
import '../model/receive_item_detail_response.dart';
import '../utils/color.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class AddReceiveItem extends StatefulWidget {
  const AddReceiveItem({super.key});

  @override
  State<AddReceiveItem> createState() => _AddReceiveItemState();
}

class _AddReceiveItemState extends State<AddReceiveItem> {
  TextEditingController qualityNameController = TextEditingController();
  TextEditingController finalQualityController = TextEditingController();
  TextEditingController secUnitController = TextEditingController();
  TextEditingController secQtyController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController stageController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController plainController = TextEditingController();
  TextEditingController secondController = TextEditingController();
  TextEditingController shortController = TextEditingController();
  TextEditingController lessController = TextEditingController();

  ReceiveItemDetails? receiveItemDetailData;
  FilterData? filterData;

  int jobberId = 0;
  String quantity = sQuantity;
  int finalQuantityId = 0;
  String secUnit = '';
  double secPcs = 0.0;
  var fresh = 0.0;
  var isAdditional = false;

  @override
  void initState() {
    super.initState();

    var a = Get.arguments as List;

    jobberId = a[0];
    filterData = a[1];
    if (a.length > 2) {
      receiveItemDetailData = a[2];
    }

    if (receiveItemDetailData != null) {
      qualityNameController.text = receiveItemDetailData!.qualName!;
      finalQualityController.text = receiveItemDetailData!.finalQuality!;
      finalQuantityId = receiveItemDetailData!.qualId!;
      unitController.text = receiveItemDetailData!.unit!;
      qtyController.text = receiveItemDetailData!.qty!.toString();
      rateController.text = receiveItemDetailData!.rate!.toString();
      amountController.text = receiveItemDetailData!.amt!.toString();
      plainController.text = receiveItemDetailData!.plain!.toString();
      secondController.text = receiveItemDetailData!.sec!.toString();
      shortController.text = receiveItemDetailData!.short!.toString();
      lessController.text = receiveItemDetailData!.less!.toString();
      stageController.text = receiveItemDetailData!.stage!;
      remarkController.text = receiveItemDetailData!.rmk!;
      secUnit = receiveItemDetailData!.secUnit!;
      secUnitController.text = secUnit;
      secPcs = receiveItemDetailData!.secPcs!;
      secQtyController.text = receiveItemDetailData!.secPcs!.toString();
      //secUnitController.text = receiveItemDetailData!.secPcs!.toString();

      calculateFreshAndAmount();
    } else {
      EasyLoading.show(status: 'loading...');
      Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
        selectIssueItem();
      });
    }
  }

  Future<void> selectIssueItem() async {
    receiveItemDetailData = await Get.toNamed('/add_receive_item_list', arguments: [jobberId, filterData]) as ReceiveItemDetails;
    if (receiveItemDetailData != null) {
      qualityNameController.text = receiveItemDetailData!.qualName!;
      finalQualityController.text = receiveItemDetailData!.finalQuality!;
      finalQuantityId = receiveItemDetailData!.qualId!;
      //unitController.text = issueItemDetailData!.unit!;
      qtyController.text = receiveItemDetailData!.qty!.toString();
      rateController.text = receiveItemDetailData!.rate!.toString();
      amountController.text = receiveItemDetailData!.amt!.toString();
      unitController.text = receiveItemDetailData!.unit!;
      stageController.text = receiveItemDetailData!.stage!;
      remarkController.text = receiveItemDetailData!.rmk!;
      secUnit = receiveItemDetailData!.secUnit!;
      secPcs = receiveItemDetailData!.secPcs!;
      secQtyController.text = receiveItemDetailData!.secPcs!.toString();
      secUnitController.text = secUnit;
      plainController.text = receiveItemDetailData!.plain!.toString();
      secondController.text = receiveItemDetailData!.sec!.toString();
      shortController.text = receiveItemDetailData!.short!.toString();
      lessController.text = receiveItemDetailData!.less!.toString();

      // itemId = rData.id!;
      calculateFreshAndAmount();
    }
  }

  void onClickSave() {
    if (qualityNameController.text.isEmpty) {
      toastMassage('Please select quality name');
      return;
    }
    if (unitController.text.isEmpty) {
      toastMassage('Please select unit');
      return;
    }
    if (qtyController.text.isEmpty) {
      toastMassage('Please enter qty');
      return;
    }
    // if (plainController.text.isEmpty) {
    //   toastMassage('Please enter plain');
    //   return;
    // }
    // if (secondController.text.isEmpty) {
    //   toastMassage('Please enter second');
    //   return;
    // }
    // if (shortController.text.isEmpty) {
    //   toastMassage('Please enter short');
    //   return;
    // }
    // if (lessController.text.isEmpty) {
    //   toastMassage('Please enter less');
    //   return;
    // }
    if (rateController.text.isEmpty) {
      toastMassage('Please select rate');
      return;
    }
    if (amountController.text.isEmpty) {
      toastMassage('Please enter amount');
      return;
    }

    try {
      receiveItemDetailData!.qualName = qualityNameController.text.toString().trim();
      receiveItemDetailData!.finalQuality = finalQualityController.text.toString().trim();
      receiveItemDetailData!.qualId = finalQuantityId;
      receiveItemDetailData!.unit = unitController.text.toString().trim();
      receiveItemDetailData!.qty = double.parse(qtyController.text);
      receiveItemDetailData!.rate = double.parse(rateController.text);
      receiveItemDetailData!.amt = double.parse(amountController.text);
      receiveItemDetailData!.rmk = remarkController.text.toString().trim();
      receiveItemDetailData!.stage = stageController.text.toString().trim();
      receiveItemDetailData!.secUnit = secUnit;
      receiveItemDetailData!.secPcs = secPcs;

      var strPlain = plainController.text.toString().trim();
      var strSecond = secondController.text.toString().trim();
      var strShort = shortController.text.toString().trim();
      var strLess = lessController.text.toString().trim();

      try {
        if (strPlain.isNotEmpty) {
          receiveItemDetailData!.plain = double.parse(strPlain);
        }
        if (strSecond.isNotEmpty) {
          receiveItemDetailData!.sec = double.parse(strSecond);
        }
        if (strShort.isNotEmpty) {
          receiveItemDetailData!.short = double.parse(strShort);
        }
        if (strLess.isNotEmpty) {
          receiveItemDetailData!.less = double.parse(strLess);
        }

        receiveItemDetailData!.secUnit = secUnitController.text.toString().trim();
        receiveItemDetailData!.secPcs = double.parse(secQtyController.text.toString().trim());
      } on Exception catch (error) {
        print(error);
      }

      Get.back(result: receiveItemDetailData!);
    } catch (e) {
      toastMassage('Some thing wrong.');
      return;
    }
  }

  String setQtyLabel(String s) {
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

  calculateFreshAndAmount() {
    var qty = 0.0;
    var plain = 0.0;
    var second = 0.0;
    var short = 0.0;
    var less = 0.0;
    var rate = 0.0;

    var strQty = qtyController.text.toString().trim();
    var strPlain = plainController.text.toString().trim();
    var strSecond = secondController.text.toString().trim();
    var strShort = shortController.text.toString().trim();
    var strLess = lessController.text.toString().trim();
    var strRate = rateController.text.toString().trim();

    // amountController
    // rateController

    if (strQty.isNotEmpty) {
      qty = double.parse(strQty);
    }
    if (strPlain.isNotEmpty) {
      plain = double.parse(strPlain);
    }
    if (strSecond.isNotEmpty) {
      second = double.parse(strSecond);
    }
    if (strShort.isNotEmpty) {
      short = double.parse(strShort);
    }
    if (strLess.isNotEmpty) {
      less = double.parse(strLess);
    }

    //Fresh=Qty-Plain-Sec-Short-Less
    fresh = qty - plain - second - short - less;

    if (strRate.isNotEmpty) {
      rate = double.parse(strRate);
    }

    if (fresh > 0 && rate > 0) {
      amountController.text = (fresh * rate).toString();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
            backgroundColor: colorLightGrayBG,
            body: Column(
              children: [
                actionBar(context, 'Add Receive Item', true),
                Visibility(
                  visible: fresh > 0,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    decoration: BoxDecoration(
                        color: colorApp.withOpacity(0.3),
                        border: Border.all(color: colorBlack),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Fresh',
                              style: heading2(colorBlack),
                            ),
                          ),
                          Text(
                            fresh.toString(),
                            style: heading2(colorBlack),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sQualityName,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        InkWell(
                            onTap: (() async {
                              selectIssueItem();
                            }),
                            child: textField(context, qualityNameController, sQualityName, '', false, false)),
                        verticalView(),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sUnit,
                                    style: blackRegular(),
                                  ),
                                  verticalView(),
                                  InkWell(
                                      onTap: (() async {
                                        FilterData rData =
                                            await Get.toNamed('/all_filter_screen', arguments: [sJobType, 'App_IssueQualUnitList']) as FilterData;
                                        if (rData != null) {
                                          quantity = setQtyLabel(rData.name!);
                                          setState(() {
                                            unitController.text = rData.name!;
                                          });
                                        }
                                      }),
                                      child: textField(context, unitController, sUnit, '', false, false)),
                                ],
                              ),
                            ),
                            horizontalView(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    quantity,
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
                                      child: TextField(
                                        //focusNode: myFocusNode,
                                        enabled: true,
                                        // keyboardType: TextInputType.number,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        obscureText: false,
                                        textAlign: TextAlign.left,
                                        controller: qtyController,
                                        autofocus: false,
                                        onChanged: (text) {
                                          calculateFreshAndAmount();
                                        },
                                        style: blackTitle(),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                            RegExp(
                                              r'^[0-9]*[.]?[0-9]*',
                                            ),
                                          ),
                                        ],
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: sQuantity,
                                          hintStyle: heading1(colorGray),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                          //isDense: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Visibility(
                          visible: isAdditional,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [


                              verticalView(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sPlain,
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
                                            child: TextField(
                                              //focusNode: myFocusNode,
                                              enabled: true,
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              obscureText: false,
                                              textAlign: TextAlign.left,
                                              controller: plainController,
                                              autofocus: false,
                                              onChanged: (text) {
                                                calculateFreshAndAmount();
                                              },
                                              style: blackTitle(),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                    r'^[0-9]*[.]?[0-9]*',
                                                  ),
                                                ),
                                              ],
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: sPlain,
                                                hintStyle: heading1(colorGray),
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                //isDense: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  horizontalView(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sSecond,
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
                                            child: TextField(
                                              //focusNode: myFocusNode,
                                              enabled: true,
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              obscureText: false,
                                              textAlign: TextAlign.left,
                                              controller: secondController,
                                              autofocus: false,
                                              onChanged: (text) {
                                                calculateFreshAndAmount();
                                              },
                                              style: blackTitle(),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                    r'^[0-9]*[.]?[0-9]*',
                                                  ),
                                                ),
                                              ],
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: sSecond,
                                                hintStyle: heading1(colorGray),
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                //isDense: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              verticalView(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sShort,
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
                                            child: TextField(
                                              //focusNode: myFocusNode,
                                              enabled: true,
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              obscureText: false,
                                              textAlign: TextAlign.left,
                                              controller: shortController,
                                              autofocus: false,
                                              onChanged: (text) {
                                                calculateFreshAndAmount();
                                              },
                                              style: blackTitle(),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                    r'^[0-9]*[.]?[0-9]*',
                                                  ),
                                                ),
                                              ],
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: sShort,
                                                hintStyle: heading1(colorGray),
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                //isDense: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  horizontalView(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sLess,
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
                                            child: TextField(
                                              //focusNode: myFocusNode,
                                              enabled: true,
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              obscureText: false,
                                              textAlign: TextAlign.left,
                                              controller: lessController,
                                              autofocus: false,
                                              onChanged: (text) {
                                                calculateFreshAndAmount();
                                              },
                                              style: blackTitle(),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                    r'^[0-9]*[.]?[0-9]*',
                                                  ),
                                                ),
                                              ],
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: sLess,
                                                hintStyle: heading1(colorGray),
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                //isDense: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),verticalView(),
                              Text(
                                sFinalQuality,
                                style: blackRegular(),
                              ),
                              verticalView(),
                              InkWell(
                                  onTap: (() async {
                                    FilterData rData =
                                    await Get.toNamed('/all_filter_screen', arguments: [sFinalQuality, 'App_PrcReceiveFinalQualLst']) as FilterData;
                                    if (rData != null) {
                                      finalQuantityId = rData.id!;
                                      setState(() {
                                        finalQualityController.text = rData.name!;
                                      });
                                    }
                                  }),
                                  child: textField(context, finalQualityController, sFinalQuality, '', false, false)),

                              verticalView(),
                              Visibility(
                                visible:secUnit.isNotEmpty,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Sec Unit',
                                            style: blackRegular(),
                                          ),
                                          verticalView(),

                                          InkWell(
                                              onTap: (() async {
                                                FilterData rData =
                                                await Get.toNamed('/all_filter_screen', arguments: [sJobType, 'App_IssueQualUnitList']) as FilterData;
                                                if (rData != null) {
                                                  secUnit = setQtyLabel(rData.name!);
                                                  setState(() {
                                                    secUnitController.text = rData.name!;
                                                  });
                                                }
                                              }),
                                              child: textField(context, secUnitController, secUnit, '', false, false)),
                                          // textFieldNumber(context, secUnitController, secUnit, '', false, true),
                                        ],
                                      ),
                                    ),
                                    horizontalView(),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            setQtyLabel(secUnit),
                                            style: blackRegular(),
                                          ),
                                          verticalView(),
                                          textFieldNumber(context, secQtyController, '', '', false, true),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        verticalView(),

                        InkWell(
                          onTap: (() {
                            setState(() {
                              if (isAdditional) {
                                isAdditional = false;
                              } else {
                                isAdditional = true;
                              }
                            });
                          }),
                          child: Container(
                            // margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                            // decoration: BoxDecoration(
                            //     color: colorApp.withOpacity(0.2),
                            //     border: Border.all(color: colorApp),
                            //     borderRadius: const BorderRadius.all(
                            //       Radius.circular(50),
                            //     )),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Icon(
                                    isAdditional ? Icons.close : Icons.add,
                                    color: colorApp,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    isAdditional ? 'Hide Additional Details' : 'Additional Details',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Medium",
                                      color: colorApp,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        verticalView(),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sRate,
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
                                      child: TextField(
                                        //focusNode: myFocusNode,
                                        enabled: true,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        obscureText: false,
                                        textAlign: TextAlign.left,
                                        controller: rateController,
                                        autofocus: false,
                                        onChanged: (text) {
                                          calculateFreshAndAmount();
                                        },
                                        style: blackTitle(),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                            RegExp(
                                              r'^[0-9]*[.]?[0-9]*',
                                            ),
                                          ),
                                        ],
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: sRate,
                                          hintStyle: heading1(colorGray),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                          //isDense: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            horizontalView(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sAmount,
                                    style: blackRegular(),
                                  ),
                                  verticalView(),
                                  textField(context, amountController, sAmount, '', false, false),
                                ],
                              ),
                            ),
                          ],
                        ),

                        verticalView(),
                        Text(
                          sStage,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        InkWell(
                            onTap: (() async {
                              FilterData rData =
                              await Get.toNamed('/all_filter_screen', arguments: [sStage, 'App_ReceiveStageList']) as FilterData;
                              if (rData != null) {
                                setState(() {
                                  stageController.text = rData.name!;
                                });
                              }
                            }),
                            child: textField(context, stageController, sStage, '', false, false)),

                        verticalView(),
                        Text(
                          sRemark,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        textField(context, remarkController, sRemark, '', false, true),
                        verticalView(),

                        verticalViewBig(),
                        InkWell(
                            onTap: (() {
                              onClickSave();
                            }),
                            child: btnHalf(context, 'Save')),
                        // isEdit
                        //     ? InkWell(/**/
                        //     onTap: (() {
                        //       onClickSave(false);
                        //     }),
                        //     child: btnHalf(context, 'Update'))
                        //     : Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     InkWell(
                        //         onTap: (() {
                        //           onClickSave(false);
                        //         }),
                        //         child: btnHalf(context, 'Save')),
                        //     const SizedBox(width: 10),
                        //     InkWell(
                        //         onTap: (() {
                        //           onClickSave(true);
                        //         }),
                        //         child: btnHalf(context, 'Save More')),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ))
              ],
            )),
      ),
    );
  }
}
