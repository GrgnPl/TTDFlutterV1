import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 8.h,
        backgroundColor: Color(0xFF172a31),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            iconSize: 24,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController ipController = TextEditingController();
                  _personelLoginViewModel.getServerUrl().then((lastSavedUrl) {
                    if (lastSavedUrl != null) {
                      ipController.text = lastSavedUrl;
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
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("İptal", style: TextStyle(color: Color(0xFF172a31))),
                      ),
                      TextButton(
                        onPressed: () {
                          _personelLoginViewModel.saveServerUrl(ipController.text);
                          Navigator.of(context).pop();
                        },
                        child: Text("Kaydet", style: TextStyle(color: Color(0xFF172a31))),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              children: [
                SizedBox(height: 5.h),
                Image.asset(
                  'assets/1.png',
                  width: 45.w,
                  height: 20.h,
                ),
                SizedBox(height: 3.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  padding: EdgeInsets.all(5.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Telefon Numarası',
                            style: TextStyle(
                              color: Color(0xFF5F5F61).withOpacity(0.6),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          MaskedInputFormatter('(###)-000-####')
                        ],
                        style: TextStyle(fontSize: 15.sp),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF8F8F8),
                          hintText: '505 111 22 33',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.sp,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.w),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Text(
                            'Şifre',
                            style: TextStyle(
                              color: Color(0xFF5F5F61).withOpacity(0.6),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(fontSize: 15.sp),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF8F8F8),
                          hintText: 'Şifre',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.sp,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.w),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Obx(() => Row(
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: _personelLoginViewModel.isRemembered.value,
                              onChanged: (bool? value) {
                                _personelLoginViewModel.setRememberMe(value ?? false);
                              },
                              checkColor: Colors.white,
                              activeColor: Color(0xFF2D76FF),
                            ),
                          ),
                          Text(
                            'Beni Hatırla',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      )),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            String phoneNumber = phoneController.text
                                .replaceAll(RegExp(r'[^\d]'), '');
                            String password = passwordController.text;
                            _personelLoginViewModel.login(phoneNumber, password);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2D76FF),
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                          ),
                          child: Text(
                            'Giriş Yap',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextButton(
                        onPressed: () {
                          _personelLoginViewModel.gotoForgotPass();
                        },
                        child: Text(
                          'Şifremi Sıfırla?',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 2.h,
            child: Container(
              color: Color(0xFF172A31),
              padding: EdgeInsets.symmetric(
                vertical: 2.h,
                horizontal: 5.w,
              ),
              child: Text(
                'Devam ederek Hizmet Şartlarını & Gizlilik Politikasını\nkabul etmiş olursunuz',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}