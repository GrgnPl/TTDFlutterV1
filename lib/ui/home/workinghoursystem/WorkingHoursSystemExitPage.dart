import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ttd/ui/home/workinghoursystem/WorkingHoursSystemExitPageViewModel.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../services/common/TTDCameraService.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../camera/TakePhotoPageViewModel.dart';
import '../qr/StartDutyPageViewModel.dart';
import 'WorkingHourSystemPageViewModel.dart';

class WorkingHoursSystemExitPage extends StatelessWidget {
  final ITTDCameraService? _cameraService = TTDServiceLocator().get<ITTDCameraService>();
  late WorkingHourSystemPageExitViewModel workingHourSystemPageViewModel;
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();

  @override
  Widget build(BuildContext context) {
    workingHourSystemPageViewModel = Get.put(WorkingHourSystemPageExitViewModel());
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
                  workingHourSystemPageViewModel.finishWork("B");

                  if (_cameraService != null) {
                    String? qrResult = await _cameraService!.scan();
                    if (qrResult == null) {
                      print("İşlem iptal edildi.");
                      return;
                    }

                    print("QR Kodu Sonucu: $qrResult");
                    Uri uri = Uri.parse(qrResult);

                    // URL'nin son segmentini alıyoruz
                    String? id = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;

                    if (id != null) {
                      print("Vardiya ID'si: $id");
                      workingHourSystemPageViewModel.finishWork(id);
                    } else {
                      print("Vardiya ID'si alınamadı.");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2D75FD),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: Container(
                  padding: EdgeInsets.fromLTRB(50, 16, 50, 16),
                  child: Text(
                    'Vardiyayı Bitirmek İçin Qr Kodu Okutunuz',
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