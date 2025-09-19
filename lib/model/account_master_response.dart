class AccountMasterResponse {
  List<AccountMasterData>? value;
  bool? success;
  String? resultMessage;

  AccountMasterResponse({this.value, this.success, this.resultMessage});

  AccountMasterResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <AccountMasterData>[];
      json['value'].forEach((v) {
        value!.add(AccountMasterData.fromJson(v));
      });
    }
    success = json['success'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (value != null) {
      data['value'] = value!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['resultMessage'] = resultMessage;
    return data;
  }
}

class AccountMasterData {
  int? id;
  String? name;
  String? displayName;
  int? type;
  String? typeName;
  int? schdId;
  String? schdName;
  String? custType;
  String? registrationType;
  int? group;
  String? groupName;
  String? gst;
  String? add1;
  String? add2;
  String? city;
  String? state;
  String? district;
  String? market;
  String? pinCode;
  String? phone;
  String? mobile;
  String? mobileSMS;
  String? email;
  String? contactPerson;
  String? bankName;
  String? acountNumber;
  String? ifscCode;
  String? branchName;
  String? tanNo;
  String? panNo;
  String? dhara;
  String? mudat;
  double? interestRate;
  String? crDays;
  String? dhara1;
  String? dhara2;
  String? dhara3;
  int? transport;
  String? transportName;
  String? station;
  String? refName;
  String? remark;
  String? reftxt1;
  String? reftxt2;
  String? reftxt3;
  int? agentId;
  String? agentName;
  String? isActive;
  int? actionBy;

  AccountMasterData(
      {this.id,
      this.name,
      this.displayName,
      this.type,
      this.typeName,
      this.schdId,
      this.schdName,
      this.custType,
      this.registrationType,
      this.group,
      this.groupName,
      this.gst,
      this.add1,
      this.add2,
      this.city,
      this.state,
      this.district,
      this.market,
      this.pinCode,
      this.phone,
      this.mobile,
      this.mobileSMS,
      this.email,
      this.contactPerson,
      this.bankName,
      this.acountNumber,
      this.ifscCode,
      this.branchName,
      this.tanNo,
      this.panNo,
      this.dhara,
      this.mudat,
      this.interestRate,
      this.crDays,
      this.dhara1,
      this.dhara2,
      this.dhara3,
      this.transport,
      this.transportName,
      this.station,
      this.refName,
      this.remark,
      this.reftxt1,
      this.reftxt2,
      this.reftxt3,
      this.agentId,
      this.agentName,
      this.isActive,
      this.actionBy});

  AccountMasterData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    displayName = json['displayName'];
    type = json['type'];
    typeName = json['typeName'];
    schdId = json['schdId'];
    schdName = json['schdName'];
    custType = json['custType'];
    registrationType = json['registrationType'];
    group = json['group'];
    groupName = json['groupName'];
    gst = json['gst'];
    add1 = json['add1'];
    add2 = json['add2'];
    city = json['city'];
    state = json['state'];
    district = json['district'];
    market = json['market'];
    pinCode = json['pinCode'];
    phone = json['phone'];
    mobile = json['mobile'];
    mobileSMS = json['mobileSMS'];
    email = json['email'];
    contactPerson = json['contactPerson'];
    bankName = json['bankName'];
    acountNumber = json['acountNumber'];
    ifscCode = json['ifscCode'];
    branchName = json['branchName'];
    tanNo = json['tanNo'] ?? '';
    panNo = json['panNo'] ?? '';
    dhara = json['dhara'] ?? '';
    mudat = json['mudat'] ?? '';
    interestRate = json['interestRate'] ?? 0.0;
    crDays = json['crDays'] ?? '';
    dhara1 = json['dhara1'] ?? '';
    dhara2 = json['dhara2'] ?? '';
    dhara3 = json['dhara3'] ?? '';
    transport = json['transport'];
    transportName = json['transportName'] ?? '';
    station = json['station'] ?? '';
    refName = json['refName'] ?? '';
    remark = json['remark'] ?? '';
    reftxt1 = json['reftxt1'] ?? '';
    reftxt2 = json['reftxt2'] ?? '';
    reftxt3 = json['reftxt3'] ?? '';
    agentId = json['agentId'];
    agentName = json['agentName'];
    isActive = json['isActive'];
    actionBy = json['actionBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['displayName'] = displayName;
    data['type'] = type;
    data['typeName'] = typeName;
    data['schdId'] = schdId;
    data['schdName'] = schdName;
    data['custType'] = custType;
    data['registrationType'] = registrationType;
    data['group'] = group;
    data['groupName'] = groupName;
    data['gst'] = gst;
    data['add1'] = add1;
    data['add2'] = add2;
    data['city'] = city;
    data['state'] = state;
    data['district'] = district;
    data['market'] = market;
    data['pinCode'] = pinCode;
    data['phone'] = phone;
    data['mobile'] = mobile;
    data['mobileSMS'] = mobileSMS;
    data['email'] = email;
    data['contactPerson'] = contactPerson;
    data['bankName'] = bankName;
    data['acountNumber'] = acountNumber;
    data['ifscCode'] = ifscCode;
    data['branchName'] = branchName;
    data['tanNo'] = tanNo;
    data['panNo'] = panNo;
    data['dhara'] = dhara;
    data['mudat'] = mudat;
    data['interestRate'] = interestRate;
    data['crDays'] = crDays;
    data['dhara1'] = dhara1;
    data['dhara2'] = dhara2;
    data['dhara3'] = dhara3;
    data['transport'] = transport;
    data['transportName'] = transportName;
    data['station'] = station;
    data['refName'] = refName;
    data['remark'] = remark;
    data['reftxt1'] = reftxt1;
    data['reftxt2'] = reftxt2;
    data['reftxt3'] = reftxt3;
    data['agentId'] = agentId;
    data['agentName'] = agentName;
    data['isActive'] = isActive;
    data['actionBy'] = actionBy;
    return data;
  }
}
