import 'package:td/model/common_response.dart';
import 'package:td/model/menu_response.dart';

import '../api/rest_ds.dart';
import '../model/app_initial_response.dart';
import '../model/filter_response.dart';
import '../model/login_response.dart';
import '../model/user_verification_response.dart';
import '../model/version_update_response.dart';

abstract class MainView {
  void getAppInitialAPI(AppInitialResponse data);
  // void onMenuListSuccess(MenuResponse data);
  // void onDrawerMenuListSuccess(MenuResponse data);
  void onCompanyListSuccess(FilterResponse data);
  void onUpdateCompanySuccess(CommonResponse data, String compId, String compName);
  void onLogoutSuccess(CommonResponse data);
  // void onVersionUpdateSuccess(VersionUpdateResponse data);

  void onError(int errorCode);
}

class MainPresenter {
  MainView view;
  RestDataSource api = RestDataSource();

  MainPresenter(this.view);

  getAppInitialAPI() async {
    try {
      var data = await api.getAppInitialAPI();
      view.getAppInitialAPI(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  // getAllMenu() async {
  //   try {
  //     var data = await api.getAllMenu();
  //     view.onMenuListSuccess(data);
  //   } on Exception catch (error) {
  //     view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
  //   }
  // }
  //
  // getDrawerMenu() async {
  //   try {
  //     var data = await api.getDrawerMenu();
  //     view.onDrawerMenuListSuccess(data);
  //   } on Exception catch (error) {
  //     view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
  //   }
  // }

  // checkVersionUpdate() async {
  //   try {
  //     var data = await api.checkVersionUpdate();
  //     view.onVersionUpdateSuccess(data);
  //   } on Exception catch (error) {
  //     view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
  //   }
  // }

  getCompany() async {
    try {
      var data = await api.getReportFilter('App_PrcCompanyLst', 0, '');
      view.onCompanyListSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  setCompany(String compId, String compName) async {
    try {
      var data = await api.setDefaultComp(compId, compName);
      view.onUpdateCompanySuccess(data, compId, compName);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  doLogout() async {
    try {
      var data = await api.doLogout();
      view.onLogoutSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }


}
