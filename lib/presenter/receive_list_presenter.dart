import '../api/rest_ds.dart';
import '../model/common_response.dart';
import '../model/filter_response.dart';
import '../model/issue_entry_response.dart';
import '../model/login_response.dart';
import '../model/receive_entry_response.dart';
import '../model/user_verification_response.dart';

abstract class ReceiveListView {
  void onGetReceiveSuccess(ReceiveListResponse data);
  void onDeleteReceive(CommonResponse data);

  void onError(int errorCode);
}

class ReceiveListPresenter {
  ReceiveListView view;
  RestDataSource api = RestDataSource();

  ReceiveListPresenter(this.view);

  getReceiveList(int typeId, int page, String search) async {
    try {
      var data = await api.getReceiveList(typeId, page, search);
      view.onGetReceiveSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  deleteReceive(int typeId, int page, String search) async {
    try {
      var data = await api.deleteReceive(typeId, page, search);
      view.onDeleteReceive(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }
}
