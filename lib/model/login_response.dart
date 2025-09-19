class LoginResponse {
  Value? value;
  bool? success;
  String? resultMessage;

  LoginResponse({this.value, this.success, this.resultMessage});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    value = json['value'] != null ? Value.fromJson(json['value']) : null;
    success = json['success'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (value != null) {
      data['value'] = value!.toJson();
    }
    data['success'] = success;
    data['resultMessage'] = resultMessage;
    return data;
  }
}

class Value {
  String? token;
  String? firstName;
  String? companyName;
  String? clientLogo;
  String? lastUpload;
  int? companyId;
  String? fromDate;
  String? uptoDate;
  String? url;
  int? clientId;
  String? roleName;

  Value(
      {this.token,
        this.firstName,
        this.clientLogo,
        this.lastUpload,
        this.companyId,
        this.fromDate,
        this.uptoDate,
        this.url,
        this.clientId,
        this.roleName});

  Value.fromJson(Map<String, dynamic> json) {
    token = json['token'] ?? '';
    firstName = json['firstName'] ?? '';
    companyName = json['companyName'] ?? '';
    clientLogo = json['clientLogo'] ?? '';
    lastUpload = json['lastUpload'] ?? '';
    companyId = json['companyId'];
    fromDate = json['fromDate'] ?? '';
    uptoDate = json['uptoDate'] ?? '';
    url = json['url'] ?? '';
    clientId = json['clientId'];
    roleName = json['roleName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['firstName'] = firstName;
    data['companyName'] = companyName;
    data['clientLogo'] = clientLogo;
    data['lastUpload'] = lastUpload;
    data['companyId'] = companyId;
    data['fromDate'] = fromDate;
    data['uptoDate'] = uptoDate;
    data['url'] = url;
    data['clientId'] = clientId;
    data['roleName'] = roleName;
    return data;
  }
}