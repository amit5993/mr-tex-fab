import 'package:td/model/common_response.dart';

import '../api/rest_ds.dart';
import '../model/user_manager_response.dart';

abstract class UserManagerView {
  void onUserManagerSuccess(UserManagerResponse data);

  void onDeleteUserSuccess(CommonResponse data, int index);

  void onError(int errorCode);
}

class UserManagerPresenter {
  UserManagerView view;
  RestDataSource api = RestDataSource();

  UserManagerPresenter(this.view);

  getUserManagerList(int page, String search, String sortOrder, bool isDescending) async {
    try {
      var data = await api.getUserManagerList(page, search,  sortOrder,  isDescending);
      view.onUserManagerSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  deleteUser(int index,int clientId, int userId) async {
    try {
      var data = await api.deleteUser(clientId, userId);
      view.onDeleteUserSuccess(data, index);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }
}
