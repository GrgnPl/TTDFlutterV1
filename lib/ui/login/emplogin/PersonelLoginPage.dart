import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ttd/ui/home/NavigationPageViewModel.dart';
import 'package:ttd/ui/login/emplogin/PersonelLoginPageViewModel.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../rest/emp/PersonnelRestService.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../../home/notification/NotificationPage.dart';



class PersonelLoginPage extends StatelessWidget {
  late PersonelLoginPageViewModel _personelLoginViewModel;

  @override
  Widget build(BuildContext context) {
    _personelLoginViewModel = Get.put(PersonelLoginPageViewModel());

    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    EdgeInsetsGeometry padding = EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 0);

    // Initialize the Remember Me feature
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var checkVersion = await _personelLoginViewModel.checkAppVersion();

      if (checkVersion != null && checkVersion.success == true) {

        _personelLoginViewModel.controlRemember();
      } else {
        // Versiyon kontrol başarısız, güncelleme mesajı gösteriliyor
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
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color(0xFF172a31),
        centerTitle: true,  // Title'ı ortalamak için yeterli
        title: Image.asset(
          'assets/1.png',
          width: 100,
          height: 100,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController ipController = TextEditingController();

                    // Kaydedilmiş server URL'yi yükleyip TextField'a ekle
                    _personelLoginViewModel.getServerUrl().then((lastSavedUrl) {
                      if (lastSavedUrl != null) {
                        ipController.text = lastSavedUrl; // Mevcut server URL'yi TextField'da göster
                      }
                    });

                    return AlertDialog(
                      title: Text("Ip Adresini Giriniz"),
                      content: TextField(
                        controller: ipController,
                        decoration: InputDecoration(
                          hintText: "Örnek: https://example.com:2083/api/",
                        ),
                        keyboardType: TextInputType.url,
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
                      ],
                    );
                  },
                );
              },
          ),
        ],
      ),
        backgroundColor: Color(0xFF172A31),
        body: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/1.png',
                  width: 200,
                  height: 200,
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Padding(
                    padding: padding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                                Row(
                                  children: [
                                    Text(
                                      'Telefon Numarası',
                                      style: TextStyle(
                                        color: Color(0xFF5F5F61).withOpacity(0.6),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(height: 10),
                              TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  MaskedInputFormatter('(###)-000-####')
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF8F8F8),
                                  hintText: '505 111 22 33',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    'Şifre',
                                    style: TextStyle(
                                      color: Color(0xFF5F5F61).withOpacity(0.6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF8F8F8),
                                  hintText: 'Şifre',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Obx(() => Row(
                                children: [
                                  Checkbox(
                                    value: _personelLoginViewModel.isRemembered.value,
                                    onChanged: (bool? value) {
                                      _personelLoginViewModel.setRememberMe(value ?? false);
                                      if (value == true) {
                                        _personelLoginViewModel.controlRemember();
                                      }
                                    },
                                    checkColor: Colors.white,
                                    activeColor: Color(0xFF2D76FF),
                                  ),
                                  Text(
                                    'Beni Hatırla',
                                    style: TextStyle(color: Colors.black,fontSize: 16),
                                  ),
                                ],
                              )),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    String phoneNumber = phoneController.text
                                        .replaceAll(RegExp(r'[^\d]'), '');
                                    String password = passwordController.text;

                                    _personelLoginViewModel.login(
                                        phoneNumber, password);

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
                                      'Giriş Yap',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  _personelLoginViewModel.gotoForgotPass();
                                },
                                child: Text('Şifremi Sıfırla?'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                left: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Devam ederek Hizmet Şartlarını & Gizlilik Politikasını ',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      'kabul etmiş olursunuz',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            ),
      );
    }
}