class RoleResponse {
  List<RoleData>? value;
  bool? success;
  String? resultMessage;

  RoleResponse({this.value, this.success, this.resultMessage});

  RoleResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <RoleData>[];
      json['value'].forEach((v) {
        value!.add(RoleData.fromJson(v));
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

class RoleData {
  int? id;
  String? name;
  String? line1;
  String? line2;
  String? line3;
  int? transportId;
  String? transportName;
  int? agentId;
  String? agentName;
  int? hasteId;
  String? hasteName;
  String? station;
  String? rateCateId;
  String? rateCateName;

  RoleData(
      {this.id,
        this.name,
        this.line1,
        this.line2,
        this.line3,
        this.transportId,
        this.transportName,
        this.agentId,
        this.agentName,
        this.hasteId,
        this.hasteName,
        this.station,
        this.rateCateId,
        this.rateCateName});

  RoleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    line1 = json['line1'];
    line2 = json['line2'];
    line3 = json['line3'];
    transportId = json['transportId'];
    transportName = json['transportName'];
    agentId = json['agentId'];
    agentName = json['agentName'];
    hasteId = json['hasteId'];
    hasteName = json['hasteName'];
    station = json['station'];
    rateCateId = json['rateCateId'];
    rateCateName = json['rateCateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['line1'] = line1;
    data['line2'] = line2;
    data['line3'] = line3;
    data['transportId'] = transportId;
    data['transportName'] = transportName;
    data['agentId'] = agentId;
    data['agentName'] = agentName;
    data['hasteId'] = hasteId;
    data['hasteName'] = hasteName;
    data['station'] = station;
    data['rateCateId'] = rateCateId;
    data['rateCateName'] = rateCateName;
    return data;
  }
}