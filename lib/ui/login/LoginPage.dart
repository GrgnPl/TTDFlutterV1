import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttd/ui/login/LoginPageViewModel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'emplogin/PersonelLoginPageViewModel.dart';

class LoginPage extends StatelessWidget {
  late LoginPageViewModel loginPageViewModel;
  late PersonelLoginPageViewModel _personelLoginViewModel;

  @override
  Widget build(BuildContext context) {
    loginPageViewModel = Get.put(LoginPageViewModel());
    _personelLoginViewModel = Get.put(PersonelLoginPageViewModel());

    // Uygulama açıldığında controlRemember fonksiyonunu çağır
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var checkVersion = await _personelLoginViewModel.checkAppVersion();

      if (checkVersion != null && checkVersion.success == true) {

        _personelLoginViewModel.controlRemember();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController ipController = TextEditingController();

            return AlertDialog(
              title: Text("Güncelleme Mevcut"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Uygulamanız güncel değil. Lütfen mağazadan güncelleyin.",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: ipController,
                    decoration: InputDecoration(
                      hintText: "Örnek: https://example.com:2083/api/",
                    ),
                    keyboardType: TextInputType.url,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "İptal",
                    style: TextStyle(color: Color(0xFF172a31)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    String ipAddress = ipController.text;
                    _personelLoginViewModel.saveServerUrl(ipAddress);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Kaydet",
                    style: TextStyle(color: Color(0xFF172a31)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (Platform.isAndroid) {
                      // Play Store yönlendirmesi
                      launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=your.package.name"));
                    } else if (Platform.isIOS) {
                      // Apple Store yönlendirmesi
                      launchUrl(Uri.parse("https://apps.apple.com/us/app/your-app-id"));
                    }
                  },
                  child: Text(
                    "Güncelle",
                    style: TextStyle(color: Color(0xFF172a31)),
                  ),
                ),
              ],
            );
          },
        );
      }
    });

    return Scaffold(
        body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Color(0xFF172A31),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/1.png',
                  width: 200,
                  height: 200,
                ),
              ),
              Positioned(
                bottom: 100,
                left: 20,
                right: 20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Giriş Yap yada Üye Ol",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "TTD Temizlik Takip Sistemleri.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ElevatedButton(
                              onPressed: () {
                                loginPageViewModel.gotoLogin();
                              },
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all<Size>(
                                  Size(300.0, 50.0),
                                ),
                                backgroundColor:
                                MaterialStateProperty.all(Color(0xFF2D76FF)),
                              ),
                              child: Text(
                                "Giriş",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                         /* Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                loginPageViewModel.gotoSignUp();
                              },
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all<Size>(
                                  Size(300.0, 50.0),
                                ),
                                backgroundColor:
                                MaterialStateProperty.all(Color(0xFFE7E7E7)),
                              ),
                              child: Text(
                                "Üye Ol",
                                style: TextStyle(color: Color(0xFF7F77B3)),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            ),
        );
    }
}