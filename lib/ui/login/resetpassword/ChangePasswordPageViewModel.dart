import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ttd/models/rest/requests/empforgotpass/ChangePasswordRequest.dart';
import 'package:ttd/ui/login/emplogin/PersonelLoginPage.dart';

import '../../../rest/emp/PersonnelRestService.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../../ViewModelBase.dart';

class ChangePasswordPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();

  ChangePasswordPageViewModel() {
    initPage();
  }
  initPage() async{
  }

  resetPassword(String email, String password, String privateKey) async {
    try {
      ChangePasswordRequest changePasswordRequest = ChangePasswordRequest(
          email: email,
          newPassword: password,
          privateKey: privateKey
      );
      var response = await _personnelRestService!.changePassword(changePasswordRequest);
      print('Response: $response');
      Fluttertoast.showToast(
        msg: response != null
            ? "Şifre Başarıyla Sıfırlandı."
            : "Şifre Sıfırlama Sırasında Bir Hata Oluştu.Lütfen Tekrar Deneyin.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: response != null ? Colors.green : Colors.red,
        textColor: Colors.white,
      );
      TTDNavigator().pushToMain(PersonelLoginPage());
    } catch (e) {

      print('View Model Error: $e');
    }
  }

}