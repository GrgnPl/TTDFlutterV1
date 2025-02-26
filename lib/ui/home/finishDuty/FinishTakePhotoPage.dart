import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:ttd/ui/home/camera/TakePhotoPageViewModel.dart';
import 'package:ttd/ui/home/dutyList/BeforeDutyListPage.dart';
import 'package:ttd/ui/home/finishDuty/FinishTakePhotoPageViewModel.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

import '../../../utils/servicelocator/TTDServiceLocator.dart';

import 'package:flutter/material.dart';


enum CameraType { front, back }
CameraType selectedCamera = CameraType.back;
class FinishTakePhotoPage extends StatelessWidget {
  final String dutyId;
  final viewModel = Get.put(FinishTakePhotoPageViewModel());

  FinishTakePhotoPage({required this.dutyId});

  @override
  Widget build(BuildContext context) {
    viewModel.getDutyByDutyId(dutyId);
    
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.h,
        backgroundColor: Color(0xFF172a31),
        centerTitle: true,
        title: Image.asset(
          'assets/1.png',
          width: 25.w,
          height: 12.h,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 7.w),
          onPressed: () => TTDNavigator().pop(),
        ),
      ),
      backgroundColor: Color(0xFF172A31),
      body: Obx(() => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/photo.png',
                      width: 40.w,
                      height: 25.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Odanın Fotoğrafını Çekiniz',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              _buildButton(
                'Odanın Fotoğrafını Çekiniz',
                Icons.camera_alt,
                Color(0xFF2D75FD),
                () => onImageButtonPressed(ImageSource.camera),
                viewModel.isUploading.value,
              ),
              SizedBox(height: 2.h),
              _buildButton(
                'Oda Müsait Değil',
                Icons.do_not_disturb,
                Colors.red,
                () {
                  if (dutyId != null) {
                    viewModel.gotoDutyList(dutyId);
                  } else {
                    Get.snackbar(
                      'Hata',
                      'Görev bilgisi alınamadı. Lütfen tekrar deneyin.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                viewModel.isUploading.value,
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
    bool isDisabled,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 7.h,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
          elevation: 3,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 7.w, color: Colors.white),
            SizedBox(width: 2.w),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onImageButtonPressed(ImageSource source) async {
    try {
      if (viewModel.isUploading.value) return;

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        preferredCameraDevice: selectedCamera == CameraType.front
            ? CameraDevice.front
            : CameraDevice.rear,
        maxWidth: 1280,
        maxHeight: 960,
        imageQuality: 85,
      );

      if (pickedFile != null && pickedFile.path != null) {
        final File file = File(pickedFile.path);
        
        if (dutyId!= null) {
          // Loading göstergesini göster
          Get.dialog(
            WillPopScope(
              onWillPop: () async => false,
              child: Center(
                child: Container(
                  width: 80.w,
                  padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF172a31)),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Fotoğraf Yükleniyor',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF172a31),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Lütfen Bekleyiniz...',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            barrierDismissible: false,
          );

          try {
            await viewModel.uploadImage(dutyId, file, 2);
          } catch (e) {
            print("Yükleme hatası: $e");
            Get.snackbar(
              'Hata',
              'Fotoğraf yüklenirken bir hata oluştu.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          Get.snackbar(
            'Hata',
            'Görev bilgisi alınamadı. Lütfen tekrar deneyin.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      print("Error picking image: $e");
      Get.snackbar(
        'Hata',
        'Fotoğraf seçilirken bir hata oluştu.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}