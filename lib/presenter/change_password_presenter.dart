import 'package:td/model/role_response.dart';

import '../api/rest_ds.dart';
import '../model/common_response.dart';
import '../model/login_response.dart';
import '../model/user_manager_response.dart';
import '../model/user_verification_response.dart';

abstract class ChangePasswordView {
  void onSuccess(CommonResponse data);

  void onError(int errorCode);
}

class ChangePasswordPresenter {
  ChangePasswordView view;
  RestDataSource api = RestDataSource();

  ChangePasswordPresenter(this.view);

  changePassword(String oldPass, String newPass, String userName,
      String clientCode) async {
    try {
      var data =
          await api.changePassword(oldPass, newPass, userName, clientCode);
      view.onSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }
}
