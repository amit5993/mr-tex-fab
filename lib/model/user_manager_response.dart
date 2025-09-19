class UserManagerResponse {
  Value? value;
  bool? success;
  String? resultMessage;

  UserManagerResponse({this.value, this.success, this.resultMessage});

  UserManagerResponse.fromJson(Map<String, dynamic> json) {
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
  List<AppUserListModel>? appUserListModel;
  int? noOfRecoreds;

  Value({this.appUserListModel, this.noOfRecoreds});

  Value.fromJson(Map<String, dynamic> json) {
    if (json['appUserListModel'] != null) {
      appUserListModel = <AppUserListModel>[];
      json['appUserListModel'].forEach((v) {
        appUserListModel!.add(AppUserListModel.fromJson(v));
      });
    }
    noOfRecoreds = json['noOfRecoreds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (appUserListModel != null) {
      data['appUserListModel'] =
          appUserListModel!.map((v) => v.toJson()).toList();
    }
    data['noOfRecoreds'] = noOfRecoreds;
    return data;
  }
}

class AppUserListModel {
  int? userId;
  String? firstName;
  String? lastName;
  String? userName;
  int? clientId;
  String? clientName;
  String? clientCode;
  int? roleId;
  String? roleName;
  int? partyId;
  String? partyName;
  int? companyId;
  String? companyName;
  bool? isActive;
  bool? isDeviceLock;
  String? smSmobile;
  String? emailId;
  bool? isOTP;
  String? password;
  String? content;
  String? lastActive;

  AppUserListModel(
      {this.userId,
        this.firstName,
        this.lastName,
        this.userName,
        this.clientId,
        this.clientName,
        this.clientCode,
        this.roleId,
        this.roleName,
        this.partyId,
        this.partyName,
        this.companyId,
        this.companyName,
        this.isActive,
        this.isDeviceLock,
        this.smSmobile,
        this.emailId,
        this.isOTP,
        this.password,
        this.content,
        this.lastActive,
      });

  AppUserListModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userName = json['userName'];
    clientId = json['clientId'];
    clientName = json['clientName'];
    clientCode = json['clientCode'];
    roleId = json['roleId'];
    roleName = json['roleName'];
    partyId = json['partyId'];
    partyName = json['partyName'];
    companyId = json['companyId'];
    companyName = json['companyName'];
    isActive = json['isActive'];
    isDeviceLock = json['isDeviceLock'] ?? false;
    smSmobile = json['smSmobile'];
    emailId = json['emailId'];
    isOTP = json['isOTP'];
    password = json['password'];
    content = json['content'] ?? '';
    lastActive = json['lastActive'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['userName'] = userName;
    data['clientId'] = clientId;
    data['clientName'] = clientName;
    data['clientCode'] = clientCode;
    data['roleId'] = roleId;
    data['roleName'] = roleName;
    data['partyId'] = partyId;
    data['partyName'] = partyName;
    data['companyId'] = companyId;
    data['companyName'] = companyName;
    data['isActive'] = isActive;
    data['isDeviceLock'] = isDeviceLock;
    data['smSmobile'] = smSmobile;
    data['emailId'] = emailId;
    data['isOTP'] = isOTP;
    data['password'] = password;
    data['content'] = content;
    data['lastActive'] = lastActive;
    return data;
  }
}