import 'package:td/model/receive_item_detail_response.dart';

class SaveReceiveRequest {
  int? inwardTrnId;
  int? conum;
  int? typeId;
  String? typeName;
  int? vno;
  String? date;
  String? challanNo;
  String? challanDat;
  String? issuer;
  int? accountId;
  int? refId;
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
  List<ReceiveItemDetails>? receiveItemDetails;

  SaveReceiveRequest(
      {this.inwardTrnId,
        this.conum,
        this.typeId,
        this.typeName,
        this.vno,
        this.date,
        this.challanNo,
        this.challanDat,
        this.issuer,
        this.accountId,
        this.refId,
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
        this.receiveItemDetails});

  SaveReceiveRequest.fromJson(Map<String, dynamic> json) {
    inwardTrnId = json['inwardTrnId'];
    conum = json['conum'];
    typeId = json['typeId'];
    typeName = json['typeName'];
    vno = json['vno'];
    date = json['date'];
    challanNo = json['challanNo'];
    challanDat = json['challanDat'];
    issuer = json['issuer'];
    accountId = json['accountId'];
    refId = json['refId'];
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
    if (json['receiveItemDetails'] != null) {
      receiveItemDetails = <ReceiveItemDetails>[];
      json['receiveItemDetails'].forEach((v) {
        receiveItemDetails!.add(ReceiveItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inwardTrnId'] = inwardTrnId;
    data['conum'] = conum;
    data['typeId'] = typeId;
    data['typeName'] = typeName;
    data['vno'] = vno;
    data['date'] = date;
    data['challanNo'] = challanNo;
    data['challanDat'] = challanDat;
    data['issuer'] = issuer;
    data['accountId'] = accountId;
    data['refId'] = refId;
    data['agentId'] = agentId;
    data['agentName'] = agentName;
    data['mode'] = mode;
    data['totalPcs'] = totalPcs;
    data['tMtr'] = tMtr;
    data['amount'] = amount;
    data['transport'] = transport;
    data['transportName'] = transportName;
    data['station'] = station;
    data['lrCase'] = lrCase;
    data['status'] = status;
    data['remark'] = remark;
    if (this.receiveItemDetails != null) {
      data['receiveItemDetails'] =
          this.receiveItemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

