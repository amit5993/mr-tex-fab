import 'issue_item_detail_response.dart';

class IssueEntryResponse {
  List<IssueData>? value;
  bool? success;
  String? resultMessage;

  IssueEntryResponse({this.value, this.success, this.resultMessage});

  IssueEntryResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <IssueData>[];
      json['value'].forEach((v) {
        value!.add(IssueData.fromJson(v));
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

class IssueData {
  int? conum;
  int? outwardTrnId;
  int? typeId;
  String? companyName;
  String? typeName;
  int? vno;
  String? ordNo;
  String? date;
  String? challanNo;
  String? issuer;
  int? accountId;
  int? agentId;
  String? agentName;
  String? totalPcs;
  double? tMtr;
  String? amount;
  int? transport;
  String? transportName;
  String? station;
  int? lrCase;
  String? status;
  String? remark;
  String? mode;
  bool? btnChange;
  bool? btnDelete;
  bool? btnPrint;
  List<IssueItemDetailData>? issueItemDetails;

  List<Report>? report;
  bool isShow = false;

  IssueData({
    this.conum,
    this.outwardTrnId,
    this.typeId,
    this.companyName,
    this.typeName,
    this.vno,
    this.ordNo,
    this.date,
    this.challanNo,
    this.issuer,
    this.accountId,
    this.agentId,
    this.agentName,
    this.totalPcs,
    this.tMtr,
    this.amount,
    this.transport,
    this.transportName,
    this.station,
    this.lrCase,
    this.status,
    this.remark,
    this.mode,
    this.btnChange,
    this.btnDelete,
    this.btnPrint,
    this.issueItemDetails,
    this.report
  });

  IssueData.fromJson(Map<String, dynamic> json) {
    conum = json['conum'];
    outwardTrnId = json['outwardTrnId'];
    typeId = json['typeId'];
    companyName = json['companyName'];
    typeName = json['typeName'];
    vno = json['vno'];
    ordNo = json['ordNo'] ?? '';
    date = json['date'];
    challanNo = json['challanNo'];
    issuer = json['issuer'];
    accountId = json['accountId'];
    agentId = json['agentId'];
    agentName = json['agentName'];
    totalPcs = json['totalPcs'];
    tMtr = json['tMtr'] ?? 0.0;
    amount = json['amount'];
    transport = json['transport'];
    transportName = json['transportName'];
    station = json['station'];
    lrCase = json['lrCase'];
    status = json['status'];
    remark = json['remark'];
    mode = json['mode'] ?? 'Normal';
    btnChange = json['btnChange'] ?? false;
    btnDelete = json['btnDelete'] ?? false;
    btnPrint = json['btnPrint'] ?? false;
    if (json['issueItemDetails'] != null) {
      issueItemDetails = <IssueItemDetailData>[];
      json['issueItemDetails'].forEach((v) {
        issueItemDetails!.add(IssueItemDetailData.fromJson(v));
      });
    }
    if (json['report'] != null) {
      report = <Report>[];
      json['report'].forEach((v) {
        report!.add(new Report.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conum'] = conum;
    data['outwardTrnId'] = outwardTrnId;
    data['typeId'] = typeId;
    data['companyName'] = companyName;
    data['typeName'] = typeName;
    data['vno'] = vno;
    data['ordNo'] = ordNo;
    data['date'] = date;
    data['challanNo'] = challanNo;
    data['issuer'] = issuer;
    data['accountId'] = accountId;
    data['agentId'] = agentId;
    data['agentName'] = agentName;
    data['totalPcs'] = totalPcs;
    data['tMtr'] = tMtr;
    data['amount'] = amount;
    data['transport'] = transport;
    data['transportName'] = transportName;
    data['station'] = station;
    data['lrCase'] = lrCase;
    data['status'] = status;
    data['remark'] = remark;
    data['mode'] = mode;
    data['btnChange'] = btnChange;
    data['btnDelete'] = btnDelete;
    data['btnPrint'] = btnPrint;
    if (issueItemDetails != null) {
      data['issueItemDetails'] = issueItemDetails!.map((v) => v.toJson()).toList();
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

// class IssueItemDetails {
//   int? outwardTrnId;
//   int? srno;
//   int? baseId;
//   int? qualId;
//   String? qualName;
//   String? jobType;
//   String? unit;
//   double? cut;
//   double? stkQty;
//   double? qty;
//   double? rate;
//   double? amt;
//   double? netAmt;
//   String? status;
//   Null? color;
//   String? rmk;
//   String? barCode;
//   int? lnkType;
//   int? lnkId;
//   int? lnkDetSr;
//   int? inType;
//   int? inwardTrnId;
//   int? inDetSr;
//   int? inSubSr;
//   int? receipeType;
//   int? receipeId;
//   int? receipeDetSr;
//
//   IssueItemDetails(
//       {this.outwardTrnId,
//       this.srno,
//       this.baseId,
//       this.qualId,
//       this.qualName,
//       this.jobType,
//       this.unit,
//       this.cut,
//       this.stkQty,
//       this.qty,
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
//       this.inType,
//       this.inwardTrnId,
//       this.inDetSr,
//       this.inSubSr,
//       this.receipeType,
//       this.receipeId,
//       this.receipeDetSr});
//
//   IssueItemDetails.fromJson(Map<String, dynamic> json) {
//     outwardTrnId = json['outwardTrnId'];
//     srno = json['srno'];
//     baseId = json['baseId'];
//     qualId = json['qualId'];
//     qualName = json['qualName'];
//     jobType = json['jobType'];
//     unit = json['unit'];
//     cut = json['cut'] ?? 0.0;
//     stkQty = json['stkQty'] ?? 0.0;
//     qty = json['qty'] ?? 0.0;
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
//     inType = json['inType'];
//     inwardTrnId = json['inwardTrnId'];
//     inDetSr = json['inDetSr'];
//     inSubSr = json['inSubSr'];
//     receipeType = json['receipeType'];
//     receipeId = json['receipeId'];
//     receipeDetSr = json['receipeDetSr'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['outwardTrnId'] = this.outwardTrnId;
//     data['srno'] = this.srno;
//     data['baseId'] = this.baseId;
//     data['qualId'] = this.qualId;
//     data['qualName'] = this.qualName;
//     data['jobType'] = this.jobType;
//     data['unit'] = this.unit;
//     data['cut'] = this.cut;
//     data['stkQty'] = this.stkQty;
//     data['qty'] = this.qty;
//     data['rate'] = this.rate;
//     data['amt'] = this.amt;
//     data['netAmt'] = this.netAmt;
//     data['status'] = this.status;
//     data['color'] = this.color;
//     data['rmk'] = this.rmk;
//     data['barCode'] = this.barCode;
//     data['lnkType'] = this.lnkType;
//     data['lnkId'] = this.lnkId;
//     data['lnkDetSr'] = this.lnkDetSr;
//     data['inType'] = this.inType;
//     data['inwardTrnId'] = this.inwardTrnId;
//     data['inDetSr'] = this.inDetSr;
//     data['inSubSr'] = this.inSubSr;
//     data['receipeType'] = this.receipeType;
//     data['receipeId'] = this.receipeId;
//     data['receipeDetSr'] = this.receipeDetSr;
//     return data;
//   }
// }
