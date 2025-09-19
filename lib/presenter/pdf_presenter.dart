import 'dart:ffi';

import 'package:td/model/menu_response.dart';

import '../api/rest_ds.dart';
import '../model/export_pdf_request.dart';
import '../model/export_pdf_response.dart';
import '../model/login_response.dart';
import '../model/order_list_response.dart';
import '../model/report_by_menu_response.dart';
import '../model/user_manager_response.dart';
import '../model/user_verification_response.dart';

abstract class PDFView {
  void onExportPDFSuccess(ExportPDFResponse data);
  void onError(int errorCode);
}

class PDFPresenter {
  PDFView view;
  RestDataSource api = RestDataSource();

  PDFPresenter(this.view);

  getExportPDFFile(int rId, var request) async {
    try {
      var data = await api.getExportPDFFile(rId, request);
      view.onExportPDFSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
