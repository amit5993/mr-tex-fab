
import 'package:td/model/receive_item_detail_response.dart';

class ReceiveListResponse {
  List<ReceiveData>? value;
  bool? success;
  String? resultMessage;

  ReceiveListResponse({this.value, this.success, this.resultMessage});

  ReceiveListResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <ReceiveData>[];
      json['value'].forEach((v) {
        value!.add(ReceiveData.fromJson(v));
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

class ReceiveData {
  int? conum;
  String? companyName;
  int? typeId;
  String? typeName;
  int? vno;
  int? inwardTrnId;
  String? date;
  String? challanNo;
  String? issuer;
  int? accountId;
  String? refAc;
  int? refId;
  int? agentId;
  String? agentName;
  String? mode;
  String? jobType;
  String? totalPcs;
  double? tMtr;
  String? amount;
  int? transport;
  String? transportName;
  String? station;
  int? lrCase;
  String? status;
  String? remark;
  bool? btnChange;
  bool? btnDelete;
  bool? btnPrint;
  List<ReceiveItemDetails>? receiveItemDetails;
  List<Report>? report;
  bool isShow = false;

  ReceiveData(
      {this.conum,
      this.companyName,
      this.typeId,
      this.typeName,
      this.vno,
      this.inwardTrnId,
      this.date,
      this.challanNo,
      this.issuer,
      this.accountId,
      this.refAc,
      this.refId,
      this.agentId,
      this.agentName,
      this.mode,
      this.jobType,
      this.totalPcs,
      this.tMtr,
      this.amount,
      this.transport,
      this.transportName,
      this.station,
      this.lrCase,
      this.status,
      this.remark,
      this.btnChange,
      this.btnDelete,
      this.btnPrint,
      this.receiveItemDetails,
      this.report});

  ReceiveData.fromJson(Map<String, dynamic> json) {
    conum = json['conum'];
    companyName = json['companyName'];
    typeId = json['typeId'];
    typeName = json['typeName'];
    vno = json['vno'];
    inwardTrnId = json['inwardTrnId'];
    date = json['date'] ?? '';
    challanNo = json['challanNo'];
    issuer = json['issuer'];
    accountId = json['accountId'];
    refAc = json['refAc'];
    refId = json['refId'];
    agentId = json['agentId'];
    agentName = json['agentName'];
    mode = json['mode'];
    jobType = json['jobType'];
    totalPcs = json['totalPcs'];
    tMtr = json['tMtr'] ?? 0.0;
    amount = json['amount'];
    transport = json['transport'];
    transportName = json['transportName'];
    station = json['station'];
    lrCase = json['lrCase'];
    status = json['status'];
    remark = json['remark'] ?? '';
    btnChange = json['btnChange'];
    btnDelete = json['btnDelete'];
    btnPrint = json['btnPrint'];
    if (json['receiveItemDetails'] != null) {
      receiveItemDetails = <ReceiveItemDetails>[];
      json['receiveItemDetails'].forEach((v) {
        receiveItemDetails!.add(ReceiveItemDetails.fromJson(v));
      });
    }
    if (json['report'] != null) {
      report = <Report>[];
      json['report'].forEach((v) {
        report!.add(Report.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conum'] = conum;
    data['companyName'] = companyName;
    data['typeId'] = typeId;
    data['typeName'] = typeName;
    data['vno'] = vno;
    data['inwardTrnId'] = inwardTrnId;
    data['date'] = date;
    data['challanNo'] = challanNo;
    data['issuer'] = issuer;
    data['accountId'] = accountId;
    data['refAc'] = refAc;
    data['refId'] = refId;
    data['agentId'] = agentId;
    data['agentName'] = agentName;
    data['mode'] = mode;
    data['jobType'] = jobType;
    data['totalPcs'] = totalPcs;
    data['tMtr'] = tMtr;
    data['amount'] = amount;
    data['transport'] = transport;
    data['transportName'] = transportName;
    data['station'] = station;
    data['lrCase'] = lrCase;
    data['status'] = status;
    data['remark'] = remark;
    data['btnChange'] = btnChange;
    data['btnDelete'] = btnDelete;
    data['btnPrint'] = btnPrint;
    if (this.receiveItemDetails != null) {
      data['receiveItemDetails'] = this.receiveItemDetails!.map((v) => v.toJson()).toList();
    }
    if (report != null) {
      data['report'] = report!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Report {
  int? id;
  String? name;

  Report({this.id, this.name});

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

// class ReceiveItemDetails {
//   int? inwardTrnId;
//   int? srno;
//   int? baseId;
//   int? qualId;
//   String? qualName;
//   String? jobType;
//   String? content;
//   String? unit;
//   double? cut;
//   double? qty;
//   double? stkQty;
//   String? secUnit;
//   double? secPcs;
//   double? plain;
//   double? sec;
//   double? short;
//   double? less;
//   double? fresh;
//   double? rate;
//   double? amt;
//   double? netAmt;
//   String? status;
//   String? color;
//   String? rmk;
//   String? barCode;
//   int? lnkType;
//   int? lnkId;
//   int? lnkDetSr;
//   int? outType;
//   int? outwardTrnId;
//   int? outDetSr;
//   int? outSubSr;
//   int? receipeType;
//   int? receipeId;
//   int? receipeDetSr;
//
//   ReceiveItemDetails(
//       {this.inwardTrnId,
//       this.srno,
//       this.baseId,
//       this.qualId,
//       this.qualName,
//       this.jobType,
//       this.content,
//       this.unit,
//       this.cut,
//       this.qty,
//       this.stkQty,
//       this.secUnit,
//       this.secPcs,
//       this.plain,
//       this.sec,
//       this.short,
//       this.less,
//       this.fresh,
//       this.rate,
//       this.amt,
//       this.netAmt,
//       this.status,
//       this.color,
//       this.rmk,
//       this.barCode,
//       this.lnkType,
//       this.lnkId,
//       this.lnkDetSr,
//       this.outType,
//       this.outwardTrnId,
//       this.outDetSr,
//       this.outSubSr,
//       this.receipeType,
//       this.receipeId,
//       this.receipeDetSr});
//
//   ReceiveItemDetails.fromJson(Map<String, dynamic> json) {
//     inwardTrnId = json['inwardTrnId'];
//     srno = json['srno'];
//     baseId = json['baseId'];
//     qualId = json['qualId'];
//     qualName = json['qualName'];
//     jobType = json['jobType'];
//     content = json['content'];
//     unit = json['unit'];
//     cut = json['cut'] ?? 0.0;
//     qty = json['qty'] ?? 0.0;
//     stkQty = json['stkQty'] ?? 0.0;
//     secUnit = json['secUnit'] ?? '';
//     secPcs = json['secPcs'] ?? 0.0;
//     plain = json['plain'] ?? 0.0;
//     sec = json['sec'] ?? 0.0;
//     short = json['short'] ?? 0.0;
//     less = json['less'] ?? 0.0;
//     fresh = json['fresh'] ?? 0.0;
//     rate = json['rate'] ?? 0.0;
//     amt = json['amt'] ?? 0.0;
//     netAmt = json['netAmt'] ?? 0.0;
//     status = json['status'];
//     color = json['color'];
//     rmk = json['rmk'];
//     barCode = json['barCode'];
//     lnkType = json['lnkType'];
//     lnkId = json['lnkId'];
//     lnkDetSr = json['lnkDetSr'];
//     outType = json['outType'];
//     outwardTrnId = json['outwardTrnId'];
//     outDetSr = json['outDetSr'];
//     outSubSr = json['outSubSr'];
//     receipeType = json['receipeType'];
//     receipeId = json['receipeId'];
//     receipeDetSr = json['receipeDetSr'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['inwardTrnId'] = inwardTrnId;
//     data['srno'] = srno;
//     data['baseId'] = baseId;
//     data['qualId'] = qualId;
//     data['qualName'] = qualName;
//     data['jobType'] = jobType;
//     data['content'] = content;
//     data['unit'] = unit;
//     data['cut'] = cut;
//     data['qty'] = qty;
//     data['stkQty'] = stkQty;
//     data['secUnit'] = secUnit;
//     data['secPcs'] = secPcs;
//     data['plain'] = plain;
//     data['sec'] = sec;
//     data['short'] = short;
//     data['less'] = less;
//     data['fresh'] = fresh;
//     data['rate'] = rate;
//     data['amt'] = amt;
//     data['netAmt'] = netAmt;
//     data['status'] = status;
//     data['color'] = color;
//     data['rmk'] = rmk;
//     data['barCode'] = barCode;
//     data['lnkType'] = lnkType;
//     data['lnkId'] = lnkId;
//     data['lnkDetSr'] = lnkDetSr;
//     data['outType'] = outType;
//     data['outwardTrnId'] = outwardTrnId;
//     data['outDetSr'] = outDetSr;
//     data['outSubSr'] = outSubSr;
//     data['receipeType'] = receipeType;
//     data['receipeId'] = receipeId;
//     data['receipeDetSr'] = receipeDetSr;
//     return data;
//   }
// }
