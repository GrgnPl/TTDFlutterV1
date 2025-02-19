import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ttd/models/rest/requests/empforgotpass/EmpForgotPasswordRequest.dart';
import 'package:ttd/ui/login/resetpassword/CheckEmailAndPasswordPage.dart';

import '../../../models/domain/common/AuthModel.dart';
import '../../../models/rest/requests/empregister/EmpRegisterRequest.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../../ViewModelBase.dart';
import '../../home/NavigationPage.dart';

class ResetPasswordPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();

  ResetPasswordPageViewModel() {
    initPage();
  }
  initPage() async{
  }

  forgotPass(String email) async {
    try {
      var queryParams = {'email': email};
      var response = await _personnelRestService!.employeeForgotPass(queryParams);
      print('Response: $response');
      Fluttertoast.showToast(
        msg: response != null
            ? "Sıfırlama Linki Başarıyla Gönderildi."
            : "Sıfırlama Linki Gönderimi Başarısız. Lütfen Mailinizin Doğru Olduğunu Kontrol Edin.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: response != null ? Colors.green : Colors.red,
        textColor: Colors.white,
      );
      TTDNavigator().pushToMain(CheckEmailAndPasswordPage(email: email,));
    } catch (e) {
      print('View Model Error: $e');
    }
  }

}