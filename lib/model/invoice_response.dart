import 'dart:ffi';

class InvoiceResponse {
  List<InvoiceData>? value;
  bool? success;
  String? resultMessage;

  InvoiceResponse({this.value, this.success, this.resultMessage});

  InvoiceResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <InvoiceData>[];
      json['value'].forEach((v) {
        value!.add(new InvoiceData.fromJson(v));
      });
    }
    success = json['success'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.value != null) {
      data['value'] = this.value!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['resultMessage'] = this.resultMessage;
    return data;
  }
}

class InvoiceData {
  String? key;
  String? value;
  String? content;
  double? billAmt;
  bool isSelected = false;

  InvoiceData({this.key, this.value, this.content, this.billAmt});

  InvoiceData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
    content = json['content']?? 0.0;
    billAmt = json['billAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = key;
    data['value'] = value;
    data['content'] = content;
    data['billAmt'] = billAmt;
    return data;
  }
}