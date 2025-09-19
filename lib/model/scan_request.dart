import 'export_pdf_request.dart';

class ScanRequest {
  String? reportId;
  ExportPDFRequest? data;

  ScanRequest({this.reportId, this.data});

  ScanRequest.fromJson(Map<String, dynamic> json) {
    reportId = json['ReportId'];
    data = json['data'] != null ? ExportPDFRequest.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ReportId'] = reportId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

