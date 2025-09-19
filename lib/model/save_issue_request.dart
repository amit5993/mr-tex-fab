import 'dart:ffi';

import 'package:td/model/order_list_response.dart';

import 'issue_item_detail_response.dart';
import 'order_item_detail.dart';

class SaveIssueRequest {
  int? outwardTrnId;
  int? conum;
  int? typeId;
  String? typeName;
  int? vno;
  String? ordNo;
  String? date;
  String? challanNo;
  String? issuer;
  int? accountId;
  int? agentId;
  String? agentName;
  String? mode;
  String? totalPcs;
  double? tMtr;
  double? amount;
  int? transport;
  String? transportName;
  String? station;
  int? lrCase;
  String? status;
  String? remark;
  String? jobType;
  List<IssueItemDetailData>? issueItemDetails;

  SaveIssueRequest(
      {this.outwardTrnId,
        this.conum,
        this.typeId,
        this.typeName,
        this.vno,
        this.ordNo,
        this.date,
        this.challanNo,
        this.issuer,
        this.accountId,
        this.agentId,
        this.agentName,
        this.mode,
        this.totalPcs,
        this.tMtr,
        this.amount,
        this.transport,
        this.transportName,
        this.station,
        this.lrCase,
        this.status,
        this.remark,
        this.jobType,
        this.issueItemDetails});

  SaveIssueRequest.fromJson(Map<String, dynamic> json) {
    outwardTrnId = json['outwardTrnId'];
    conum = json['conum'];
    typeId = json['typeId'];
    typeName = json['typeName'];
    vno = json['vno'];
    ordNo = json['ordNo'];
    date = json['date'];
    challanNo = json['challanNo'];
    issuer = json['issuer'];
    accountId = json['accountId'];
    agentId = json['agentId'];
    agentName = json['agentName'];
    mode = json['mode'];
    totalPcs = json['totalPcs'];
    tMtr = json['tMtr'];
    amount = json['amount'];
    transport = json['transport'];
    transportName = json['transportName'];
    station = json['station'];
    lrCase = json['lrCase'];
    status = json['status'];
    remark = json['remark'];
    jobType = json['jobType'];
    if (json['issueItemDetails'] != null) {
      issueItemDetails = <IssueItemDetailData>[];
      json['issueItemDetails'].forEach((v) {
        issueItemDetails!.add(new IssueItemDetailData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['outwardTrnId'] = this.outwardTrnId;
    data['conum'] = this.conum;
    data['typeId'] = this.typeId;
    data['typeName'] = this.typeName;
    data['vno'] = this.vno;
    data['ordNo'] = this.ordNo;
    data['date'] = this.date;
    data['challanNo'] = this.challanNo;
    data['issuer'] = this.issuer;
    data['accountId'] = this.accountId;
    data['agentId'] = this.agentId;
    data['agentName'] = this.agentName;
    data['mode'] = this.mode;
    data['totalPcs'] = this.totalPcs;
    data['tMtr'] = this.tMtr;
    data['amount'] = this.amount;
    data['transport'] = this.transport;
    data['transportName'] = this.transportName;
    data['station'] = this.station;
    data['lrCase'] = this.lrCase;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['jobType'] = this.jobType;
    if (this.issueItemDetails != null) {
      data['issueItemDetails'] =
          this.issueItemDetails!.map((v) => v.toJson()).toList();
    }
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
//   Null? content;
//   String? unit;
//   int? cut;
//   int? stkQty;
//   int? qty;
//   int? rate;
//   int? amt;
//   int? netAmt;
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
//         this.srno,
//         this.baseId,
//         this.qualId,
//         this.qualName,
//         this.jobType,
//         this.content,
//         this.unit,
//         this.cut,
//         this.stkQty,
//         this.qty,
//         this.rate,
//         this.amt,
//         this.netAmt,
//         this.status,
//         this.color,
//         this.rmk,
//         this.barCode,
//         this.lnkType,
//         this.lnkId,
//         this.lnkDetSr,
//         this.inType,
//         this.inwardTrnId,
//         this.inDetSr,
//         this.inSubSr,
//         this.receipeType,
//         this.receipeId,
//         this.receipeDetSr});
//
//   IssueItemDetails.fromJson(Map<String, dynamic> json) {
//     outwardTrnId = json['outwardTrnId'];
//     srno = json['srno'];
//     baseId = json['baseId'];
//     qualId = json['qualId'];
//     qualName = json['qualName'];
//     jobType = json['jobType'];
//     content = json['content'];
//     unit = json['unit'];
//     cut = json['cut'];
//     stkQty = json['stkQty'];
//     qty = json['qty'];
//     rate = json['rate'];
//     amt = json['amt'];
//     netAmt = json['netAmt'];
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
//     data['content'] = this.content;
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
