import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:td/common/check_response_code.dart';
import 'package:td/model/common_response.dart';
import 'package:td/model/invoice_response.dart';

import '../model/extra_ctrl_config_response.dart';
import '../model/filter_response.dart';
import '../model/login_response.dart';
import '../model/order_item_detail.dart';
import '../model/order_list_response.dart';
import '../model/save_order_request.dart';
import '../presenter/save_order_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/preference.dart';
import '../utils/string.dart';
import '../utils/widget.dart';
import '../utils/widget.dart';

class AddOrder extends StatefulWidget {
  const AddOrder({super.key});

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> implements SaveOrderView {
  TextEditingController baleController = TextEditingController();
  TextEditingController orderNoController = TextEditingController();
  TextEditingController dueDaysController = TextEditingController();
  TextEditingController voucherNoController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  List<File> attachmentList = [];

  List<OrderItemDetail> orderItemList = [];

  SaveOrderPresenter? _presenter;

  ExtraCtrlConfigData? _extraCtrlConfigData;

  String supplierLabel = sSupplier;
  String supplier = sSupplier;
  String customer = sCustomer;
  String transport = sTransport;
  String station = sStation;
  String company = sCompany;

  // String bale = sBale;

  int sOrdTrnId = 0;
  int supplierId = 0;
  int customerId = 0;
  int transportId = 0;
  int itemId = 0;
  int companyId = 0;

  int agentId = 0;
  int hasteId = 0;

  String newVarNo = '';
  int newTypeId = 0;
  int dueDays = 0;
  OrderListData? orderListData;
  String date = sDate;
  var formatter = DateFormat('dd/MM/yyyy');
  bool isEdit = false;

  _AddOrderState() {
    _presenter = SaveOrderPresenter(this);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var lData = LoginResponse.fromJson(jsonDecode(PreferenceData.getUserInfo()));
    companyId = lData.value!.companyId!;
    company = lData.value!.companyName!;

    _presenter!.getExtraCtrlConfig();

    date = formatter.format(DateTime.now());

    var a = Get.arguments as List;

    newVarNo = a[0];
    newTypeId = a[1];
    dueDays = a[2];
    supplierLabel = a[3];
    if (a.length > 4) {
      orderListData = a[4];
    }

    supplier = supplierLabel;

    voucherNoController.text = newVarNo;
    orderNoController.text = newVarNo;
    dueDaysController.text = dueDays.toString();

    setEditData();
  }

  setEditData() {
    if (orderListData != null) {
      isEdit = true;
      try {
        date = formatter.format(DateTime.parse(orderListData!.date!));
      } catch (e) {
        date = formatter.format(DateTime.now());
      }
      sOrdTrnId = orderListData!.sordTrnId!;
      orderNoController.text = orderListData!.orderNo!.toString();
      voucherNoController.text = orderListData!.vno!.toString();
      dueDaysController.text = orderListData!.dueDays!.toString();
      remarkController.text = orderListData!.remark!.toString();

      companyId = orderListData!.conum!;
      company = orderListData!.companyName!;

      newTypeId = orderListData!.newTypeId!;
      supplierLabel = orderListData!.labelSupplier!;
      supplier = orderListData!.supplier!;
      supplierId = orderListData!.refId!;
      customer = orderListData!.customer!;
      customerId = orderListData!.accountId!;

      agentId = orderListData!.agentId!;
      hasteId = orderListData!.hasteId!;

      transport = orderListData!.transportName!;
      transportId = orderListData!.transport!;

      station = orderListData!.station!;
      //stationId

      baleController.text = orderListData!.bale!;

      var oList = orderListData!.orderItemDetails!;

      for (int i = 0; i < oList.length; i++) {
        var oid = OrderItemDetail();
        oid.Amt = oList[i].amt!;
        oid.bale = oList[i].bale!;
        oid.color = oList[i].color!;
        oid.Mtr = oList[i].mtr!;
        oid.Pcs = oList[i].pcs!.round();
        oid.QualId = oList[i].qualId!;
        oid.QualName = oList[i].qualName!;
        oid.Rate = oList[i].rate!;
        oid.Rmk = oList[i].rmk!;
        oid.sets = oList[i].sets!;
        oid.Unit = oList[i].unit!;
        oid.ImageList = oList[i].imageList!;
        oid.CateId = oList[i].cateId!;
        oid.Cut = oList[i].cut!;
        oid.PkgType = oList[i].pkgType!;
        oid.ctrlNum1 = oList[i].ctrlNum1!;
        oid.ctrlNum2 = oList[i].ctrlNum2!;
        oid.ctrlStr1 = oList[i].ctrlStr1!;
        oid.ctrlStr2 = oList[i].ctrlStr2!;
        oid.ctrlLstId1 = oList[i].ctrlLstId1!;
        oid.ctrlLstVal1 = oList[i].ctrlLstVal1!;
        oid.ctrlLstId2 = oList[i].ctrlLstId2!;
        oid.ctrlLstVal2 = oList[i].ctrlLstVal2!;

        orderItemList.add(oid);
      }
    }
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

  Future<void> clickOnSaveOrder() async {
    if (supplier == sSupplier) {
      toastMassage('Please select supplier');
      return;
    }

    if (customer == sCustomer) {
      toastMassage('Please select customer');
      return;
    }

    attachmentList = [];
    var grossAmt = 0.0;
    var tPcs = 0;
    if (orderItemList.isNotEmpty) {
      for (int i = 0; i < orderItemList.length; i++) {
        grossAmt += orderItemList[i].Pcs! * orderItemList[i].Rate!;
        tPcs += orderItemList[i].Pcs!;

        if (orderItemList[i].ImageFile != null) {
          try {
            // var renameFile = await changeFileNameOnly(File(orderItemList[i].ImageFile!.path), (i+1).toString()+'.jpg');
            // orderItemList[i].ImageFile = XFile(renameFile.path);
            // print(renameFile);
            // attachmentList.add(renameFile);
            attachmentList.add(File(orderItemList[i].ImageFile!.path));
          } on Exception catch (error) {
            print(error);
          }
        }
      }
    }

    var bale = '0';
    if (baleController.text.toString().trim().isNotEmpty) {
      bale = baleController.text.toString().trim();
    }

    var vNo = 0;
    try {
      if (voucherNoController.text.toString().trim().isNotEmpty) {
        vNo = int.parse(voucherNoController.text.toString().trim());
      }
    } catch (e) {
      print(e);
    }

    var orderNo = 0;
    try {
      if (orderNoController.text.toString().trim().isNotEmpty) {
        orderNo = int.parse(orderNoController.text.toString().trim());
      }
    } catch (e) {
      print(e);
    }

    var dueDays = 0;
    try {
      if (dueDaysController.text.toString().trim().isNotEmpty) {
        dueDays = int.parse(dueDaysController.text.toString().trim());
      }
    } catch (e) {
      print(e);
    }

    var remark = remarkController.text.toString().trim();
    var saveOrderRequest = SaveOrderRequest(sOrdTrnId, companyId, newTypeId, 'Sale Order', vNo, date, orderNo, dueDays, customerId, agentId, hasteId,
        grossAmt, bale, orderItemList, supplierId, station.trim(), remark, 0, tPcs, transportId);

    _presenter!.saveOrder(saveOrderRequest);
    // await Future.delayed(Duration(seconds: 3));
    // _presenter!.saveOrderFile(saveOrderRequest, attachmentList, date, orderNoController.text);
  }

  Future<File> changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorWhite,
          body: Column(
            children: [
              actionBar(context, 'Order', true),
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
                            FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sCompany, 'App_OrdEntryCompList']) as FilterData;
                            if (rData != null) {
                              setState(() {
                                company = rData.name!;
                                companyId = rData.id!;
                                orderNoController.text = rData.line3!;
                                voucherNoController.text = rData.line3!;
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sDate,
                                  style: blackRegular(),
                                ),
                                verticalView(),
                                InkWell(
                                  onTap: (() {
                                    _selectDate(context);
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
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        date,
                                        style: date == sDate ? heading1(colorGray) : blackTitle(),
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
                      verticalViewBig(),

                      Row(
                        children: [
                          // horizontalView(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sOrderNo,
                                  style: blackRegular(),
                                ),
                                verticalView(),
                                textFieldNumber(context, orderNoController, sOrderNo, '', false, true),
                              ],
                            ),
                          ),
                          horizontalView(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sDueDays,
                                  style: blackRegular(),
                                ),
                                verticalView(),
                                textFieldNumber(context, dueDaysController, sDueDays, '', false, true),
                              ],
                            ),
                          ),
                        ],
                      ),
                      verticalViewBig(),

                      Text(
                        sCustomer,
                        style: blackRegular(),
                      ),
                      verticalView(),
                      InkWell(
                        onTap: (() async {
                          FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sCustomer, 'PrcCustomerBtn']) as FilterData;
                          if (rData != null) {
                            setState(() {
                              customer = rData.name!;
                              customerId = rData.id!;

                              transport = rData.transportName!;
                              transportId = rData.transportId!;

                              station = rData.station!;
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
                              customer,
                              style: customer == sCustomer ? heading1(colorGray) : blackTitle(),
                            ),
                          ),
                        ),
                      ),
                      verticalViewBig(),
                      Text(
                        supplierLabel,
                        style: blackRegular(),
                      ),
                      verticalView(),
                      InkWell(
                        onTap: (() async {
                          FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [supplierLabel, 'AppPrcOrdSupplierList']) as FilterData;
                          if (rData != null) {
                            setState(() {
                              supplier = rData.name!;
                              supplierId = rData.id!;
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
                              supplier,
                              style: supplier == supplierLabel ? heading1(colorGray) : blackTitle(),
                            ),
                          ),
                        ),
                      ),
                      verticalViewBig(),
                      Text(
                        sTransport,
                        style: blackRegular(),
                      ),
                      verticalView(),
                      InkWell(
                        onTap: (() async {
                          FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sTransport, 'PrcGetTransport']) as FilterData;
                          if (rData != null) {
                            setState(() {
                              transport = rData.name!;
                              transportId = rData.id!;
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
                              transport,
                              style: transport == sTransport ? heading1(colorGray) : blackTitle(),
                            ),
                          ),
                        ),
                      ),
                      verticalViewBig(),

                      Row(
                        children: [
                          // horizontalView(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sStation,
                                  style: blackRegular(),
                                ),
                                verticalView(),
                                InkWell(
                                  onTap: (() async {
                                    FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [sStation, 'PrcGetStation']) as FilterData;
                                    if (rData != null) {
                                      setState(() {
                                        station = rData.name!;
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
                                        station,
                                        style: station == sStation ? heading1(colorGray) : blackTitle(),
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
                                  sBale,
                                  style: blackRegular(),
                                ),
                                verticalView(),
                                textFieldNumber(context, baleController, sBale, '', false, true),
                              ],
                            ),
                          ),
                        ],
                      ),
                      verticalViewBig(),

                      Text(
                        sRemark,
                        style: blackRegular(),
                      ),
                      verticalView(),
                      textField(context, remarkController, sRemark, '', false, true),
                      verticalViewBig(),

                      Visibility(
                        visible: orderItemList.length > 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sItem,
                              style: blackRegular(),
                            ),
                            verticalView(),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: orderItemList == null ? 0 : orderItemList.length,
                                itemBuilder: (BuildContext context, i) {
                                  var data = orderItemList[i];
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: colorOffWhite,
                                            // border: Border.all(color: colorGray),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          child: Row(
                                            children: [
                                              data.ImageList!.isNotEmpty
                                                  ? FadeInImage.assetNetwork(
                                                      placeholder: appIcon,
                                                      image: data.ImageList!,
                                                      fit: BoxFit.cover,
                                                      width: 70,
                                                      height: 70,
                                                      imageErrorBuilder: (context, error, stackTrace) {
                                                        return const SizedBox();
                                                      },
                                                    )
                                                  : data.ImageFile != null
                                                      ? Image.file(
                                                          File(data.ImageFile!.path),
                                                          width: 70,
                                                          height: 70,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Container(color: colorApp.withOpacity(0.1), height: 70, width: 70),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.QualName.toString(),
                                                      style: heading2(colorApp),
                                                    ),
                                                    Text(
                                                      '$sPcs : ${data.Pcs}',
                                                      style: bodyText1(colorText),
                                                    ),
                                                    Text(
                                                      '$sRate : ${data.Rate}',
                                                      style: bodyText1(colorText),
                                                    ),
                                                    Text(
                                                      '$sAmount : ${data.Amt}',
                                                      style: bodyText1(colorText),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: (() async {
                                                  var returnData = await Get.toNamed('/add_order_item', arguments: [_extraCtrlConfigData, data]) as OrderItemDetail;
                                                  if (returnData != null) {
                                                    orderItemList.removeAt(i);
                                                    orderItemList.add(returnData);
                                                    setState(() {});
                                                  }
                                                }),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
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
                                              SizedBox(width: 10),
                                              InkWell(
                                                onTap: (() {
                                                  setState(() {
                                                    orderItemList.removeAt(i);
                                                  });
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
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      )
                                    ],
                                  );
                                }),
                          ],
                        ),
                      ),
                      // verticalViewBig(),
                    ],
                  ),
                ),
              )),
              Container(
                decoration: BoxDecoration(
                  color: colorWhite,
                  boxShadow: [
                    // so here your custom shadow goes:
                    BoxShadow(
                      color: Colors.black.withAlpha(20), // the color of a shadow, you can adjust it
                      spreadRadius: 3, //also play with this two values to achieve your ideal result
                      blurRadius: 7,
                      offset: Offset(0, -7), // changes position of shadow, negative value on y-axis makes it appering only on the top of a container
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (() async {
                            // _showItemOrderDialog();

                            var itemList = await Get.toNamed('/add_order_item', arguments: [_extraCtrlConfigData]) as List<OrderItemDetail>;
                            if (itemList != null) {
                              if (itemList.length > 0) {
                                setState(() {
                                  orderItemList.addAll(itemList);
                                });
                              }
                            }
                          }),
                          child: Container(
                            // width: MediaQuery.of(context).size.width / 2.1,
                            decoration: BoxDecoration(
                                border: Border.all(color: colorApp),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                )),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    icPlus,
                                    height: 15,
                                    width: 15,
                                    color: colorApp,
                                  ),
                                  horizontalView(),
                                  const Text(
                                    'Add Item',
                                    style: TextStyle(fontSize: 18, fontFamily: "Medium", color: colorApp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                            onTap: (() {
                              if (isAvoidDoubleClick()) {
                                clickOnSaveOrder();
                              }
                            }),
                            child: Container(
                              // width: MediaQuery.of(context).size.width / 2.1,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                    colorGradient1,
                                    colorGradient2,
                                    //colorWhite,
                                  ]),
                                  border: Border.all(color: colorApp),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  )),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      icSave,
                                      height: 15,
                                      width: 15,
                                      color: colorWhite,
                                    ),
                                    horizontalView(),
                                    const Text(
                                      'Save Order',
                                      style: TextStyle(fontSize: 18, fontFamily: "Medium", color: colorWhite),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
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
    CheckResponseCode.getResponseCode(errorCode, context);
  }

  @override
  void onOrderSaveSuccess(CommonResponse data) {
    if (data.success!) {
      toastMassage('Success');
      Get.back(result: true);
    } else {
      toastMassage(data.resultMessage!);
    }
  }


  @override
  void onExtraCtrlConfigSuccess(ExtraCtrlConfigResponse data) {
    if (data != null) {
      if (data.value != null) {
        _extraCtrlConfigData = data.value!;
      }
    }
  }

}
