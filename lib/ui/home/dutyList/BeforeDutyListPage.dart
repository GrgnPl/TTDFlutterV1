import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';
import 'package:ttd/models/rest/responses/duty/Duty.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDuty.dart';

import '../../../models/rest/responses/duty/roomDuty/Tasks.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../camera/TakePhotoPageViewModel.dart';
import 'BeforeDutyListPageViewModel.dart';


class BeforeDutyListPage extends StatelessWidget {
  final String dutyId;
  final takePhotoViewModel = Get.put(TakePhotoPageViewModel());
  final beforeDutyListViewModel = Get.put(BeforeDutyListPageViewModel());

  BeforeDutyListPage({required this.dutyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.h,
        backgroundColor: Color(0xFF172a31),
        centerTitle: true,
        title: Text(
          'Görev Detayları',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 7.w),
          onPressed: () => TTDNavigator().pop(),
        ),
      ),
      body: FutureBuilder<void>(
        future: takePhotoViewModel.getDutyByDutyId(dutyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF172a31)),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 15.w, color: Colors.red),
                  SizedBox(height: 2.h),
                  Text(
                    'Hata oluştu: ${snapshot.error}',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (dutyId == null || dutyId.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber, size: 15.w, color: Colors.orange),
                  SizedBox(height: 2.h),
                  Text(
                    'Görev bulunamadı.',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            );
          } else {
            var activeTasks = takePhotoViewModel.dutyList.where((task) => task.status == true).toList();
            if (activeTasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 15.w, color: Colors.blue),
                    SizedBox(height: 2.h),
                    Text(
                      'Bu Odaya Atanmış Görev Yoktur',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            var gorevAdi = takePhotoViewModel.dutyList.first.dutyTitle;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$gorevAdi",
                    style: TextStyle(
                      color: Color(0xFF172a31),
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: takePhotoViewModel.dutyList.first.task?.length ?? 0,
                      itemBuilder: (context, index) {
                        var task = takePhotoViewModel.dutyList.first.task![index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.only(bottom: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(3.w),
                            leading: Icon(
                              Icons.task_alt,
                              color: Color(0xFF172a31),
                              size: 8.w,
                            ),
                            title: Text(
                              task.taskName ?? 'Bilinmeyen Görev',
                              style: TextStyle(
                                color: Color(0xFF172a31),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: Text(
                                task.taskDescription ?? 'Açıklama yok',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: SizedBox(
                      width: 90.w,
                      height: 7.h,
                      child: ElevatedButton(
                        onPressed: () {
                          print("Giden duty ID ${dutyId}");
                          beforeDutyListViewModel.showSafetyMeasuresDialog(context, dutyId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF172a31),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          'Göreve Başla',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}