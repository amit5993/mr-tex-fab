class CommonResponse {
  bool? success;
  String? resultMessage;

  CommonResponse({this.success, this.resultMessage});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['resultMessage'] = resultMessage;
    return data;
  }
}