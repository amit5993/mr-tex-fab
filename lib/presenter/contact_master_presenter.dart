import 'package:td/model/menu_response.dart';

import '../api/rest_ds.dart';
import '../model/contact_master_response.dart';

abstract class ContactMasterView {
  void onContactMasterSuccess(ContactMasterResponse data);

  void onError(int errorCode);
}

class ContactMasterPresenter {
  ContactMasterView view;
  RestDataSource api = RestDataSource();

  ContactMasterPresenter(this.view);

  getContactMaster(int page, String search) async {
    try {
      var data = await api.getContactMaster(page, search);
      view.onContactMasterSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
