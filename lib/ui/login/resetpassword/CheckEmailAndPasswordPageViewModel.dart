import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ttd/ui/login/resetpassword/ChangePasswordPage.dart';

import '../../../rest/emp/PersonnelRestService.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../../ViewModelBase.dart';

class CheckEmailAndPasswordPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();

  var isResendEnabled = false.obs;
  var timerText = '03:00'.obs;
  Timer? _timer;
  int _remainingSeconds = 180;

  CheckEmailAndPasswordPageViewModel() {
    initPage();
  }

  initPage() async {
    startTimer();  // Sayfa başlarken zamanlayıcıyı başlat
  }

  // Anahtar kod kontrolü
  checkEmailAndKey(String email, String key) async {
    try {
      var queryParams = {'email': email, 'key': key};
      var response = await _personnelRestService!.employeeCheckKey(queryParams);
      print('Response: $response');
      Fluttertoast.showToast(
        msg: response != null
            ? "Başarıyla Anahtar Girildi."
            : "Lütfen Mailinize Gelen Anahtar Kodunu Doğru Giriniz!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: response != null ? Colors.green : Colors.red,
        textColor: Colors.white,
      );
      TTDNavigator().pushToMain(ChangePasswordPage(privateKey: key,));
    } catch (e) {
      print('View Model Error: $e');
    }
  }

  // Sıfırlama maili gönderme
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
      startTimer(); // Tekrar kod gönderildiğinde zamanlayıcıyı sıfırla
    } catch (e) {
      print('View Model Error: $e');
    }
  }

  // Zamanlayıcıyı başlat
  void startTimer() {
    _remainingSeconds = 180;
    isResendEnabled.value = false; // Başlangıçta tekrar kod gönderme aktif olmasın
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        int minutes = _remainingSeconds ~/ 60;
        int seconds = _remainingSeconds % 60;
        timerText.value = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      } else {
        timer.cancel();
        isResendEnabled.value = true; // 3 dakika dolunca buton aktif olur
      }
    });
  }
}