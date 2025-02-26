import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDuty.dart';
import 'package:ttd/ui/home/camera/TakePhotoPage.dart';
import 'package:ttd/ui/home/camera/TakePhotoPageViewModel.dart';
import 'package:ttd/ui/home/currentDuty/ditySituation/DutySituationPageViewModel.dart';
import 'package:ttd/ui/home/dutyList/BeforeDutyListPage.dart';
import 'package:ttd/ui/home/finishDuty/FinishDutyPage.dart';
import 'package:ttd/ui/home/finishDuty/FinishTakePhotoPage.dart';
import 'package:ttd/ui/home/qr/StartDutyPage.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

import '../../../../models/rest/responses/duty/currentDuty/CurrentDutyResponse.dart';
import '../../../../utils/servicelocator/TTDServiceLocator.dart';

import 'package:flutter/material.dart';

import '../../NavigationPage.dart';
import 'package:sizer/sizer.dart';

class DutySituationPage extends StatelessWidget {
  final String dutyId;

  DutySituationPage({required this.dutyId});

  @override
  Widget build(BuildContext context) {
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => TTDNavigator().pushToMain(NavigationPage()),
        ),
      ),
      body: ProfileBody(dutyId: dutyId),
    );
  }
}

class ProfileBody extends StatelessWidget {
  final viewModel = Get.put(DutySituationPageViewModel());
  final String dutyId;

  ProfileBody({required this.dutyId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CurrentDutyResponse?>(
      future: viewModel.getDutyInfo(dutyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF172a31)),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Hata oluştu: ${snapshot.error}",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red,
              ),
            ),
          );
        }

        var dutyInfo = snapshot.data;
        if (dutyInfo == null) {
          return Center(
            child: Text(
              "Görev Bilgisi Bulunamadı",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    children: [
                      _buildDutyDetailTile(
                        Icons.assignment,
                        'Görev Adı',
                        dutyInfo.dutyTitle ?? "Bilinmiyor",
                      ),
                      Divider(height: 2.h),
                      _buildDutyDetailTile(
                        Icons.date_range,
                        'Görev Tarihleri',
                        'Başlama: ${dutyInfo.dutyStartDate}\nBitiş: ${dutyInfo.dutyEndDate}',
                      ),
                      Divider(height: 2.h),
                      _buildDutyDetailTile(
                        Icons.description,
                        'Görev İçeriği',
                        dutyInfo.task.map((t) => t.taskDescription).join('\n'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              if (dutyInfo.dutyStartDate == "Henüz Başlamadı" && 
                  dutyInfo.dutyEndDate == "Henüz Bitmedi")
                _buildActionButton(
                  'İşe Başla',
                  Icons.play_arrow,
                  Colors.green,
                  () => TTDNavigator().pushToMain(StartDutyPage()),
                )
              else if (dutyInfo.dutyEndDate == "Henüz Bitmedi")
                _buildActionButton(
                  'Görevi Bitir',
                  Icons.check_circle,
                  Colors.blue,
                  () => TTDNavigator().pushToMain(FinishTakePhotoPage(dutyId: dutyInfo.id!)),
                )
              else if (dutyInfo.dutyEndDate != "Henüz Bitmedi")
                _buildActionButton(
                  'İş Bitmiş',
                  Icons.done_all,
                  Colors.grey,
                  () => _showToast("Bu İş Zaten Bitti.", Colors.red),
                )
              else
                _buildActionButton(
                  'Durum Bilinmiyor',
                  Icons.help_outline,
                  Colors.orange,
                  () => _showToast("Geçersiz işlem durumu.", Colors.orange),
                ),
              SizedBox(height: 2.h),
              _buildActionButton(
                'Oda Müsait Değil',
                Icons.do_not_disturb,
                Color(0xFF172a31),
                () => _showUnavailableRoomDialog(context, dutyId),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDutyDetailTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, size: 7.w, color: Color(0xFF172a31)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Color(0xFF172a31),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 7.w, color: Colors.white),
            SizedBox(width: 2.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 12.sp,
    );
  }

  void _showUnavailableRoomDialog(BuildContext context, String dutyId) {
    String? selectedOption;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
          title: Text(
            "Açıklama Seçiniz",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172a31),
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: 80.w,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedOption,
                  hint: Text(
                    "Bir açıklama seçiniz",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  items: [
                    "Oda Dolu",
                    "Oda İstemiyor",
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() => selectedOption = newValue);
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "İptal",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedOption == null) {
                  _showToast("Lütfen bir açıklama seçiniz.", Colors.red);
                  return;
                }
                
                var response = await viewModel.dutyUpdate(dutyId, selectedOption!);
                if (response != null) {
                  _showToast("Güncelleme başarılı.", Colors.green);
                  Navigator.of(context).pop();
                } else {
                  _showToast("Güncelleme sırasında hata oluştu.", Colors.red);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF172a31),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),
              child: Text(
                "Tamam",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}