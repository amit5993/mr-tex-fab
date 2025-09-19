import 'package:td/model/role_response.dart';

import '../api/rest_ds.dart';
import '../model/common_response.dart';
import '../model/login_response.dart';
import '../model/user_manager_response.dart';
import '../model/user_verification_response.dart';

abstract class AddEditUserView {
  void onSuccess(CommonResponse data);

  void onSuccessClearLogins(CommonResponse data);

  void onError(int errorCode);
}

class AddEditUserPresenter {
  AddEditUserView view;
  RestDataSource api = RestDataSource();

  AddEditUserPresenter(this.view);

  updateUser(int clientId, String userName, String password, String fName, String lName, String email, String mobile, int roleId, int partyId,
      String partyName, int companyId, String companyName, bool isActive, bool isOTP, String entryMode, bool isDeviceLock) async {
    try {
      var data = await api.updateUser(clientId, userName, password, fName, lName, email, mobile, roleId, partyId, partyName, companyId, companyName,
          isActive, isOTP, entryMode, isDeviceLock);
      view.onSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  doClearLogins(String userName, String clientCode) async {
    try {
      var data = await api.doClearLogins(userName, clientCode);
      view.onSuccessClearLogins(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }
}
