import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:td/common/utils.dart';
import 'package:td/utils/images.dart';

import '../model/filter_response.dart';
import '../model/issue_item_detail_response.dart';
import '../model/order_number_response.dart';
import '../utils/color.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class AddIssueItem extends StatefulWidget {
  const AddIssueItem({super.key});

  @override
  State<AddIssueItem> createState() => _AddIssueItemState();
}

class _AddIssueItemState extends State<AddIssueItem> {
  TextEditingController qualityNameController = TextEditingController();
  TextEditingController secUnitController = TextEditingController();

  TextEditingController secQtyController = TextEditingController();
  TextEditingController finalQualityController = TextEditingController();


  TextEditingController unitController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  IssueItemDetailData? issueItemDetailData;
  FilterData? filterData;
  OrderNumberData? orderNumberData;

  int selectMode = 1;
  int finalQuantityId = 0;
  String quantity = sQuantity;
  String secUnit = '';
  var isAdditional = false;

  @override
  void initState() {
    super.initState();

    var a = Get.arguments as List;

    selectMode = a[0];
    filterData = a[1];
    orderNumberData = a[2];
    if (a.length > 3) {
      issueItemDetailData = a[3];
    }

    if (issueItemDetailData != null) {
      qualityNameController.text = issueItemDetailData!.qualName!;
      unitController.text = issueItemDetailData!.unit!;
      qtyController.text = issueItemDetailData!.qty!.toString();
      rateController.text = issueItemDetailData!.rate!.toString();
      amountController.text = issueItemDetailData!.amt!.toString();
      remarkController.text = issueItemDetailData!.rmk!;
      secUnit = issueItemDetailData!.secUnit!;
      secUnitController.text = secUnit;
      secQtyController.text = issueItemDetailData!.secQty!.toString();
    } else {
      EasyLoading.show(status: 'loading...');
      Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
        selectIssueItem();
      });
    }
  }

  Future<void> selectIssueItem() async {
    issueItemDetailData = await Get.toNamed('/add_issue_item_list', arguments: [selectMode, filterData,orderNumberData]) as IssueItemDetailData;
    if (issueItemDetailData != null) {
      setState(() {
        qualityNameController.text = issueItemDetailData!.qualName!;
        unitController.text = issueItemDetailData!.unit!;
        qtyController.text = issueItemDetailData!.qty!.toString();
        rateController.text = issueItemDetailData!.rate!.toString();
        amountController.text = issueItemDetailData!.amt!.toString();
        remarkController.text = issueItemDetailData!.rmk!;
        secUnit = issueItemDetailData!.secUnit!;
        secUnitController.text = secUnit;
        secQtyController.text = issueItemDetailData!.secQty!.toString();
        // itemId = rData.id!;
      });
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
    if (rateController.text.isEmpty) {
      toastMassage('Please select rate');
      return;
    }
    if (amountController.text.isEmpty) {
      toastMassage('Please enter amount');
      return;
    }

    var qty = double.parse(qtyController.text);

    if(issueItemDetailData!.stkQty! > 0){
      if(issueItemDetailData!.stkQty! < qty){
        toastMassage('You can not enter Quantity more than ${issueItemDetailData!.stkQty!}');
        return;
      }
    }

    try {
      issueItemDetailData!.qualName = qualityNameController.text.toString().trim();
      issueItemDetailData!.unit = unitController.text.toString().trim();
      issueItemDetailData!.qty = qty;
      issueItemDetailData!.rate = double.parse(rateController.text);
      issueItemDetailData!.amt = double.parse(amountController.text);
      issueItemDetailData!.rmk = remarkController.text.toString().trim();
      issueItemDetailData!.secUnit = secUnit;
      try {
        issueItemDetailData!.secQty =double.parse(secQtyController.text.toString().trim());
      } on Exception catch (error) {
        print(error);
      }

      Get.back(result: issueItemDetailData!);
    } catch (e) {
      toastMassage('Some thing wrong.');
      return;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
            backgroundColor: colorLightGrayBG,
            body: Column(
              children: [
                actionBar(context, 'Add Issue Item', true),
                Expanded(
                    child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
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

                        // Visibility(
                        //   visible: secUnit.isNotEmpty,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         setQtyLabel(secUnit),
                        //         style: blackRegular(),
                        //       ),
                        //       verticalView(),
                        //       textFieldNumber(context, secUnitController, secUnit, '', false, true),
                        //       verticalView(),
                        //     ],
                        //   ),
                        // ),

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
                                          quantity = Utils.setQtyLabel(rData.name!);
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
                                          var rate = rateController.text.toString().trim();
                                          var amount = 0;
                                          if (text.isNotEmpty && rate.isNotEmpty) {
                                            amount = int.parse(text) * int.parse(rate);
                                          }
                                          setState(() {
                                            amountController.text = amount.toString();
                                          });
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

                        verticalView(),


                        Visibility(
                          visible: isAdditional,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [


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
                                                  secUnit =Utils. setQtyLabel(rData.name!);
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
                                            Utils.setQtyLabel(secUnit),
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
                              verticalView(),
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
                                          var pcs = qtyController.text.toString().trim();
                                          var amount = 0;
                                          if (text.isNotEmpty && pcs.isNotEmpty) {
                                            amount = int.parse(text) * int.parse(pcs);
                                          }
                                          setState(() {
                                            amountController.text = amount.toString();
                                          });
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
