class ExportPDFRequest {
  List<String>? accountId = [];
  List<String>? agentGrp = [];
  List<String>? agentId = [];
  List<String>? conum = [];
  List<String>? custGrp = [];
  List<String>? custId = [];
  List<String>? hasteId = [];
  List<String>? partyGrp = [];
  List<String>? qualId = [];
  List<String>? refId = [];
  List<String>? suppGrp = [];
  List<String>? suppId = [];
  List<String>? trnId = [];
  String? frVno;
  String? toVno;
  String? uptoDate;
  String? fromDate;
  String? group1;
  String? group2;
  String? group3;
  String? group4;
  String? options;
  String? mode;
  String? city;
  String? designNo;

  ExportPDFRequest({
    this.accountId,
    this.agentGrp,
    this.agentId,
    this.conum,
    this.custGrp,
    this.custId,
    this.hasteId,
    this.partyGrp,
    this.qualId,
    this.refId,
    this.suppGrp,
    this.suppId,
    this.trnId,
    this.frVno,
    this.toVno,
    this.uptoDate,
    this.fromDate,
    this.group1,
    this.group2,
    this.group3,
    this.group4,
    this.options,
    this.mode,
    this.city,
    this.designNo,
  });

  ExportPDFRequest.fromJson(Map<String, dynamic> json) {
    frVno = json['FrVno'];
    toVno = json['ToVno'];
    accountId = (json['AccountId'] == null) ? [] : json['AccountId'].cast<String>();
    agentGrp = (json['AgentGrp'] == null) ? [] : json['AgentGrp'].cast<String>();
    agentId = (json['AgentId'] == null) ? [] : json['AgentId'].cast<String>();
    conum = (json['Conum'] == null) ? [] : json['Conum'].cast<String>();
    custGrp = (json['CustGrp'] == null) ? [] : json['CustGrp'].cast<String>();
    custId = (json['CustId'] == null) ? [] : json['CustId'].cast<String>();
    hasteId = (json['HasteId'] == null) ? [] : json['HasteId'].cast<String>();
    partyGrp = (json['PartyGrp'] == null) ? [] : json['PartyGrp'].cast<String>();
    qualId = (json['QualId'] == null) ? [] : json['QualId'].cast<String>();
    refId = (json['RefId'] == null) ? [] : json['RefId'].cast<String>();
    suppGrp = (json['SuppGrp'] == null) ? [] : json['SuppGrp'].cast<String>();
    suppId = (json['SuppId'] == null) ? [] : json['SuppId'].cast<String>();
    trnId = (json['TrnId'] == null) ? [] : json['TrnId'].cast<String>();
    fromDate = json['FromDate'];
    uptoDate = json['UptoDate'];
    group1 = json['Group1'];
    group2 = json['Group2'];
    group3 = json['Group3'];
    group4 = json['Group4'];
    options = json['Options'];
    mode = json['mode'];
    city = json['city'];
    designNo = json['designNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FrVno'] = frVno;
    data['ToVno'] = toVno;
    data['AccountId'] = accountId;
    data['AgentGrp'] = agentGrp;
    data['AgentId'] = agentId;
    data['Conum'] = conum;
    data['CustGrp'] = custGrp;
    data['CustId'] = custId;
    data['FromDate'] = fromDate;
    data['HasteId'] = hasteId;
    data['PartyGrp'] = partyGrp;
    data['QualId'] = qualId;
    data['RefId'] = refId;
    data['SuppGrp'] = suppGrp;
    data['SuppId'] = suppId;
    data['TrnId'] = trnId;
    data['UptoDate'] = uptoDate;
    data['Group1'] = group1;
    data['Group2'] = group2;
    data['Group3'] = group3;
    data['Group4'] = group4;
    data['Options'] = options;
    data['mode'] = mode;
    data['city'] = city;
    data['designNo'] = designNo;
    return data;
  }
}
