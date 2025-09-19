import 'package:td/model/dashboard_request.dart';
import 'package:td/model/role_response.dart';

import '../api/rest_ds.dart';
import '../model/common_response.dart';
import '../model/dashboard_response.dart';
import '../model/login_response.dart';
import '../model/user_manager_response.dart';
import '../model/user_verification_response.dart';

abstract class DashboardView {
  void onSuccess(DashboardResponse data);

  void onError(int errorCode);
}

class DashboardPresenter {
  DashboardView view;
  RestDataSource api = RestDataSource();

  DashboardPresenter(this.view);

  getDashboard(DashboardRequest request) async {
    try {
      var data = await api.getDashboard(request);
      view.onSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }
}
