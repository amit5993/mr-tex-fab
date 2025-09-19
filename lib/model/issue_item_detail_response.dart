class IssueItemDetailResponse {
  List<IssueItemDetailData>? value;
  bool? success;
  String? resultMessage;

  IssueItemDetailResponse({this.value, this.success, this.resultMessage});

  IssueItemDetailResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <IssueItemDetailData>[];
      json['value'].forEach((v) {
        value!.add(new IssueItemDetailData.fromJson(v));
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

class IssueItemDetailData {
  int? outwardTrnId;
  int? srno;
  int? baseId;
  int? qualId;
  String? qualName;
  String? jobType;
  String? content;
  String? unit;
  double? cut;
  double? stkQty;
  double? qty;
  double? rate;
  double? amt;
  double? netAmt;
  double? secQty;
  String? secUnit;
  String? status;
  String? color;
  String? rmk;
  String? barCode;
  int? lnkType;
  int? lnkId;
  int? lnkDetSr;
  int? inType;
  int? inwardTrnId;
  int? inDetSr;
  int? inSubSr;
  int? receipeType;
  int? receipeId;
  int? receipeDetSr;
  bool isSelect = false;


  IssueItemDetailData(
      {this.outwardTrnId,
        this.srno,
        this.baseId,
        this.qualId,
        this.qualName,
        this.jobType,
        this.content,
        this.unit,
        this.cut,
        this.stkQty,
        this.qty,
        this.rate,
        this.amt,
        this.netAmt,
        this.secQty,
        this.secUnit,
        this.status,
        this.color,
        this.rmk,
        this.barCode,
        this.lnkType,
        this.lnkId,
        this.lnkDetSr,
        this.inType,
        this.inwardTrnId,
        this.inDetSr,
        this.inSubSr,
        this.receipeType,
        this.receipeId,
        this.receipeDetSr});

  IssueItemDetailData.fromJson(Map<String, dynamic> json) {
    outwardTrnId = json['outwardTrnId'];
    srno = json['srno'];
    baseId = json['baseId'];
    qualId = json['qualId'];
    qualName = json['qualName'];
    jobType = json['jobType'];
    content = json['content'];
    unit = json['unit'];
    cut = json['cut'] ?? 0.0;
    stkQty = json['stkQty'] ?? 0.0;
    qty = json['qty'] ?? 0.0;
    rate = json['rate'] ?? 0.0;
    amt = json['amt'] ?? 0.0;
    netAmt = json['netAmt'] ?? 0.0;
    secQty = json['secQty'] ?? 0.0;
    secUnit = json['secUnit'] ?? '';
    status = json['status'];
    color = json['color'];
    rmk = json['rmk'];
    barCode = json['barCode'];
    lnkType = json['lnkType'];
    lnkId = json['lnkId'];
    lnkDetSr = json['lnkDetSr'];
    inType = json['inType'];
    inwardTrnId = json['inwardTrnId'];
    inDetSr = json['inDetSr'];
    inSubSr = json['inSubSr'];
    receipeType = json['receipeType'];
    receipeId = json['receipeId'];
    receipeDetSr = json['receipeDetSr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['outwardTrnId'] = this.outwardTrnId;
    data['srno'] = this.srno;
    data['baseId'] = this.baseId;
    data['qualId'] = this.qualId;
    data['qualName'] = this.qualName;
    data['jobType'] = this.jobType;
    data['content'] = this.content;
    data['unit'] = this.unit;
    data['cut'] = this.cut;
    data['stkQty'] = this.stkQty;
    data['qty'] = this.qty;
    data['rate'] = this.rate;
    data['amt'] = this.amt;
    data['netAmt'] = this.netAmt;
    data['secQty'] = this.secQty;
    data['secUnit'] = this.secUnit;
    data['status'] = this.status;
    data['color'] = this.color;
    data['rmk'] = this.rmk;
    data['barCode'] = this.barCode;
    data['lnkType'] = this.lnkType;
    data['lnkId'] = this.lnkId;
    data['lnkDetSr'] = this.lnkDetSr;
    data['inType'] = this.inType;
    data['inwardTrnId'] = this.inwardTrnId;
    data['inDetSr'] = this.inDetSr;
    data['inSubSr'] = this.inSubSr;
    data['receipeType'] = this.receipeType;
    data['receipeId'] = this.receipeId;
    data['receipeDetSr'] = this.receipeDetSr;
    return data;
  }
}
