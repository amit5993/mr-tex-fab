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

abstract class AddOrderItemView {

  void onGetFilterSuccess(FilterResponse data);

  void onError(int errorCode);
}

class AddOrderItemPresenter {
  AddOrderItemView view;
  RestDataSource api = RestDataSource();

  AddOrderItemPresenter(this.view);


  reportByFilter(String spName, int page, String search) async {
    try {
      var data = await api.getReportFilter(spName, page, search);
      view.onGetFilterSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }
}
