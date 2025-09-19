import 'issue_item_detail_response.dart';



class ApprovalPendingResponse {
  List<ApprovalPendingData>? value;
  bool? success;
  String? resultMessage;

  ApprovalPendingResponse({this.value, this.success, this.resultMessage});

  ApprovalPendingResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <ApprovalPendingData>[];
      json['value'].forEach((v) {
        value!.add(new ApprovalPendingData.fromJson(v));
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

class ApprovalPendingData {
  int? conum;
  int? typeId;
  String? typeName;
  int? vno;
  int? trnId;
  String? date;
  String? challanNo;
  String? partyName;
  int? accountId;
  String? content;
  String? totalPcs;
  double? tMtr;
  String? amount;
  String? status;
  String? remark;
  bool? btnApprove;
  bool? btnCancel;
  bool? btnPrint;
  List<ApprovalItemDetails>? approvalItemDetails;
  List<Report>? report;
  bool isShow = false;

  ApprovalPendingData(
      {this.conum,
        this.typeId,
        this.typeName,
        this.vno,
        this.trnId,
        this.date,
        this.challanNo,
        this.partyName,
        this.accountId,
        this.content,
        this.totalPcs,
        this.tMtr,
        this.amount,
        this.status,
        this.remark,
        this.btnApprove,
        this.btnCancel,
        this.btnPrint,
        this.approvalItemDetails,
        this.report});

  ApprovalPendingData.fromJson(Map<String, dynamic> json) {
    conum = json['conum'];
    typeId = json['typeId'];
    typeName = json['typeName'];
    vno = json['vno'];
    trnId = json['trnId'];
    date = json['date'] ?? '';
    challanNo = json['challanNo'];
    partyName = json['partyName'];
    accountId = json['accountId'];
    content = json['content'] ?? '';
    totalPcs = json['totalPcs'];
    tMtr = json['tMtr'] ?? 0.0;
    amount = json['amount'];
    status = json['status'];
    remark = json['remark'];
    btnApprove = json['btnApprove'];
    btnCancel = json['btnCancel'];
    btnPrint = json['btnPrint'];
    if (json['approvalItemDetails'] != null) {
      approvalItemDetails = <ApprovalItemDetails>[];
      json['approvalItemDetails'].forEach((v) {
        approvalItemDetails!.add(new ApprovalItemDetails.fromJson(v));
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
    data['conum'] = this.conum;
    data['typeId'] = this.typeId;
    data['typeName'] = this.typeName;
    data['vno'] = this.vno;
    data['trnId'] = this.trnId;
    data['date'] = this.date;
    data['challanNo'] = this.challanNo;
    data['partyName'] = this.partyName;
    data['accountId'] = this.accountId;
    data['content'] = this.content;
    data['totalPcs'] = this.totalPcs;
    data['tMtr'] = this.tMtr;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['btnApprove'] = this.btnApprove;
    data['btnCancel'] = this.btnCancel;
    data['btnPrint'] = this.btnPrint;
    if (this.approvalItemDetails != null) {
      data['approvalItemDetails'] =
          this.approvalItemDetails!.map((v) => v.toJson()).toList();
    }
    if (report != null) {
      data['report'] = report!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ApprovalItemDetails {
  int? typeId;
  int? trnId;
  int? srno;
  int? baseId;
  int? qualId;
  String? qualName;
  String? content;
  String? unit;
  double? qty;
  double? rate;
  double? amt;
  double? netAmt;
  String? status;
  String? rmk;

  ApprovalItemDetails(
      {this.typeId,
        this.trnId,
        this.srno,
        this.baseId,
        this.qualId,
        this.qualName,
        this.content,
        this.unit,
        this.qty,
        this.rate,
        this.amt,
        this.netAmt,
        this.status,
        this.rmk});

  ApprovalItemDetails.fromJson(Map<String, dynamic> json) {
    typeId = json['typeId'];
    trnId = json['trnId'];
    srno = json['srno'];
    baseId = json['baseId'];
    qualId = json['qualId'];
    qualName = json['qualName'];
    content = json['content'];
    unit = json['unit'];
    qty = json['qty'] ?? 0.0;
    rate = json['rate'] ?? 0.0;
    amt = json['amt'] ?? 0.0;
    netAmt = json['netAmt'] ?? 0.0;
    status = json['status'];
    rmk = json['rmk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeId'] = this.typeId;
    data['trnId'] = this.trnId;
    data['srno'] = this.srno;
    data['baseId'] = this.baseId;
    data['qualId'] = this.qualId;
    data['qualName'] = this.qualName;
    data['content'] = this.content;
    data['unit'] = this.unit;
    data['qty'] = this.qty;
    data['rate'] = this.rate;
    data['amt'] = this.amt;
    data['netAmt'] = this.netAmt;
    data['status'] = this.status;
    data['rmk'] = this.rmk;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
