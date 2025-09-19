import 'package:td/model/menu_response.dart';

import '../api/rest_ds.dart';
import '../model/common_response.dart';
import '../model/issue_entry_response.dart';
import '../model/login_response.dart';
import '../model/save_issue_request.dart';
import '../model/save_receive_request.dart';
import '../model/user_verification_response.dart';

abstract class AddReceiveEntryView {
  void onSuccessSaveIssue(CommonResponse data);

  void onError(int errorCode);
}

class AddReceiveEntryPresenter {
  AddReceiveEntryView view;
  RestDataSource api = RestDataSource();

  AddReceiveEntryPresenter(this.view);

  saveReceive(SaveReceiveRequest request) async {
    try {
      var data = await api.saveReceive(request);
      view.onSuccessSaveIssue(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
