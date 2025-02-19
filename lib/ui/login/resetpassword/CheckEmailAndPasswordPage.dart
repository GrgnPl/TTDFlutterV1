import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ttd/ui/login/resetpassword/CheckEmailAndPasswordPageViewModel.dart';
import 'package:ttd/ui/login/resetpassword/ResetPasswordPageViewModel.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckEmailAndPasswordPage extends StatelessWidget {
  final String email;
  final CheckEmailAndPasswordPageViewModel _checkEmailAndPasswordPageViewModel = Get.put(CheckEmailAndPasswordPageViewModel());
  final TextEditingController keyController = TextEditingController();

  CheckEmailAndPasswordPage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF172A31),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Şifreyi Sıfırla',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Lütfen E-Postanıza Gelen Anahtar Kodunu Giriniz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Anahtar Kodu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: keyController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF8F8F8),
                  hintText: 'Anahtar Kodu',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Obx(() {
                return _checkEmailAndPasswordPageViewModel.isResendEnabled.value
                    ? ElevatedButton(
                  onPressed: () {
                    _checkEmailAndPasswordPageViewModel.forgotPass(email);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2D76FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                    ),
                    child: Text(
                      'Tekrar Kod Gönder',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
                    : Text(
                  'Tekrar Kod Gönder: ${_checkEmailAndPasswordPageViewModel.timerText.value}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                );
              }),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    String key = keyController.text;
                    _checkEmailAndPasswordPageViewModel.checkEmailAndKey(email, key);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2D76FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                    ),
                    child: Text(
                      'Anahtar Kodunu Gönder',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}