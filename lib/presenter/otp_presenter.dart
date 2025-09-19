import 'package:td/model/menu_response.dart';

import '../api/rest_ds.dart';
import '../model/login_response.dart';
import '../model/order_list_response.dart';
import '../model/otp_response.dart';
import '../model/user_manager_response.dart';
import '../model/user_verification_response.dart';

abstract class OtpView {
  void onOtpSendSuccess(OtpResponse data);
  void onLoginSuccess(LoginResponse data);

  void onError(int errorCode);
}

class OtpPresenter {
  OtpView view;
  RestDataSource api = RestDataSource();

  OtpPresenter(this.view);

  callOtpUrl(String url) async {
    try {
      var data = await api.callOtpUrl(url);
      view.onOtpSendSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  doLogin(String userName, String clientCode, String password,String deviceId) async {
    try {
      var data = await api.doLogin(userName, clientCode, password, deviceId);
      view.onLoginSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
