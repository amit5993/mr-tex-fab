import '../api/rest_ds.dart';
import '../model/common_response.dart';
import '../model/filter_response.dart';
import '../model/issue_entry_response.dart';
import '../model/login_response.dart';
import '../model/user_verification_response.dart';

abstract class IssueListView {
  void onGetIssueSuccess(IssueEntryResponse data);
  void onDeleteIssue(CommonResponse data);

  void onError(int errorCode);
}

class IssueListPresenter {
  IssueListView view;
  RestDataSource api = RestDataSource();

  IssueListPresenter(this.view);

  getIssueList(int typeId, int page, String search) async {
    try {
      var data = await api.getIssueList(typeId, page, search);
      view.onGetIssueSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  deleteIssue(int typeId, int page, String search) async {
    try {
      var data = await api.deleteIssue(typeId, page, search);
      view.onDeleteIssue(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }
}
