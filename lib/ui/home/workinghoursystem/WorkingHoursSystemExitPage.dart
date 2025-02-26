import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';
import 'package:ttd/ui/home/workinghoursystem/WorkingHoursSystemExitPageViewModel.dart';

import '../../../services/common/TTDCameraService.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import 'WorkingHourSystemPageViewModel.dart';

class WorkingHoursSystemExitPage extends StatelessWidget {
  final ITTDCameraService? _cameraService = TTDServiceLocator().get<ITTDCameraService>();
  late WorkingHourSystemPageExitViewModel workingHourSystemPageExitViewModel;

  @override
  Widget build(BuildContext context) {
    workingHourSystemPageExitViewModel = Get.put(WorkingHourSystemPageExitViewModel());

    return Scaffold(
      backgroundColor: Color(0xFF172a31),
      appBar: AppBar(
        backgroundColor: Color(0xFF172a31),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Image.asset(
                'assets/tara.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 5.h),
            Container(
              width: 90.w,
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              child: ElevatedButton(
                onPressed: () async {
                  //workingHourSystemPageExitViewModel.finishWork("A1");
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
                      workingHourSystemPageExitViewModel.finishWork(id);
                    } else {
                      print("Vardiya ID'si alınamadı.");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2D76FF),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Vardiyayı Bitirmek İçin QR Kodu Okutunuz',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}