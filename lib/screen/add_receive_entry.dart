import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:td/api/constant.dart';
import 'package:td/model/issue_entry_response.dart';
import 'package:td/model/receive_entry_response.dart';

import '../common/check_response_code.dart';
import '../model/common_response.dart';
import '../model/filter_response.dart';
import '../model/login_response.dart';
import '../model/receive_item_detail_response.dart';
import '../model/save_receive_request.dart';
import '../presenter/add_receive_entry_presenter.dart';
import '../presenter/add_receive_item_list_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/preference.dart';
import '../utils/string.dart';
import '../utils/widget.dart';
import 'package:intl/intl.dart';
import 'package:get/get_core/src/get_main.dart';

class AddReceiveEntry extends StatefulWidget {
  const AddReceiveEntry({super.key});

  @override
  State<AddReceiveEntry> createState() => _AddReceiveEntryState();
}

class _AddReceiveEntryState extends State<AddReceiveEntry> implements AddReceiveEntryView, AddReceiveItemListView {
  AddReceiveEntryPresenter? _presenter;
  AddReceiveItemListPresenter? _presenterItemList;

  TextEditingController voucherNoController = TextEditingController();
  TextEditingController challanNoController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  List<ReceiveItemDetails> itemList = [];

  String date = sDate;
  String challanDate = sChallanDate;

  // String issueVno = sIssueVno;
  String jobType = sJobType;
  String challanNo = sChallanNo;
  String company = sCompany;
  String jobber = sJobber;
  String workAccount = sWorkAccount;
  String transport = sTransport;
  String station = sStation;

  int jobTypeId = 0;
  int companyId = 0;
  int jobberId = 0;
  int workAccountId = 0;
  int transportId = 0;
  int stationId = 0;
  int itemId = 0;

  FilterData? jobberData;

  bool isEdit = false;

  FilterData? filterData;
  ReceiveData? receiveData;

  _AddReceiveEntryState() {
    _presenter = AddReceiveEntryPresenter(this);
    _presenterItemList = AddReceiveItemListPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    var formatter = DateFormat('dd/MM/yyyy');
    date = formatter.format(DateTime.now());
    challanDate = formatter.format(DateTime.now());

    var a = Get.arguments as List;

    filterData = a[0];
    if (filterData != null) {
      workAccount = filterData!.transportName!;
      workAccountId = filterData!.transportId!;
    }

    if (a.length > 1) {
      receiveData = a[1];
      isEdit = true;

      try {
        date = formatter.format(DateTime.parse(receiveData!.date!));
      } catch (e) {
        date = formatter.format(DateTime.now());
      }

      voucherNoController.text = receiveData!.vno!.toString();

      if (receiveData!.receiveItemDetails! != null) {
        if (receiveData!.receiveItemDetails!.length > 0) {
          jobType = receiveData!.receiveItemDetails![0].jobType!;
        }
      }

      jobTypeId = receiveData!.typeId!;
      challanNoController.text = receiveData!.challanNo!;
      challanNo = challanNoController.text;
      jobber = receiveData!.issuer!;
      jobberId = receiveData!.accountId!;

      workAccount = receiveData!.refAc!;
      workAccountId = receiveData!.refId!;

      companyId = receiveData!.conum!;
      company = receiveData!.companyName!;

      remarkController.text = receiveData!.remark!;

      itemList = receiveData!.receiveItemDetails!;
    } else {
      if (filterData != null) {
        voucherNoController.text = filterData!.line1!;
        challanNoController.text = filterData!.line1!;
        challanNo = challanNoController.text;
      }

      var lData = LoginResponse.fromJson(jsonDecode(PreferenceData.getUserInfo()));
      companyId = lData.value!.companyId!;
      company = lData.value!.companyName!;
    }
  }

  clickOnSubmitOrder() {
    challanNo = challanNoController.text;

    if (date == sDate) {
      toastMassage('Please select date');
      return;
    }
    if (challanDate == sChallanDate) {
      toastMassage('Please select challan date');
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

    if (challanNo == sChallanNo) {
      toastMassage('Please select challan number');
      return;
    }

    if (jobber == sIssuer) {
      toastMassage('Please select issuer');
      return;
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

    var apiPassChallanDate = '';
    try {
      apiPassChallanDate = formatter.format(DateTime.parse(challanDate));
    } catch (e) {
      apiPassChallanDate = formatter.format(DateTime.now());
    }

    try {
      var saveRequest = SaveReceiveRequest();
      saveRequest.inwardTrnId = isEdit ? receiveData!.inwardTrnId : 0;
      saveRequest.conum = companyId;
      saveRequest.typeId = filterData!.id;
      saveRequest.typeName = filterData!.name;
      saveRequest.vno = int.parse(voucherNoController.text);
      saveRequest.date = apiPassDate;
      saveRequest.challanNo = challanNo;
      saveRequest.challanDat = apiPassChallanDate;
      saveRequest.issuer = jobber;
      saveRequest.accountId = isEdit ? receiveData!.accountId! : jobberId;
      saveRequest.refId = workAccountId;
      saveRequest.agentId = filterData!.agentId;
      saveRequest.agentName = filterData!.agentName;
      saveRequest.mode = '';
      saveRequest.totalPcs = totalPcs.toString();
      saveRequest.tMtr = tMtr;
      saveRequest.amount = amount;
      saveRequest.transport = filterData!.transportId!;
      saveRequest.transportName = filterData!.transportName;
      saveRequest.station = filterData!.station;
      saveRequest.lrCase = 0;
      saveRequest.status = '';
      saveRequest.remark = remarkController.text.toString().trim();
      saveRequest.receiveItemDetails = itemList;

      _presenter!.saveReceive(saveRequest);
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
              actionBar(context, 'Receive Entry', true),
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
                            FilterData rData =
                                await Get.toNamed('/all_filter_screen', arguments: [sCompany, 'PrcCompanyBtn'])
                                    as FilterData;
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
                            child: InkWell(
                              onTap: (() {
                                _selectDate(context, false);
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sVoucherNo,
                                  style: blackRegular(),
                                ),
                                verticalView(),
                                textFieldNumber(context, voucherNoController, sVoucherNo, '', false, false),
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
                            child: InkWell(
                              onTap: (() {
                                _selectDate(context, true);
                              }),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sChallanDate,
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
                                        challanDate,
                                        style: challanDate == sChallanDate ? heading1(colorGray) : blackTitle(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          horizontalView(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sChallanNo,
                                  style: blackRegular(),
                                ),
                                verticalView(),
                                textFieldNumber(context, challanNoController, sChallanNo, '', false, true),
                              ],
                            ),
                          ),
                        ],
                      ),
                      verticalView(),
                      Text(
                        sJobber,
                        style: blackRegular(),
                      ),
                      verticalView(),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: (() async {
                                //todo

                                if (itemList.isNotEmpty) {
                                  toastMassage("Please remove selected items before proceeding.");
                                  return;
                                }

                                FilterData rData =
                                    await Get.toNamed('/all_filter_screen', arguments: [sJobber, 'App_ReceivePtyList'])
                                        as FilterData;
                                if (rData != null) {
                                  setState(() {
                                    jobber = rData.name!;
                                    jobberId = rData.id!;

                                    jobberData = rData;
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
                                    jobber,
                                    style: jobber == sJobber ? heading1(colorGray) : blackTitle(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          horizontalViewSmall(),
                          InkWell(
                            onTap: (() async {
                              openScanner();
                            }),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: colorApp.withOpacity(0.2),
                                  border: Border.all(color: colorApp),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  )),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Image.asset(
                                  icScan,
                                  height: 27,
                                  width: 27,
                                  color: colorApp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalView(),
                      Text(
                        sWorkAccount,
                        style: blackRegular(),
                      ),
                      verticalView(),
                      InkWell(
                        onTap: (() async {
                          FilterData rData = await Get.toNamed('/all_filter_screen',
                              arguments: [sWorkAccount, 'App_ReceiveWorkAcList']) as FilterData;
                          if (rData != null) {
                            setState(() {
                              workAccount = rData.name!;
                              workAccountId = rData.id!;
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
                              workAccount,
                              style: workAccount == sWorkAccount ? heading1(colorGray) : blackTitle(),
                            ),
                          ),
                        ),
                      ),
                      verticalView(),
                      Text(
                        sRemark,
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
                            obscureText: false,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: remarkController,
                            autofocus: false,
                            onChanged: (text) {},
                            style: blackTitle(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: sRemark,
                              hintStyle: heading1(colorGray),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              //isDense: true,
                            ),
                          ),
                        ),
                      ),
                      verticalViewBig(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: (() async {
                                //todo change here
                                if (jobberId != 0) {
                                  jobberViseAddItem();
                                } else {
                                  withoutJobberAddItem();
                                }
                              }),
                              child: btnHalf(context, 'Add Item')),
                          horizontalView(),
                          // InkWell(
                          //     onTap: (() async {
                          //       openScanner();
                          //     }),
                          //     child: btnHalf(context, 'Scan QR')),
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
                              decoration: const BoxDecoration(
                                  color: colorOffWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
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
                                                  var returnData = await Get.toNamed('/add_receive_item',
                                                      arguments: [jobberId, filterData, data]) as ReceiveItemDetails;
                                                  if (returnData != null) {
                                                    itemList.removeAt(i);
                                                    itemList.add(returnData);
                                                    setState(() {});
                                                  }
                                                }),
                                                child: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: const BoxDecoration(
                                                      color: colorApp,
                                                      borderRadius: BorderRadius.all(Radius.circular(20))),
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
                                                  decoration: const BoxDecoration(
                                                      color: colorRed,
                                                      borderRadius: BorderRadius.all(Radius.circular(20))),
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
                                          decoration: const BoxDecoration(
                                              color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(3))),
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
                                              Visibility(
                                                  visible: data.takaNo! != 0,
                                                  child:
                                                      const Divider(height: 0.5, thickness: 0.5, color: colorOffWhite)),
                                              Visibility(
                                                visible: data.takaNo! != 0,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      itemDetailsView(
                                                          'Taka No. : ${data.suffix!}${data.takaNo!.toString()}'),
                                                      //itemDetailsView('Unit : ${data.unit}'),
                                                    ],
                                                  ),
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

  Future<void> withoutJobberAddItem() async {
    var data = await Get.toNamed('/add_receive_item_list', arguments: [jobberId, filterData]) as ReceiveItemDetails;
    if (data != null) {
      print(data);

      setState(() {
        // data.jobType = jobType;

        jobber = data.issuer!;
        jobberId = data.accountId!;

        if (jobberData != null) {
          data.rateCateId = jobberData!.rateCateId!;
          data.rateCateName = jobberData!.rateCateName!;
        }

        if (itemList.isNotEmpty) {
          var lastItem = itemList.last;
          if (lastItem.suffix!.isNotEmpty) {
            data.suffix = lastItem.suffix!;
          }

          if (lastItem.takaNo! != 0) {
            data.takaNo = lastItem.takaNo! + 1;
          }
        } else {
          if (jobberData != null) {
            data.suffix = jobberData!.rateCateName!;
            data.takaNo = int.parse(jobberData!.rateCateId!);
          }
        }
        itemList.add(data);
      });
    }
  }

  Future<void> jobberViseAddItem() async {
    var data = await Get.toNamed('/add_receive_item', arguments: [jobberId, filterData]) as ReceiveItemDetails;
    if (data != null) {
      setState(() {
        // data.jobType = jobType;
        if (jobberData != null) {
          data.rateCateId = jobberData!.rateCateId!;
          data.rateCateName = jobberData!.rateCateName!;
        }

        if (itemList.isNotEmpty) {
          var lastItem = itemList.last;
          if (lastItem.suffix!.isNotEmpty) {
            data.suffix = lastItem.suffix!;
          }

          if (lastItem.takaNo! != 0) {
            data.takaNo = lastItem.takaNo! + 1;
          }
        } else {
          data.suffix = jobberData!.rateCateName!;
          data.takaNo = int.parse(jobberData!.rateCateId!);
        }
        itemList.add(data);
      });
    }
  }

  /*openScanner() async {
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
      _presenterItemList!.getReceiveItemDetail(0, '', jobberId, barcodeScanRes, filterData!.id!);
    } else {
      toastMassage('Invalid QR code..!');
    }

    print('Scan result is : $barcodeScanRes');
  }*/

  openScanner() async {
    String barcodeScanRes = '';

    try {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.qr_code_scanner),
                  title: Text('Scan QR Code'),
                  onTap: () async {
                    Navigator.pop(context);
                    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
                    handleScanResult(barcodeScanRes);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Pick from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    barcodeScanRes = await pickQRFromGallery();
                    handleScanResult(barcodeScanRes);
                  },
                ),
              ],
            ),
          );
        },
      );
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  Future<String> pickQRFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return '-1';

    final File file = File(image.path);
    final BarcodeScanner barcodeScanner = BarcodeScanner();
    final InputImage inputImage = InputImage.fromFile(file);

    final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
    await barcodeScanner.close();

    return barcodes.isNotEmpty ? barcodes.first.rawValue ?? '-1' : '-1';
  }

  void handleScanResult(String barcodeScanRes) {
    if (!mounted) {
      toastMassage('Invalid QR code..!');
      return;
    }

    if (barcodeScanRes != '-1') {
      _presenterItemList!.getReceiveItemDetail(0, '', jobberId, barcodeScanRes, filterData!.id!);
    } else {
      toastMassage('Invalid QR code..!');
    }

    print('Scan result is : $barcodeScanRes');
  }

  Widget itemDetailsView(String s) {
    return Expanded(
      child: Text(
        s,
        style: bodyText1(colorText),
      ),
    );
  }

  _selectDate(BuildContext context, bool isChallanDate) async {
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
      if (isChallanDate) {
        challanDate = formatter.format(selected!);
      } else {
        date = formatter.format(selected!);
      }
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
  void onReceiveItemDetailSuccess(ReceiveItemDetailResponse data) {
    print(data);
    if (data.success!) {
      if (data.value != null && data.value!.isNotEmpty) {
        //todo remove after test manageDuplicateItems
        // for (var item in data.value!) {
        //   item.jobType = jobType; // Update jobType
        //   // Remove duplicates based on qualId and qualName
        //   //itemList.removeWhere((m) => m.qualId == item.qualId && m.qualName == item.qualName);
        //   itemList.removeWhere((m) => m.barCode == item.barCode);
        //   itemList.add(item); // Add updated item
        // }

        manageDuplicateItems(context, data);

        if (itemList.isNotEmpty) {
          jobber = itemList[0].issuer!;
          jobberId = itemList[0].accountId!;

          workAccount = itemList[0].refAc!;
          workAccountId = itemList[0].refId!;
        }

        setState(() {});
      }
    } else {
      toastMassage('Invalid QR code..!');
    }
  }

  // Future<void> manageDuplicateItems(BuildContext context, ReceiveItemDetailResponse data) async {
  //   for (var item in data.value!) {
  //     item.jobType = jobType;
  //
  //     int existingItemIndex = itemList.indexWhere((m) => m.barCode == item.barCode);
  //
  //     if (existingItemIndex != -1) {
  //       bool? confirmAddDuplicate = await showDialog<bool>(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (BuildContext dialogContext) {
  //           return Theme(
  //             data: ThemeData.light(), // Force light theme
  //             child: AlertDialog(
  //               title: Text('Duplicate barCode'),
  //               content: Text('An item with the same barCode already exists. Do you want to add the duplicate?'),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(dialogContext).pop(false);
  //                   },
  //                   child: Text('No'),
  //                 ),
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(dialogContext).pop(true);
  //                   },
  //                   child: Text('Yes'),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //
  //       if (confirmAddDuplicate == true) {
  //         itemList.insert(existingItemIndex + 1, item);
  //       }
  //     } else {
  //       itemList.add(item);
  //     }
  //   }
  // }

  Future<void> manageDuplicateItems(BuildContext context, ReceiveItemDetailResponse data) async {
    List<ReceiveItemDetails> newItems = [];
    List<ReceiveItemDetails> duplicateItems = [];

    int checkCounter = 0;

    // 1. Split items into new and duplicate
    for (var item in data.value!) {
      //showLoading();
      item.jobType = jobType;

      bool alreadyExists = itemList.any((existing) => existing.barCode == item.barCode);
      if (alreadyExists) {
        duplicateItems.add(item);
      } else {
        newItems.add(item);
      }

      // checkCounter++;
      // if (checkCounter % 50 == 0) {
      //   await Future.delayed(Duration(milliseconds: 5)); // ✅ delay while checking
      // }
    }

    // 2. Add new items directly
    itemList.addAll(newItems);

    hideLoading();

    // 3. Ask once if user wants to add duplicates
    if (duplicateItems.isNotEmpty) {
      bool? confirmAddDuplicates = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return Theme(
            data: ThemeData.light(),
            child: AlertDialog(
              title: Text('Duplicate Items'),
              content: Text(
                '${duplicateItems.length} item(s) with duplicate barCodes found. Do you want to add them anyway?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text('Yes'),
                ),
              ],
            ),
          );
        },
      );

      // 4. Add duplicates only if confirmed
      if (confirmAddDuplicates == true) {
        showLoading();
        int insertCounter = 0;
        for (var dup in duplicateItems) {
          itemList.add(dup);
          insertCounter++;
          if (insertCounter % 50 == 0) {
            await Future.delayed(Duration(milliseconds: 15)); // ✅ delay while inserting
          }
        }
        hideLoading();
      }
    }
    setState(() {});
  }

  showLoading() {
    EasyLoading.instance.userInteractions = true;
    EasyLoading.instance.dismissOnTap = true;
    EasyLoading.show(status: 'loading...');
  }

  hideLoading() {
    EasyLoading.dismiss();
  }
}
