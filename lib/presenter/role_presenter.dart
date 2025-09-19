import 'package:td/model/role_response.dart';

import '../api/rest_ds.dart';
import '../model/login_response.dart';
import '../model/user_verification_response.dart';

abstract class RoleView {
  void onRoleSuccess(RoleResponse data);

  void onError(int errorCode);
}

class RolePresenter {
  RoleView view;
  RestDataSource api = RestDataSource();

  RolePresenter(this.view);

  getRole(String spName, int page, String search) async {
    try {
      var data = await api.getRole(spName, page, search);
      view.onRoleSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
