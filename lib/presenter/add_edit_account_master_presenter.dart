import 'package:td/model/role_response.dart';

import '../api/rest_ds.dart';
import '../model/common_response.dart';
import '../model/login_response.dart';
import '../model/user_manager_response.dart';
import '../model/user_verification_response.dart';

abstract class AddEditAccountMasterView {
  void onSuccess(CommonResponse data);

  void onError(int errorCode);
}

class AddEditAccountMasterPresenter {
  AddEditAccountMasterView view;
  RestDataSource api = RestDataSource();

  AddEditAccountMasterPresenter(this.view);

  updateAccountMaster(
    String name,
    int type,
    String gST,
    String add1,
    String add2,
    String city,
    String state,
    String pinCode,
    String mobile,
    String phone,
    String email,
    String mobileSMS,
    int transport,
    int station,
    int agentId,
    int group,
    int actionBy,
    int id,
    int schdId,
    String custType,
    String registrationType,
    String district,
    String market,
    String contactPerson,
    String bankName,
    String acountNumber,
    String iFSCCode,
    String branchName,
    String tANNo,
    String pANNo,
    String dhara,
    String mudat,
    String interestRate,
    String crDays,
    String dhara1,
    String dhara2,
    String dhara3,
    String refName,
    String remark,
    String reftxt1,
    String reftxt2,
    String reftxt3,
    String entryMode,
  ) async {
    try {
      var data = await api.updateAccountMaster(
        name,
        type,
        gST,
        add1,
        add2,
        city,
        state,
        pinCode,
        mobile,
        phone,
        email,
        mobileSMS,
        transport,
        station,
        agentId,
        group,
        actionBy,
        id,
        schdId,
        custType,
        registrationType,
        district,
        market,
        contactPerson,
        bankName,
        acountNumber,
        iFSCCode,
        branchName,
        tANNo,
        pANNo,
        dhara,
        mudat,
        interestRate,
        crDays,
        dhara1,
        dhara2,
        dhara3,
        refName,
        remark,
        reftxt1,
        reftxt2,
        reftxt3,
        entryMode,
      );
      view.onSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }
}
