class OtpResponse {
  String? status;
  String? message;
  Data? data;
  double? responsetime;

  OtpResponse({this.status, this.message, this.data, this.responsetime});

  OtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    responsetime = json['responsetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['responsetime'] = this.responsetime;
    return data;
  }
}

class Data {
  bool? connStatus;
  List<String>? messageIDs;

  Data({this.connStatus, this.messageIDs});

  Data.fromJson(Map<String, dynamic> json) {
    connStatus = json['connStatus'];
    messageIDs = json['messageIDs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connStatus'] = this.connStatus;
    data['messageIDs'] = this.messageIDs;
    return data;
  }
}
