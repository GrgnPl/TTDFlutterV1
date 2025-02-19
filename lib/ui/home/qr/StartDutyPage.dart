import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ttd/ui/home/finishDuty/FinishTakePhotoPageViewModel.dart';
import 'package:ttd/ui/home/qr/StartDutyPageViewModel.dart';

import '../../../services/common/TTDCameraService.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../camera/TakePhotoPageViewModel.dart';
import '../home/HomePage.dart';

class StartDutyPage extends StatelessWidget {
  final ITTDCameraService? _cameraService = TTDServiceLocator().get<ITTDCameraService>();
  final takePhotoViewModel = Get.put(TakePhotoPageViewModel()); // TakePhotoPageViewModel'i kullanıyoruz
  late StartDutyPageViewModel _startDutyPageViewModel;

  @override
  Widget build(BuildContext context) {
    _startDutyPageViewModel = Get.put(StartDutyPageViewModel());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary renk ayarı burada
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Color(0xFF172a31),
          centerTitle: true,  // Title'ı ortalamak için yeterli
          title: Image.asset(
            'assets/1.png',
            width: 100,
            height: 100,
          ),
        ),
        backgroundColor: Color(0xFF172A31),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/tara.png'), // Logo buraya eklenecek
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () async {
                  if (_cameraService != null) {
                    String? qrResult = await _cameraService!.scan();
                    print("QR Kodu Sonucu: $qrResult");
                    if (qrResult != null) {
                      Uri uri = Uri.parse(qrResult);
                      String? id = uri.queryParameters['id'];
                      if (id != null) {
                        print("ID Değeri: $id");
                        await takePhotoViewModel.getDutyFromRoomId(id); // roomId'yi gönderiyoruz
                        if (takePhotoViewModel.roomInfo?.status == false) {
                          Fluttertoast.showToast(
                            msg: "Görev Başlatılamaz. Lütfen Yetkiliye Başvurun.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          TTDNavigator().pushToMain(HomePage()); // HomePage'e yönlendiriyoruz
                        } else {
                          _startDutyPageViewModel.gotoPhoto(id);
                        }
                      } else {
                        print("ID parametresi bulunamadı.");
                      }
                    }
                  }

                  //_startDutyPageViewModel.gotoPhoto("672a6ae08b60fc8409222328");

                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2D75FD),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: Container(
                  padding: EdgeInsets.fromLTRB(50, 16, 50, 16),
                  child: Text(
                    'Qr Kodu Okutunuz',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
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