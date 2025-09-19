import '../api/rest_ds.dart';
import '../model/export_pdf_request.dart';
import '../model/filter_response.dart';
import '../model/invoice_response.dart';
import '../model/login_response.dart';
import '../model/user_verification_response.dart';

abstract class InvoiceView {
  void onGetDynamicReportSuccess(InvoiceResponse data);

  void onError(int errorCode);
}

class InvoicePresenter {
  InvoiceView view;
  RestDataSource api = RestDataSource();

  InvoicePresenter(this.view);

  dynamicReport(int reportId, int page,String search, ExportPDFRequest request) async {
    try {
      var data = await api.getDynamicReport(reportId, page, search, request);
      view.onGetDynamicReportSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
