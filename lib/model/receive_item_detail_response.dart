class ReceiveItemDetailResponse {
  List<ReceiveItemDetails>? value;
  bool? success;
  String? resultMessage;

  ReceiveItemDetailResponse({this.value, this.success, this.resultMessage});

  ReceiveItemDetailResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <ReceiveItemDetails>[];
      json['value'].forEach((v) {
        value!.add(ReceiveItemDetails.fromJson(v));
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

class ReceiveItemDetails {
  int? inwardTrnId;
  int? srno;
  int? baseId;
  int? qualId;
  String? qualName;
  String? finalQuality;
  String? jobType;
  String? content;
  String? unit;
  double? cut;
  double? qty;
  double? stkQty;
  String? secUnit;
  double? secPcs;
  double? plain;
  double? sec;
  double? short;
  double? less;
  double? fresh;
  double? rate;
  double? amt;
  double? netAmt;
  String? status;
  String? color;
  String? stage;
  String? rmk;
  String? barCode;
  String? suffix;
  int? takaNo;
  int? lnkType;
  int? lnkId;
  int? lnkDetSr;
  int? outType;
  int? outwardTrnId;
  int? outDetSr;
  int? outSubSr;
  int? receipeType;
  int? receipeId;
  int? receipeDetSr;
  String? issuer;
  String? refAc;
  int? accountId;
  int? refId;
  String? rateCateId = '';
  String? rateCateName = '';
  bool isSelect = false;

  ReceiveItemDetails(
      {this.inwardTrnId,
      this.srno,
      this.baseId,
      this.qualId,
      this.qualName,
      this.finalQuality,
      this.jobType,
      this.content,
      this.unit,
      this.cut,
      this.qty,
      this.stkQty,
      this.secUnit,
      this.secPcs,
      this.plain,
      this.sec,
      this.short,
      this.less,
      this.fresh,
      this.rate,
      this.amt,
      this.netAmt,
      this.status,
      this.color,
      this.stage,
      this.rmk,
      this.barCode,
      this.suffix,
      this.takaNo,
      this.lnkType,
      this.lnkId,
      this.lnkDetSr,
      this.outType,
      this.outwardTrnId,
      this.outDetSr,
      this.outSubSr,
      this.receipeType,
      this.receipeId,
      this.receipeDetSr,
      this.issuer,
      this.refAc,
      this.accountId,
      this.refId,
      this.rateCateId,
      this.rateCateName});

  ReceiveItemDetails.fromJson(Map<String, dynamic> json) {
    inwardTrnId = json['inwardTrnId'];
    srno = json['srno'];
    baseId = json['baseId'];
    qualId = json['qualId'];
    qualName = json['qualName'] ?? '';
    finalQuality = json['finalQuality'] ?? '';
    jobType = json['jobType'];
    content = json['content'] ?? '';
    unit = json['unit'];
    cut = json['cut'] ?? 0.0;
    qty = json['qty'] ?? 0.0;
    stkQty = json['stkQty'] ?? 0.0;
    secUnit = json['secUnit'] ?? '';
    secPcs = json['secPcs'] ?? 0.0;
    plain = json['plain'] ?? 0.0;
    sec = json['sec'] ?? 0.0;
    short = json['short'] ?? 0.0;
    less = json['less'] ?? 0.0;
    fresh = json['fresh'] ?? 0.0;
    rate = json['rate'] ?? 0.0;
    amt = json['amt'] ?? 0.0;
    netAmt = json['netAmt'] ?? 0.0;
    status = json['status'] ?? '';
    color = json['color'] ?? '';
    stage = json['stage'] ?? '';
    rmk = json['rmk'] ?? '';
    barCode = json['barCode'];
    suffix = json['suffix'] ?? '';
    takaNo = json['takaNo'] ?? 0;
    lnkType = json['lnkType'];
    lnkId = json['lnkId'];
    lnkDetSr = json['lnkDetSr'];
    outType = json['outType'];
    outwardTrnId = json['outwardTrnId'];
    outDetSr = json['outDetSr'];
    outSubSr = json['outSubSr'];
    receipeType = json['receipeType'];
    receipeId = json['receipeId'];
    receipeDetSr = json['receipeDetSr'];
    issuer = json['issuer'] ?? '';
    refAc = json['refAc'] ?? '';
    accountId = json['accountId'] ?? 0;
    refId = json['refId'] ?? 0;
    rateCateId = json['rateCateId'] ?? '';
    rateCateName = json['rateCateName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inwardTrnId'] = inwardTrnId;
    data['srno'] = srno;
    data['baseId'] = baseId;
    data['qualId'] = qualId;
    data['qualName'] = qualName;
    data['finalQuality'] = finalQuality;
    data['jobType'] = jobType;
    data['content'] = content;
    data['unit'] = unit;
    data['cut'] = cut;
    data['qty'] = qty;
    data['stkQty'] = stkQty;
    data['secUnit'] = secUnit;
    data['secPcs'] = secPcs;
    data['plain'] = plain;
    data['sec'] = sec;
    data['short'] = short;
    data['less'] = less;
    data['fresh'] = fresh;
    data['rate'] = rate;
    data['amt'] = amt;
    data['netAmt'] = netAmt;
    data['status'] = status;
    data['color'] = color;
    data['stage'] = stage;
    data['rmk'] = rmk;
    data['barCode'] = barCode;
    data['suffix'] = suffix;
    data['takaNo'] = takaNo;
    data['lnkType'] = lnkType;
    data['lnkId'] = lnkId;
    data['lnkDetSr'] = lnkDetSr;
    data['outType'] = outType;
    data['outwardTrnId'] = outwardTrnId;
    data['outDetSr'] = outDetSr;
    data['outSubSr'] = outSubSr;
    data['receipeType'] = receipeType;
    data['receipeId'] = receipeId;
    data['receipeDetSr'] = receipeDetSr;
    data['issuer'] = issuer;
    data['refAc'] = refAc;
    data['accountId'] = accountId;
    data['refId'] = refId;
    data['rateCateId'] = rateCateId;
    data['rateCateName'] = rateCateName;
    return data;
  }
}
