import 'package:td/model/order_list_response.dart';

import 'order_item_detail.dart';

class SaveOrderRequest {

  int? sOrdTrnId;
  int? conum;
  int? typeId;
  String? typeName;
  int? vno;
  String? date;
  int? orderNo;
  int? dueDays;

  int? AccountId;
  int? AgentId;
  int? HasteId;
  double? GrossAmt;
  String? LrCase;
  List<OrderItemDetail>? OrderItemDetails;
  int? RefId;
  String? Station;
  String? Remark;
  int? TMtr;
  int? TPcs;
  int? Transport;

  SaveOrderRequest(
    this.sOrdTrnId,
    this.conum,
    this.typeId,
    this.typeName,
    this.vno,
    this.date,
    this.orderNo,
    this.dueDays,
    this.AccountId,
    this.AgentId,
    this.HasteId,
    this.GrossAmt,
    this.LrCase,
    this.OrderItemDetails,
    this.RefId,
    this.Station,
    this.Remark,
    this.TMtr,
    this.TPcs,
    this.Transport,
  );

  SaveOrderRequest.fromJson(Map<String, dynamic> json) {
    sOrdTrnId = json['sOrdTrnId'];
    conum = json['conum'];
    typeId = json['typeId'];
    typeName = json['typeName'];
    vno = json['vno'];
    date = json['date'];
    orderNo = json['orderNo'];
    dueDays = json['dueDays'];

    AccountId = json['AccountId'];
    AgentId = json['AgentId'];
    HasteId = json['HasteId'];
    GrossAmt = json['GrossAmt'];
    LrCase = json['LrCase'] ?? '';
    //OrderItemDetails = json['OrderItemDetails'];

    if (json['OrderItemDetails'] != null) {
      OrderItemDetails = <OrderItemDetail>[];
      json['value'].forEach((v) {
        OrderItemDetails!.add(OrderItemDetail.fromJson(v));
      });
    }

    RefId = json['RefId'];
    Station = json['Station'] ?? '';
    Remark = json['Remark'] ?? '';
    TMtr = json['TMtr'];
    TPcs = json['TPcs'] ?? 0.0;
    Transport = json['Transport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sOrdTrnId'] = sOrdTrnId;
    data['conum'] = conum;
    data['typeId'] = typeId;
    data['typeName'] = typeName;
    data['vno'] = vno;
    data['date'] = date;
    data['orderNo'] = orderNo;
    data['dueDays'] = dueDays;

    data['AccountId'] = AccountId;
    data['AgentId'] = AgentId;
    data['HasteId'] = HasteId;
    data['GrossAmt'] = GrossAmt;
    data['LrCase'] = LrCase;
    // data['OrderItemDetails'] = OrderItemDetails;
    if (OrderItemDetails != null) {
      data['OrderItemDetails'] = OrderItemDetails!.map((v) => v.toJson()).toList();
    }

    data['RefId'] = RefId;
    data['Station'] = Station;
    data['Remark'] = Remark;
    data['TMtr'] = TMtr;
    data['TPcs'] = TPcs;
    data['Transport'] = Transport;
    return data;
  }
}
