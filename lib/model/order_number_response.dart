class OrderNumberResponse {
  List<OrderNumberData>? value;
  bool? success;
  String? resultMessage;

  OrderNumberResponse({this.value, this.success, this.resultMessage});

  OrderNumberResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <OrderNumberData>[];
      json['value'].forEach((v) {
        value!.add(OrderNumberData.fromJson(v));
      });
    }
    success = json['success'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (value != null) {
      data['value'] = value!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['resultMessage'] = resultMessage;
    return data;
  }
}

class OrderNumberData {
  int? serId;
  int? trnId;
  int? srno;
  int? vno;
  int? baseId;
  int? qualId;
  String? qualName;
  String? finalQuality;
  String? content;

  OrderNumberData(
      {this.serId,
        this.trnId,
        this.srno,
        this.vno,
        this.baseId,
        this.qualId,
        this.qualName,
        this.finalQuality,
        this.content});

  OrderNumberData.fromJson(Map<String, dynamic> json) {
    serId = json['serId'];
    trnId = json['trnId'];
    srno = json['srno'];
    vno = json['vno'];
    baseId = json['baseId'];
    qualId = json['qualId'];
    qualName = json['qualName'];
    finalQuality = json['finalQuality'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serId'] = serId;
    data['trnId'] = trnId;
    data['srno'] = srno;
    data['vno'] = vno;
    data['baseId'] = baseId;
    data['qualId'] = qualId;
    data['qualName'] = qualName;
    data['finalQuality'] = finalQuality;
    data['content'] = content;
    return data;
  }
}
