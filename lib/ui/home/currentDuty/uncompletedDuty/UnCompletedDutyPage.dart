import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDuty.dart';
import 'package:ttd/ui/home/additionaltask/AdditionalTaskPage.dart';
import 'package:ttd/ui/home/currentDuty/ditySituation/DutySituationPage.dart';
import 'package:ttd/ui/home/duty/DutyPage.dart';
import 'package:ttd/ui/home/duty/DutyPageViewModel.dart';
import 'package:ttd/ui/home/profile/PersonelUpdatePageViewModel.dart';
import 'package:ttd/ui/home/profile/ProfilePageViewModel.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';
import 'UnCompletedDutyPageViewModel.dart';
import 'package:sizer/sizer.dart';

class UnCompletedDutyPage extends StatelessWidget {
  final viewModel = Get.put(UnCompletedDutyPageViewModel());

  Future<void> _refreshData() async {
    await viewModel.getUncompletedDuties();
  }

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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshIndicator(
        color: Color(0xFF172a31),
        onRefresh: _refreshData,
        child: Obx(() {
          if (viewModel.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF172a31)),
              ),
            );
          }

          if (viewModel.uncompletedDuties.isEmpty) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                height: 100.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 15.w, color: Colors.blue),
                      SizedBox(height: 2.h),
                      Text(
                        'Tamamlanmamış görev bulunmamaktadır',
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
                ),
              ),
            );
          }

          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            itemCount: viewModel.uncompletedDuties.length,
            itemBuilder: (context, index) {
              var duty = viewModel.uncompletedDuties[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(3.w),
                  title: Text(
                    duty.dutyTitle ?? 'Görev Adı: Bilinmiyor',
                    style: TextStyle(
                      color: Color(0xFF172a31),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Icon(Icons.description, size: 5.w, color: Colors.grey[600]),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              duty.dldDescription ?? 'Açıklama bulunmuyor',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      if (duty.task != null && duty.task!.isNotEmpty && duty.task!.first.taskDescription != null)
                        Row(
                          children: [
                            Icon(Icons.task, size: 5.w, color: Colors.grey[600]),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                duty.task!.first.taskDescription!,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.warning_amber,
                    color: Colors.orange,
                    size: 8.w,
                  ),
                  onTap: () => viewModel.goToDutyDetail(duty.id ?? ''),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}