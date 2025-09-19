import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:td/model/issue_entry_response.dart';
import 'package:td/model/save_issue_request.dart';

import '../common/check_response_code.dart';
import '../model/common_response.dart';
import '../model/filter_response.dart';
import '../model/issue_item_detail_response.dart';
import '../model/login_response.dart';
import '../model/order_number_response.dart';
import '../presenter/add_issue_item_list_presenter.dart';
import '../presenter/add_issue_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/preference.dart';
import '../utils/string.dart';
import '../utils/widget.dart';
import 'package:intl/intl.dart';
import 'package:get/get_core/src/get_main.dart';

class AddIssue extends StatefulWidget {
  const AddIssue({super.key});

  @override
  State<AddIssue> createState() => _AddIssueState();
}

class _AddIssueState extends State<AddIssue> implements AddIssueView, AddIssueItemListView {
  AddIssuePresenter? _presenter;
  AddIssueItemListPresenter? _presenterItemList;

  TextEditingController issueNoController = TextEditingController();
  TextEditingController voucherNoController = TextEditingController();

  List<IssueItemDetailData> itemList = [];

  String date = sDate;

  // String issueVno = sIssueVno;
  String jobType = sJobType;
  String voucherNo = sVoucherNo;
  String company = sCompany;
  String issuer = sIssuer;
  String orderNo = sOrderNo;
  String transport = sTransport;
  String station = sStation;

  int jobTypeId = 0;
  int companyId = 0;
  int issuerId = 0;

  // int orderNo = 0;
  int transportId = 0;
  int stationId = 0;
  int itemId = 0;

  int selectedMode = 1;
  bool isEdit = false;

  FilterData? filterData;
  IssueData? issueData;
  OrderNumberData? orderNumberData;

  _AddIssueState() {
    _presenter = AddIssuePresenter(this);
    _presenterItemList = AddIssueItemListPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    var formatter = DateFormat('dd/MM/yyyy');
    date = formatter.format(DateTime.now());

    var a = Get.arguments as List;

    filterData = a[0];
    if (a.length > 1) {
      issueData = a[1];
      isEdit = true;

      try {
        date = formatter.format(DateTime.parse(issueData!.date!));
      } catch (e) {
        date = formatter.format(DateTime.now());
      }
      issueNoController.text = issueData!.vno!.toString();

      if (issueData!.issueItemDetails! != null) {
        if (issueData!.issueItemDetails!.length > 0) {
          jobType = issueData!.issueItemDetails![0].jobType!;
        }
      }

      jobTypeId = issueData!.typeId!;
      voucherNoController.text = issueData!.challanNo!;
      voucherNo = voucherNoController.text;
      issuer = issueData!.issuer!;
      issuerId = issueData!.accountId!;
      orderNo = issueData!.ordNo!;

      if (issueData!.mode! == 'Linked') {
        selectedMode = 2;
      } else {
        selectedMode = 1;
      }

      companyId = issueData!.conum!;
      company = issueData!.companyName!;

      itemList = issueData!.issueItemDetails!;
    } else {
      if (filterData != null) {
        issueNoController.text = filterData!.line1!;
        voucherNoController.text = filterData!.line1!;
        voucherNo = voucherNoController.text;
      }

      var lData = LoginResponse.fromJson(jsonDecode(PreferenceData.getUserInfo()));
      companyId = lData.value!.companyId!;
      company = lData.value!.companyName!;
    }
  }

  clickOnSubmitOrder() {
    voucherNo = voucherNoController.text;

    if (date == sDate) {
      toastMassage('Please select date');
      return;
    }

    // if (issueVno == sIssueVno) {
    //   toastMassage('Please select issue Vno.');
    //   return;
    // }

    // if (jobType == sJobType) {
    //   toastMassage('Please select job type');
    //   return;
    // }

    if (voucherNo == sVoucherNo) {
      toastMassage('Please select challan number');
      return;
    }

    if (issuer == sIssuer) {
      toastMassage('Please select issuer');
      return;
    }

    if (itemList.isEmpty) {
      toastMassage('Please add item');
      return;
    }

    var mode = '';
    if (selectedMode == 1) {
      mode = 'Normal';
    } else {
      mode = 'Linked';
    }

    var totalPcs = 0.0;
    var tMtr = 0.0;
    var amount = 0.0;

    if (itemList.isNotEmpty) {
      for (int i = 0; i < itemList.length; i++) {
        totalPcs += itemList[i].qty!;
        tMtr += itemList[i].rate!;
        amount += itemList[i].amt!;
      }
    }

    var formatter = DateFormat('yyyy-MM-dd');
    var apiPassDate = '';
    try {
      apiPassDate = formatter.format(DateTime.parse(date));
    } catch (e) {
      apiPassDate = formatter.format(DateTime.now());
    }

    var vNo = 0;
    try {
      if (issueNoController.text.isNotEmpty) {
        vNo = int.parse(issueNoController.text);
      }
    } catch (e) {
      print(e);
    }

    try {
      var saveIssueRequest = SaveIssueRequest();
      saveIssueRequest.outwardTrnId = isEdit ? issueData!.outwardTrnId : 0;
      saveIssueRequest.conum = companyId;
      saveIssueRequest.typeId = filterData!.id;
      saveIssueRequest.typeName = filterData!.name;
      saveIssueRequest.vno = vNo;
      saveIssueRequest.ordNo = orderNo;
      saveIssueRequest.date = apiPassDate;
      saveIssueRequest.challanNo = voucherNo;
      saveIssueRequest.issuer = issuer;
      saveIssueRequest.accountId = isEdit ? issueData!.accountId! : issuerId;
      saveIssueRequest.agentId = filterData!.agentId;
      saveIssueRequest.agentName = filterData!.agentName;
      saveIssueRequest.mode = mode;
      saveIssueRequest.totalPcs = totalPcs.toString();
      saveIssueRequest.tMtr = tMtr;
      saveIssueRequest.amount = amount;
      saveIssueRequest.transport = filterData!.transportId!;
      saveIssueRequest.transportName = filterData!.transportName;
      saveIssueRequest.station = filterData!.station;
      saveIssueRequest.lrCase = 0;
      saveIssueRequest.status = '';
      saveIssueRequest.remark = '';
      saveIssueRequest.jobType = jobType == sJobType ? '' : jobType;
      saveIssueRequest.issueItemDetails = itemList;

      _presenter!.saveIssue(saveIssueRequest);
    } catch (e) {
      toastMassage('Some thing wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorWhite,
          body: Column(
            children: [
              actionBar(context, 'Issue Entry', true),
              Expanded(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sCompany,
                        style: blackRegular(),
                      ),
                      verticalView(),
                      InkWell(
                        onTap: (() async {
                          if (!isEdit) {
                            FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sCompany, 'PrcCompanyBtn']) as FilterData;
                            if (rData != null) {
                              setState(() {
                                company = rData.name!;
                                companyId = rData.id!;
                              });
                            }
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
                              company,
                              style: company == sCompany ? heading1(colorGray) : blackTitle(),
                            ),
                          ),
                        ),
                      ),
                      verticalView(),
                      Row(
                        children: [
                          // horizontalView(),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: (() {
                                _selectDate(context);
                              }),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sDate,
                                    style: blackRegular(),
                                  ),
                                  verticalView(),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: colorOffWhite,
                                        border: Border.all(color: colorGray),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        date,
                                        style: date == sDate ? heading1(colorGray) : blackTitle(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          horizontalView(),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sIssueVno,
                                  style: blackRegular(),
                                ),
                                verticalView(),
                                textFieldNumber(context, issueNoController, sIssueVno, '', false, false),
                              ],
                            ),
                          ),
                        ],
                      ),
                      verticalView(),
                      Row(
                        children: [
                          // horizontalView(),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sJobType,
                                  style: blackRegular(),
                                ),
                                verticalView(),
                                InkWell(
                                  onTap: (() async {
                                    FilterData rData =
                                        await Get.toNamed('/all_filter_screen', arguments: [sJobType, 'App_IssueJobTypeList']) as FilterData;
                                    if (rData != null) {
                                      setState(() {
                                        jobType = rData.name!;
                                        jobTypeId = rData.id!;
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
                                        jobType,
                                        style: jobType == sJobType ? heading1(colorGray) : blackTitle(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          horizontalView(),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sVoucherNo,
                                  style: blackRegular(),
                                ),
                                verticalView(),
                                textFieldNumber(context, voucherNoController, sVoucherNo, '', false, true),
                              ],
                            ),
                          ),
                        ],
                      ),
                      verticalView(),
                      Row(
                        children: [
                          // horizontalView(),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sIssuer,
                                  style: blackRegular(),
                                ),
                                verticalView(),
                                InkWell(
                                  onTap: (() async {
                                    FilterData rData =
                                        await Get.toNamed('/all_filter_screen', arguments: [sIssuer, 'App_IssuePtyList']) as FilterData;
                                    if (rData != null) {
                                      setState(() {
                                        issuer = rData.name!;
                                        issuerId = rData.id!;
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
                                        issuer,
                                        style: issuer == sIssuer ? heading1(colorGray) : blackTitle(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(visible: filterData!.rateCateId! == '1', child: horizontalView()),
                          Visibility(
                            visible: filterData!.rateCateId! == '1',
                            child: Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sOrderNo,
                                    style: blackRegular(),
                                  ),
                                  verticalView(),
                                  InkWell(
                                    onTap: (() async {
                                      OrderNumberData rData =
                                          await Get.toNamed('/order_number', arguments: [filterData!.id!, issuerId]) as OrderNumberData;
                                      if (rData != null) {
                                        setState(() {
                                          orderNo = rData.vno!.toString();
                                          orderNumberData = rData;
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
                                          orderNo,
                                          style: orderNo == sOrderNo ? heading1(colorGray) : blackTitle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalViewBig(),
                      Text(
                        sMode,
                        style: blackRegular(),
                      ),
                      verticalView(),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                              visualDensity: VisualDensity(horizontal: -4, vertical: 0),
                              title: Text(
                                'Normal',
                                style: blackTitle(),
                              ),
                              leading: Radio(
                                value: 1,
                                groupValue: selectedMode,
                                activeColor: colorApp,
                                // Change the active radio button color here
                                fillColor: MaterialStateProperty.all(colorApp),
                                // Change the fill color when selected
                                splashRadius: 25,
                                // Change the splash radius when clicked
                                onChanged: (value) {
                                  setState(() {
                                    selectedMode = value!;
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
                                'Linked',
                                style: blackTitle(),
                              ),
                              leading: Radio(
                                value: 2,
                                groupValue: selectedMode,
                                activeColor: colorApp,
                                // Change the active radio button color here
                                fillColor: MaterialStateProperty.all(colorApp),
                                // Change the fill color when selected
                                splashRadius: 25,
                                // Change the splash radius when clicked
                                onChanged: (value) {
                                  setState(() {
                                    selectedMode = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalView(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: (() async {
                                var data = await Get.toNamed('/add_issue_item', arguments: [selectedMode, filterData, orderNumberData])
                                    as IssueItemDetailData;
                                if (data != null) {
                                  setState(() {
                                    // data.jobType = jobType;
                                    itemList.add(data);
                                  });
                                }
                              }),
                              child: btnHalf(context, 'Add Item')),
                          horizontalView(),
                          InkWell(
                              onTap: (() async {
                                String barcodeScanRes = '';
                                try {
                                  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
                                } on PlatformException {
                                  barcodeScanRes = 'Failed to get platform version.';
                                }

                                if (!mounted) {
                                  toastMassage('Invalid QR code..!');
                                  return;
                                }

                                if (barcodeScanRes != '-1') {
                                  var ordType = 0;
                                  var ordTrnId = 0;
                                  if (orderNumberData != null) {
                                    ordType = orderNumberData!.serId!;
                                    ordTrnId = orderNumberData!.trnId!;
                                  }
                                  _presenterItemList!.getIssueItemDetail(0, '', selectedMode, barcodeScanRes, filterData!.id!, ordType, ordTrnId);
                                } else {
                                  toastMassage('Invalid QR code..!');
                                }

                                print('Scan result is : $barcodeScanRes');
                              }),
                              child: btnHalf(context, 'Scan QR')),
                        ],
                      ),
                      verticalViewBig(),
                      Visibility(
                        visible: itemList.length > 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Item List',
                                    style: blackRegular(),
                                  ),
                                ),
                                Text(
                                  'Total Item : ${itemList.length.toString()}',
                                  style: heading1(colorBox1),
                                ),
                              ],
                            ),
                            verticalView(),
                            Container(
                              decoration: const BoxDecoration(color: colorOffWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: itemList == null ? 0 : itemList.length,
                                  itemBuilder: (BuildContext context, i) {
                                    var data = itemList[i];
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 25.0,
                                                height: 25.0,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: colorApp,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    (i + 1).toString(),
                                                    style: bodyText1(colorWhite),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  data.qualName!,
                                                  style: heading1(colorText),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: (() async {
                                                  var returnData = await Get.toNamed('/add_issue_item',
                                                      arguments: [selectedMode, filterData, orderNumberData, data]) as IssueItemDetailData;
                                                  if (returnData != null) {
                                                    itemList.removeAt(i);
                                                    itemList.add(returnData);
                                                    setState(() {});
                                                  }
                                                }),
                                                child: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration:
                                                      const BoxDecoration(color: colorApp, borderRadius: BorderRadius.all(Radius.circular(20))),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(7.0),
                                                    child: Image.asset(
                                                      icEdit,
                                                      color: colorWhite,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              InkWell(
                                                onTap: (() {
                                                  deleteDialog(context, i);
                                                }),
                                                child: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration:
                                                      const BoxDecoration(color: colorRed, borderRadius: BorderRadius.all(Radius.circular(20))),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Image.asset(
                                                      icDelete,
                                                      color: colorWhite,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                          decoration: const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(3))),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    itemDetailsView('Qty : ${data.qty}'),
                                                    itemDetailsView('Rate : ${data.rate}'),
                                                  ],
                                                ),
                                              ),
                                              const Divider(height: 0.5, thickness: 0.5, color: colorOffWhite),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    itemDetailsView('Amount : ${data.amt}'),
                                                    itemDetailsView('Unit : ${data.unit}'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(height: 0.5, thickness: 2, color: colorWhite),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      verticalViewBig(),
                      InkWell(
                          onTap: (() {
                            if (isAvoidDoubleClick()) {
                              clickOnSubmitOrder();
                            }
                          }),
                          child: btn(context, 'Submit')),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget itemDetailsView(String s) {
    return Expanded(
      child: Text(
        s,
        style: bodyText1(colorText),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: colorApp, // <-- SEE HERE
              onPrimary: colorOffWhite, // <-- SEE HERE
              onSurface: colorBlack, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ),
          child: child!,
        );
      },
    );

    var formatter = DateFormat('dd/MMM/yyyy');
    setState(() {
      date = formatter.format(selected!);
    });

    print("----------------");
    print(date);
  }

  deleteDialog(BuildContext context, int position) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: colorOffWhite,
            title: const Text("Confirmation", style: TextStyle(fontSize: 18, color: colorBlack, fontFamily: "Medium")),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete?', style: blackTitle1()),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "NO",
                  style: heading1(colorApp),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "YES",
                  style: heading1(colorApp),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    itemList.removeAt(position);
                  });
                },
              )
            ],
          );
        });
  }

  @override
  void onError(int errorCode) {
    CheckResponseCode.getResponseCode(errorCode, context);
  }

  @override
  void onSuccessSaveIssue(CommonResponse data) {
    if (data.success!) {
      Get.back(result: true);
    } else {
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }

  @override
  void onIssueItemDetailSuccess(IssueItemDetailResponse data) {
    print(data);
    if (data.success!) {
      if (data.value!.length > 0) {
        data.value![0].jobType = jobType;
        //remove duplicate
        itemList.removeWhere((m) => m.barCode == data.value![0].barCode);
        itemList.add(data.value![0]);
        setState(() {});
      }
    } else {
      toastMassage('Invalid QR code..!');
    }
  }
}
