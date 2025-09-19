class DashboardRequest {
  String? uptoDate;
  String? fromDate;

  DashboardRequest({
    this.uptoDate,
    this.fromDate,
  });

  DashboardRequest.fromJson(Map<String, dynamic> json) {
    fromDate = json['FromDate'];
    uptoDate = json['UptoDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FromDate'] = fromDate;
    data['UptoDate'] = uptoDate;
    return data;
  }
}
