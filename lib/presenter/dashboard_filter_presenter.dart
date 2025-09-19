import 'package:td/model/dashboard_request.dart';
import 'package:td/model/role_response.dart';

import '../api/rest_ds.dart';
import '../model/common_response.dart';
import '../model/dashboard_filter_response.dart';
import '../model/dashboard_response.dart';
import '../model/login_response.dart';
import '../model/user_manager_response.dart';
import '../model/user_verification_response.dart';

abstract class DashboardFilterView {
  void onSuccess(DashboardFilterResponse data);

  void onError(int errorCode);
}

class DashboardFilterPresenter {
  DashboardFilterView view;
  RestDataSource api = RestDataSource();

  DashboardFilterPresenter(this.view);

  getDashboardFilter(String search,String sortBy,String mode, String reportGrp, String conum) async {
    try {
      var data = await api.getDashboardFilter( search, sortBy, mode, reportGrp, conum);
      view.onSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }
}
