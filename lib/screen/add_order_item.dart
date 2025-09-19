import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:td/presenter/add_order_item_presenter.dart';

import '../common/check_response_code.dart';
import '../common/utils.dart';
import '../model/extra_ctrl_config_response.dart';
import '../model/filter_response.dart';
import '../model/login_response.dart';
import '../model/order_item_detail.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/preference.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class AddOrderItem extends StatefulWidget {
  const AddOrderItem({super.key});

  @override
  State<AddOrderItem> createState() => _AddOrderItemState();
}

class _AddOrderItemState extends State<AddOrderItem> implements AddOrderItemView {
  TextEditingController itemController = TextEditingController();
  TextEditingController pcsController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController cutController = TextEditingController();
  TextEditingController mtrController = TextEditingController();

  TextEditingController ctrlNum1Controller = TextEditingController();
  TextEditingController ctrlNum2Controller = TextEditingController();
  TextEditingController ctrlStr1Controller = TextEditingController();
  TextEditingController ctrlStr2Controller = TextEditingController();
  TextEditingController ctrlLst1Controller = TextEditingController();
  TextEditingController ctrLst2Controller = TextEditingController();
  TextEditingController ctrlpkgTypeController = TextEditingController();

  int supplierId = 0;
  int customerId = 0;
  int transportId = 0;
  int stationId = 0;
  int itemId = 0;

  var itemRate = 0.0;

  String ctrlNum1 = '';
  String ctrlNum2 = '';
  String ctrlStr1 = '';
  String ctrlStr2 = '';
  String ctrlLst1Title = '';
  String ctrlLst1PRC = '';
  String ctrlLst2Title = '';
  String ctrlLst2PRC = '';

  String ctrlLstId1 = '';
  String ctrlLstId2 = '';
  String ctrlpkgTypeId = '';
  String ctrlpkgTypeTitle = '';
  String ctrlpkgTypePRC = '';

  String quantity = sQuantity;

  bool isEdit = false;
  String imageUrl = '';

  XFile? selectedImageFile;
  AddOrderItemPresenter? _presenter;

  List<OrderItemDetail> orderItemList = [];
  OrderItemDetail? _orderItemDetail;

  ExtraCtrlConfigData? _extraCtrlConfigData;

  _AddOrderItemState() {
    _presenter = AddOrderItemPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    var a = Get.arguments as List;
    _extraCtrlConfigData = a[0];
    initExtraConfig();

    if (a.length > 1) {
      _orderItemDetail = a[1];
      firstLoad();
    }
  }

  initExtraConfig() {
    ctrlNum1 = _extraCtrlConfigData!.ctrlNum1!;
    ctrlNum2 = _extraCtrlConfigData!.ctrlNum2!;
    ctrlStr1 = _extraCtrlConfigData!.ctrlStr1!;
    ctrlStr2 = _extraCtrlConfigData!.ctrlStr2!;

    var ctrlLst1 = _extraCtrlConfigData!.ctrlLst1!;
    if (ctrlLst1.isNotEmpty) {
      ctrlLst1PRC = ctrlLst1.split(';')[0];
      ctrlLst1Title = ctrlLst1.split(';')[1];
    }

    var ctrlLst2 = _extraCtrlConfigData!.ctrlLst2!;
    if (ctrlLst2.isNotEmpty) {
      ctrlLst2PRC = ctrlLst2.split(';')[0];
      ctrlLst2Title = ctrlLst2.split(';')[1];
    }

    var ctrlpkgType = _extraCtrlConfigData!.ctrlpkgType!;
    if (ctrlpkgType.isNotEmpty) {
      ctrlpkgTypePRC = ctrlpkgType.split(';')[0];
      ctrlpkgTypeTitle = ctrlpkgType.split(';')[1];
    }
  }

  firstLoad() {
    if (_orderItemDetail != null) {
      isEdit = true;
      itemId = _orderItemDetail!.QualId!;
      itemController.text = _orderItemDetail!.QualName!;
      unitController.text = _orderItemDetail!.Unit!;
      cutController.text = _orderItemDetail!.Cut!.toString();
      mtrController.text = _orderItemDetail!.Mtr!.toString();
      pcsController.text = _orderItemDetail!.Pcs!.toString();
      rateController.text = _orderItemDetail!.Rate!.toString();
      remarkController.text = _orderItemDetail!.Rmk!.toString();
      amountController.text = _orderItemDetail!.Amt!.toString();

      // ctrlNum1 = _orderItemDetail!.ctrlNum1 ?? '';
      // ctrlNum2 = _orderItemDetail!.ctrlNum2 ?? '';
      // ctrlStr1 = _orderItemDetail!.ctrlStr1 ?? '';
      // ctrlStr2 = _orderItemDetail!.ctrlStr2 ?? '';
      // ctrlLst1Title = _orderItemDetail!.ctrlLstVal1 ?? '';
      // ctrlLst1PRC
      // ctrlLst2Title = _orderItemDetail!.ctrlLstVal2 ?? '';
      // ctrlLst2PRC

      ctrlLstId1 = _orderItemDetail!.ctrlLstId1 ?? '';
      ctrlLstId2 = _orderItemDetail!.ctrlLstId2 ?? '';

      ctrlNum1Controller.text = _orderItemDetail!.ctrlNum1 ?? '';
      ctrlNum2Controller.text = _orderItemDetail!.ctrlNum2 ?? '';
      ctrlStr1Controller.text = _orderItemDetail!.ctrlStr1 ?? '';
      ctrlStr2Controller.text = _orderItemDetail!.ctrlStr2 ?? '';
      ctrlLst1Controller.text = _orderItemDetail!.ctrlLstVal1 ?? '';
      ctrLst2Controller.text = _orderItemDetail!.ctrlLstVal2 ?? '';
      ctrlpkgTypeController.text = _orderItemDetail!.PkgType ?? '';

      imageUrl = _orderItemDetail!.ImageList!;
    }
  }

  void onClickSave(bool isMore) {
    if (itemController.text.isEmpty) {
      toastMassage('Please select item first');
      return;
    }
    if (unitController.text.isEmpty) {
      toastMassage('Please select unit');
      return;
    }
    if (pcsController.text.isEmpty) {
      toastMassage('Please enter pcs');
      return;
    }
    if (rateController.text.isEmpty) {
      toastMassage('Please enter rate');
      return;
    }

    var cut = 0.0;
    try {
      cut = double.parse(cutController.text);
    } catch (e) {
      print(e);
    }

    var meter = 0.0;
    try {
      meter = double.parse(mtrController.text);
    } catch (e) {
      print(e);
    }

    var orderItemDetail = OrderItemDetail();
    orderItemDetail.Amt = double.parse(amountController.text);
    orderItemDetail.bale = 0;
    orderItemDetail.color = '';
    orderItemDetail.Mtr = meter;
    orderItemDetail.Pcs = int.parse(pcsController.text);
    orderItemDetail.QualId = itemId;
    orderItemDetail.QualName = itemController.text;
    orderItemDetail.Rate = double.parse(rateController.text);
    orderItemDetail.Rmk = remarkController.text;
    orderItemDetail.sets = 0;
    orderItemDetail.Unit = unitController.text;
    orderItemDetail.CateId = 0;
    orderItemDetail.Cut = cut;
    orderItemDetail.PkgType = ctrlpkgTypeController.text.toString().trim();
    orderItemDetail.ctrlNum1 = ctrlNum1Controller.text.toString().trim();
    orderItemDetail.ctrlNum2 = ctrlNum2Controller.text.toString().trim();
    orderItemDetail.ctrlStr1 = ctrlStr1Controller.text.toString().trim();
    orderItemDetail.ctrlStr2 = ctrlStr2Controller.text.toString().trim();
    orderItemDetail.ctrlLstId1 = ctrlLstId1;
    orderItemDetail.ctrlLstVal1 = ctrlLst1Controller.text.toString().trim();
    orderItemDetail.ctrlLstId2 = ctrlLstId2;
    orderItemDetail.ctrlLstVal2 = ctrLst2Controller.text.toString().trim();
    // orderItemDetail.ctrlpkgType = ctrlpkgTypeController.text.toString().trim();
    orderItemDetail.ImageList = '';
    orderItemDetail.ImageFile = selectedImageFile;

    orderItemList.add(orderItemDetail);

    itemController.text = '';
    pcsController.text = '';
    rateController.text = '';
    remarkController.text = '';
    amountController.text = '';
    selectedImageFile = null;

    toastMassage('Item added successfully');

    if (isEdit) {
      Get.back(result: orderItemDetail);
    } else {
      if (!isMore) {
        Get.back(result: orderItemList);
      }
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
                actionBar(context, 'Add Order Item', true),
                Expanded(
                    child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sItem,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                  onTap: (() async {
                                    FilterData rData =
                                        await Get.toNamed('/all_filter_screen', arguments: [sItem, 'PrcFinishQualityBtn', true]) as FilterData;
                                    if (rData != null) {
                                      setState(() {
                                        itemController.text = rData.name!;
                                        itemId = rData.id!;
                                        unitController.text = rData.line1!;
                                        cutController.text = rData.line2!;
                                        rateController.text = rData.line3!;
                                        try {
                                          itemRate = double.parse(rData.line3!);
                                        } catch (e) {
                                          print(e);
                                        }
                                        ctrlpkgTypeController.text = '';
                                        ctrlpkgTypeId = '';
                                      });
                                    }
                                  }),
                                  child: textField(context, itemController, sItem, '', false, false)),
                            ),
                            horizontalView(),
                            InkWell(
                              onTap: (() {
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
                        verticalViewBig(),

                        ctrlLst1View(),
                        ctrlLst2View(),
                        ctrlpkgTypeView(),

                        Row(
                          children: [
                            // horizontalView(),
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
                                            await Get.toNamed('/all_filter_screen', arguments: [sUnit, 'App_QualUnitList']) as FilterData;
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
                                        keyboardType: TextInputType.number,
                                        obscureText: false,
                                        textAlign: TextAlign.left,
                                        controller: pcsController,
                                        autofocus: false,
                                        onChanged: (text) {
                                          var rate = rateController.text.toString().trim();
                                          var amount = 0.0;
                                          if (text.isNotEmpty && rate.isNotEmpty) {
                                            amount = int.parse(text) * double.parse(rate);
                                          }
                                          setState(() {
                                            amountController.text = amount.toString();
                                          });
                                        },
                                        style: blackTitle(),
                                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: sPcs,
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
                        verticalViewBig(),
                        Row(
                          children: [
                            // horizontalView(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sCut,
                                    style: blackRegular(),
                                  ),
                                  verticalView(),
                                  textFieldNumber(context, cutController, sCut, '', false, true),
                                ],
                              ),
                            ),
                            horizontalView(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sMeter,
                                    style: blackRegular(),
                                  ),
                                  verticalView(),
                                  textFieldNumber(context, mtrController, sMeter, '', false, true),
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
                                          var pcs = pcsController.text.toString().trim();
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

                        verticalViewBig(),

                        Row(
                          children: [
                            ctrlNum1View(),
                            horizontalView(),
                            ctrlNum2View(),
                          ],
                        ),
                        Row(
                          children: [
                            ctrlStr1View(),
                            horizontalView(),
                            ctrlStr2View(),
                          ],
                        ),

                        Text(
                          sRemark,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        textField(context, remarkController, sRemark, '', false, true),
                        verticalView(),
                        //todo image remove
                        // Text(
                        //   'Attachment',
                        //   style: blackRegular(),
                        // ),
                        // verticalView(),
                        //
                        // imageUrl.isNotEmpty
                        //     ? Center(
                        //         child: FadeInImage.assetNetwork(
                        //           placeholder: appIcon,
                        //           image: imageUrl,
                        //           fit: BoxFit.cover,
                        //           width: 180,
                        //           height: 180,
                        //           imageErrorBuilder: (context, error, stackTrace) {
                        //             return const SizedBox();
                        //           },
                        //         ),
                        //       )
                        //     : selectedImageFile != null
                        //         ? Center(
                        //             child: Container(
                        //               // margin: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                        //               // width: 180,
                        //               // height: 180,
                        //               foregroundDecoration:
                        //                   BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: colorApp, width: 1.0)),
                        //               child: ClipRRect(
                        //                 borderRadius: BorderRadius.circular(10),
                        //                 child: Stack(
                        //                   children: [
                        //                     Image.file(
                        //                       File(selectedImageFile!.path),
                        //                       width: 180,
                        //                       height: 180,
                        //                       fit: BoxFit.cover,
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           )
                        //         : const SizedBox(),

                        // verticalView(),
                        //
                        // InkWell(
                        //   onTap: (() {
                        //     imageUrl = '';
                        //     _imageBottomSheet();
                        //   }),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color: colorApp.withOpacity(0.2),
                        //         border: Border.all(color: colorApp),
                        //         borderRadius: const BorderRadius.all(
                        //           Radius.circular(5),
                        //         )),
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           const Icon(Icons.add_box, color: colorApp),
                        //           const SizedBox(width: 5),
                        //           Text(
                        //             'ADD AN ATTACHMENT',
                        //             style: bodyText1(colorApp),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        //---------------------------------------

                        // Container(
                        //   decoration: BoxDecoration(
                        //       color: colorApp.withOpacity(0.2),
                        //       border: Border.all(color: colorApp),
                        //       borderRadius: const BorderRadius.all(
                        //         Radius.circular(5),
                        //       )),
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 10, right: 10),
                        //     child: Row(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         /*SizedBox(
                        //             height: 5,
                        //           ),*/
                        //
                        //         selectedImageFile != null
                        //             ? Stack(
                        //                 children: [
                        //                   Container(
                        //                     margin: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                        //                     width: 50,
                        //                     height: 50,
                        //                     foregroundDecoration:
                        //                         BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: colorApp, width: 1.0)),
                        //                     child: ClipRRect(
                        //                       borderRadius: BorderRadius.circular(10),
                        //                       child: Stack(
                        //                         children: [
                        //                           Image.file(
                        //                             File(selectedImageFile!.path),
                        //                             // width: imgWidth,
                        //                             // height: imgHeight,
                        //                             //fit: BoxFit.cover,
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               )
                        //             : const SizedBox(),
                        //         InkWell(
                        //           onTap: (() {
                        //             _imageBottomSheet();
                        //           }),
                        //           child: Container(
                        //             // margin: EdgeInsets.all(5),
                        //             // decoration: const BoxDecoration(
                        //             //     color: colorBox1,
                        //             //     borderRadius: BorderRadius.all(
                        //             //       Radius.circular(10),
                        //             //     )),
                        //             child: Padding(
                        //               padding: const EdgeInsets.all(10),
                        //               child: Image.asset(icAttach, height: 15, width: 15),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        verticalViewBig(),

                        isEdit
                            ? InkWell(
                                onTap: (() {
                                  onClickSave(false);
                                }),
                                child: btnHalf(context, 'Update'))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: (() {
                                        onClickSave(false);
                                      }),
                                      child: btnHalf(context, 'Save')),
                                  const SizedBox(width: 10),
                                  InkWell(
                                      onTap: (() {
                                        onClickSave(true);
                                      }),
                                      child: btnHalf(context, 'Save More')),
                                ],
                              ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: ElevatedButton(
                        //         onPressed: () {
                        //           onClickSave(false);
                        //         },
                        //         style: ElevatedButton.styleFrom(elevation: 6.0, backgroundColor: colorApp, textStyle: const TextStyle(color: colorWhite)),
                        //         child: const Text('Save', style: TextStyle(color: colorWhite)),
                        //       ),
                        //     ),
                        //     const SizedBox(width: 10),
                        //     Expanded(
                        //       child: ElevatedButton(
                        //         onPressed: () {
                        //           onClickSave(true);
                        //         },
                        //         style: ElevatedButton.styleFrom(elevation: 6.0, backgroundColor: colorApp, textStyle: const TextStyle(color: colorWhite)),
                        //         child: const Text('Save More', style: TextStyle(color: colorWhite)),
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ))
              ],
            )),
      ),
    );
  }

  openScanner() async {
    String barcodeScanRes = '';
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    if (barcodeScanRes != '-1') {
      _presenter!.reportByFilter('PrcFinishQualityBtn', 0, barcodeScanRes);
    }

    print('Scan result is : $barcodeScanRes');
  }

  void _imageBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text("Camera"),
                  onTap: (() {
                    cameraConnect();
                    Navigator.pop(context);
                  }),
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text("File Manager"),
                  onTap: (() {
                    getImageFromGallery();
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          );
        });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Directory? extDir = await getExternalStorageDirectory();
      // final String dirPath = extDir!.path.toString().substring(0,20);
      final String dirPath = extDir!.path.toString();
      await Directory(dirPath).create(recursive: true);
      final File newImage = await File(image.path).copy('$dirPath/${DateTime.now()}.jpg');

      setState(() {
        selectedImageFile = XFile(newImage.path);
      });
    }
  }

  //connect camera
  cameraConnect() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedImageFile = image;
      });
    }
  }

  Widget ctrlNum1View() {
    return Visibility(
      visible: ctrlNum1.isNotEmpty,
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ctrlNum1,
              style: blackRegular(),
            ),
            verticalView(),
            textFieldNumber(context, ctrlNum1Controller, ctrlNum1, '', false, true),
            verticalViewBig(),
          ],
        ),
      ),
    );
  }

  Widget ctrlNum2View() {
    return Visibility(
      visible: ctrlNum2.isNotEmpty,
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ctrlNum2,
              style: blackRegular(),
            ),
            verticalView(),
            textFieldNumber(context, ctrlNum2Controller, ctrlNum2, '', false, true),
            verticalViewBig(),
          ],
        ),
      ),
    );
  }

  Widget ctrlStr1View() {
    return Visibility(
      visible: ctrlStr1.isNotEmpty,
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ctrlStr1,
              style: blackRegular(),
            ),
            verticalView(),
            textField(context, ctrlStr1Controller, ctrlStr1, '', false, true),
            verticalViewBig(),
          ],
        ),
      ),
    );
  }

  Widget ctrlStr2View() {
    return Visibility(
      visible: ctrlStr2.isNotEmpty,
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ctrlStr2,
              style: blackRegular(),
            ),
            verticalView(),
            textField(context, ctrlStr2Controller, ctrlStr2, '', false, true),
            verticalViewBig(),
          ],
        ),
      ),
    );
  }

  Widget ctrlLst1View() {
    return Visibility(
      visible: ctrlLst1PRC.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ctrlLst1Title,
            style: blackRegular(),
          ),
          verticalView(),
          InkWell(
              onTap: (() async {
                FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [ctrlLst1Title, ctrlLst1PRC, true]) as FilterData;
                if (rData != null) {
                  setState(() {
                    ctrlLst1Controller.text = rData.name!;
                    ctrlLstId1 = rData.id!.toString();
                  });
                }
              }),
              child: textField(context, ctrlLst1Controller, ctrlLst1Title, '', false, false)),
          verticalViewBig(),
        ],
      ),
    );
  }

  Widget ctrlLst2View() {
    return Visibility(
      visible: ctrlLst2PRC.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ctrlLst2Title,
            style: blackRegular(),
          ),
          verticalView(),
          InkWell(
              onTap: (() async {
                FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [ctrlLst2Title, ctrlLst2PRC]) as FilterData;
                if (rData != null) {
                  setState(() {
                    ctrLst2Controller.text = rData.name!;
                    ctrlLstId2 = rData.id!.toString();
                  });
                }
              }),
              child: textField(context, ctrLst2Controller, ctrlLst2Title, '', false, false)),
          verticalViewBig(),
        ],
      ),
    );
  }

  Widget ctrlpkgTypeView() {
    return Visibility(
      visible: ctrlpkgTypePRC.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ctrlpkgTypeTitle,
            style: blackRegular(),
          ),
          verticalView(),
          InkWell(
              onTap: (() async {
                FilterData rData = await Get.toNamed('/all_filter_screen', arguments: [ctrlpkgTypeTitle, ctrlpkgTypePRC]) as FilterData;
                if (rData != null) {
                  setState(() {
                    ctrlpkgTypeController.text = rData.name!;
                    ctrlpkgTypeId = rData.id!.toString();
                    try {
                      var r = itemRate + double.parse(rData.line3!);
                      rateController.text = r.toString();
                    } catch (e) {
                      toastMassage('Invalid ctrlpkgType rate');
                    }
                  });
                }
              }),
              child: textField(context, ctrlpkgTypeController, ctrlpkgTypeTitle, '', false, false)),
          verticalViewBig(),
        ],
      ),
    );
  }

  @override
  void onGetFilterSuccess(FilterResponse data) {
    if (data.success!) {
      var newList = data.value!;

      if (data.value!.length > 0) {
        setState(() {
          itemController.text = data.value![0].name!;
          itemId = data.value![0].id!;
          unitController.text = data.value![0].line1!;
          cutController.text = data.value![0].line2!;
          rateController.text = data.value![0].line3!;
          try {
            itemRate = double.parse(data.value![0].line3!);
          } catch (e) {
            print(e);
          }
          ctrlpkgTypeController.text = '';
          ctrlpkgTypeId = '';
        });
      } else {
        toastMassage('Invalid QR code');
      }
    } else {
      toastMassage(data.resultMessage!);
    }
  }

  @override
  void onError(int errorCode) {
    CheckResponseCode.getResponseCode(errorCode, context);
  }
}
