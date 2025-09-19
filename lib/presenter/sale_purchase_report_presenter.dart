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

abstract class SalePurchaseReportView {
  void onReportByMenuSuccess(ReportByMenuResponse data);

  void onError(int errorCode);
}

class SalePurchaseReportPresenter {
  SalePurchaseReportView view;
  RestDataSource api = RestDataSource();

  SalePurchaseReportPresenter(this.view);

  getReportByMenu(String menuName) async {
    try {
      var data = await api.getReportByMenu(menuName);
      view.onReportByMenuSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
