import 'package:td/model/role_response.dart';

import '../api/rest_ds.dart';
import '../model/login_response.dart';
import '../model/party_response.dart';
import '../model/user_verification_response.dart';

abstract class PartyView {
  void onPartySuccess(PartyResponse data);

  void onError(int errorCode);
}

class PartyPresenter {
  PartyView view;
  RestDataSource api = RestDataSource();

  PartyPresenter(this.view);

  getParty(String role, int page, String search) async {
    try {
      var data = await api.getParty(role, page, search);
      view.onPartySuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
