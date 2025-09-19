import 'package:td/model/common_response.dart';

import '../api/rest_ds.dart';
import '../model/config_app_menu_response.dart';

abstract class ConfigurationView {
  void onGetConfigurationDataSuccess(ConfigAppMenuResponse data);
  void onSetConfigurationDataSuccess(CommonResponse data);

  void onError(int errorCode);
}

class ConfigurationPresenter {
  ConfigurationView view;
  RestDataSource api = RestDataSource();

  ConfigurationPresenter(this.view);

  getAppConfig(int roleId, int module) async {
    try {
      var data = await api.getAppConfig(roleId, module);
      view.onGetConfigurationDataSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  setAppConfig(int roleId, int id, int value, String module) async {
    try {
      var data = await api.setAppConfig(roleId, id, value, module);
      view.onSetConfigurationDataSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }
}
