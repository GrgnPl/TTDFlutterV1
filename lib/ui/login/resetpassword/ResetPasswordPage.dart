import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ttd/ui/login/resetpassword/ResetPasswordPageViewModel.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

class ResetPasswordPage extends StatelessWidget {
  late ResetPasswordPageViewModel _resetPasswordViewModel;

  @override
  Widget build(BuildContext context) {
    _resetPasswordViewModel = Get.put(ResetPasswordPageViewModel());
    TextEditingController emailController = TextEditingController();
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
              /*Row(
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      TTDNavigator().pop();
                    },
                  ),
                ],
              ),*/
              SizedBox(height: 20.0),
              Text(
                'E-postanızı girin, size şifreyi sıfırlamanız için bir bağlantı göndereceğiz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Email Adresi',
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
                controller: emailController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF8F8F8),
                  hintText: 'Email Adresiniz', // İsteğe bağlı varsayılan bir numara formatı
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide.none,
                  ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black,
                    ), // Text içeriği için padding ayarla

                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                    String email = emailController.text;
                    _resetPasswordViewModel.forgotPass(email);
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
                      'Şifreyi Sıfırla',
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
