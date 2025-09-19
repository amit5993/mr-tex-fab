import '../api/rest_ds.dart';
import '../model/approval_pending_response.dart';
import '../model/common_response.dart';
import '../model/filter_response.dart';
import '../model/issue_entry_response.dart';
import '../model/login_response.dart';
import '../model/user_verification_response.dart';

abstract class ApprovalPendingView {
  void onGetListSuccess(ApprovalPendingResponse data);
  void onsetApprovalCancelSuccess(CommonResponse data);

  void onError(int errorCode);
}

class ApprovalPendingPresenter {
  ApprovalPendingView view;
  RestDataSource api = RestDataSource();

  ApprovalPendingPresenter(this.view);

  getApprovalPendingList(int typeId, int page, String search) async {
    try {
      var data = await api.getApprovalPendingList(typeId, page, search);
      view.onGetListSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  setApprovalCancel(int typeId, int trnId, int srNo, bool isApprove, String remark) async {
    try {
      var data = await api.setApprovalCancel(typeId, trnId, srNo, isApprove, remark);
      view.onsetApprovalCancelSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
