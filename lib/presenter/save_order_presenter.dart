import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:td/model/save_order_request.dart';

import 'package:http/http.dart' as http;
import '../api/constant.dart';
import '../api/rest_ds.dart';
import '../model/common_response.dart';
import '../model/export_pdf_request.dart';
import '../model/extra_ctrl_config_response.dart';
import '../model/filter_response.dart';
import '../model/invoice_response.dart';
import '../model/login_response.dart';
import '../model/user_verification_response.dart';
import '../utils/preference.dart';
import 'package:http_parser/http_parser.dart';
import 'package:async/async.dart';

abstract class SaveOrderView {
  void onExtraCtrlConfigSuccess(ExtraCtrlConfigResponse data);
  void onOrderSaveSuccess(CommonResponse data);

  void onError(int errorCode);
}

class SaveOrderPresenter {
  SaveOrderView view;
  RestDataSource api = RestDataSource();

  SaveOrderPresenter(this.view);

  getExtraCtrlConfig() async {
    try {
      var data = await api.getExtraCtrlConfig();
      view.onExtraCtrlConfigSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  saveOrder(SaveOrderRequest request) async {
    try {
      var data = await api.saveOrder(request);
      view.onOrderSaveSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  saveOrderFile(SaveOrderRequest sor, List<File> attachmentList, String date, String orderNo) async {
    var request = http.MultipartRequest('POST', Uri.parse(Constant.saveOrder));

    // Prepare the headers
    var headers = <String, String>{};
    headers['Content-type'] = "multipart/form-data";
    headers['Authorization'] = 'Bearer ${PreferenceData.getToken()}';
    request.headers.addAll(headers);

    // Add fields
    var map = <String, String>{};
    map["data"] = jsonEncode(sor);
    request.fields.addAll(map);
    // request.fields["data"] = jsonEncode(sor);

    // Add files
    for (int i = 0; i < attachmentList.length; i++) {
      // var key = 'File';
      // var multiFile = await http.MultipartFile.fromPath(
      //   key,
      //   attachmentList[i].path,
      //   contentType: MediaType('image', 'jpeg'), // Adjust media type as necessary
      // );
      // request.files.add(multiFile);

      request.files.add(http.MultipartFile.fromBytes('File', File(attachmentList[i].path).readAsBytesSync()));

    }


    try {
      var data = await api.saveOrderFile(Constant.saveOrder, request);
      view.onOrderSaveSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  // saveOrderFile(SaveOrderRequest sor, List<File> attachmentList, String date, String orderNo) async {
  //   var request = http.MultipartRequest('POST', Uri.parse(Constant.saveOrder));
  //
  //   Map<String, String> headers = {
  //     "Authorization": "Bearer ${PreferenceData.getToken()}",
  //     // "Content-Type": "application/json;charset=utf-8",
  //     // "Content-Type": "multipart/form-data",
  //     // "Content-Type": attachmentList.length == 1 ? "multipart/form-data" : "application/json;charset=utf-8"
  //   };
  //   // print(attachmentList.length);
  //   // print(headers);
  //   request.headers.addAll(headers);
  //
  //   // request.fields["sOrdTrnId"] = sor.sOrdTrnId!.toString();
  //   // request.fields["conum"] = sor.conum!.toString();
  //   // request.fields["typeId"] = sor.typeId!.toString();
  //   // request.fields["typeName"] = sor.typeName!.toString();
  //   // request.fields["vno"] = sor.vno!.toString();
  //   // request.fields["date"] = date;
  //   // request.fields["RefNo"] = orderNo;
  //   // request.fields["RefId"] = sor.RefId!.toString();
  //   // request.fields["AccountId"] = sor.AccountId!.toString();
  //   // request.fields["AgentId"] = sor.AgentId!.toString();
  //   // request.fields["HasteId"] = sor.HasteId!.toString();
  //   // request.fields["TPcs"] = sor.TPcs!.round().toString();
  //   // request.fields["TMtr"] = sor.TMtr!.toString();
  //   // request.fields["GrossAmt"] = sor.GrossAmt!.round().toString();
  //   // request.fields["Transport"] = sor.Transport!.toString();
  //   // request.fields["Station"] = sor.Station!;
  //   // request.fields["LrCase"] = sor.LrCase!;
  //   // request.fields["Remark"] = sor.Remark!;
  //   // request.fields["OrderItemDetails"] = jsonEncode(sor.OrderItemDetails);
  //
  //
  //   request.fields["data"] = jsonEncode(sor);
  //
  //
  //
  //   for (int i = 0; i < attachmentList.length; i++) {
  //     // var attachmentNumber = i + 1;
  //     // var key = 'attachment$attachmentNumber';
  //     var key = 'File';
  //     var multiFile = await http.MultipartFile.fromPath(key, attachmentList[i].path, contentType: MediaType('image', 'jpg'));
  //     request.files.add(multiFile);
  //
  //     // var stream = http.ByteStream(DelegatingStream.typed(attachmentList[i].openRead()));
  //     // var length = await attachmentList[i].length();
  //     // var multipartFileSign = http.MultipartFile('File', stream, length, filename: '1.jpg');
  //     // request.files.add(multipartFileSign);
  //   }
  //
  //   try {
  //     var data = await api.saveOrderFile(Constant.saveOrder, request);
  //     view.onOrderSaveSuccess(data);
  //   } on Exception catch (error) {
  //     view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
  //   }
  // }
}
