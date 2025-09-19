import '../api/rest_ds.dart';
import '../model/login_response.dart';
import '../model/user_verification_response.dart';

abstract class LoginView {
  void onUserVerifySuccess(UserVerificationResponse data);
  void onLoginSuccess(LoginResponse data);

  void onError(int errorCode);
}

class LoginPresenter {
  LoginView view;
  RestDataSource api = RestDataSource();

  LoginPresenter(this.view);

  doUserVerification(String userName, String clientCode, String deviceId) async {
    try {
      var data = await api.doUserVerification(userName, clientCode, deviceId);
      view.onUserVerifySuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  doLogin(String userName, String clientCode, String password, String deviceId) async {
    try {
      var data = await api.doLogin(userName, clientCode, password, deviceId);
      view.onLoginSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }
}
