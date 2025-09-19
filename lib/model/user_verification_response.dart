class UserVerificationResponse {
  LoginData? loginData;
  bool? success;
  String? resultMessage;

  UserVerificationResponse({this.loginData, this.success, this.resultMessage});

  UserVerificationResponse.fromJson(Map<String, dynamic> json) {
    loginData = json['value'] != null ? LoginData.fromJson(json['value']) : null;
    success = json['success'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (loginData != null) {
      data['value'] = loginData!.toJson();
    }
    data['success'] = success;
    data['resultMessage'] = resultMessage;
    return data;
  }
}

class LoginData {
  String? smsurl;
  bool? isOTP;
  String? otp;
  String? mobileNo;
  String? email;
  bool? deviceLock;

  LoginData(
      {this.smsurl,
        this.isOTP,
        this.otp,
        this.mobileNo,
        this.email,
        this.deviceLock});

  LoginData.fromJson(Map<String, dynamic> json) {
    smsurl = json['smsurl'];
    isOTP = json['isOTP'];
    otp = json['otp'];
    mobileNo = json['mobileNo'];
    email = json['email'];
    deviceLock = json['deviceLock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['smsurl'] = smsurl;
    data['isOTP'] = isOTP;
    data['otp'] = otp;
    data['mobileNo'] = mobileNo;
    data['email'] = email;
    data['deviceLock'] = deviceLock;
    return data;
  }
}