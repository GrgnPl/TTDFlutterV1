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
import 'CompletedDutyPageViewModel.dart';
import '../uncompletedDuty/UnCompletedDutyPageViewModel.dart';
import 'package:sizer/sizer.dart';
import 'package:ttd/models/rest/responses/duty/dutyForNow/DutyForNowResponse.dart';

class CompletedDutyPage extends StatelessWidget {
  final CompletedDutyPageViewModel viewModel = Get.put(CompletedDutyPageViewModel());

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              "Tamamlanmış Görevler",
              style: TextStyle(
                color: Color(0xFF172a31),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (viewModel.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF172a31)),
                  ),
                );
              }

              if (viewModel.dutyList.isEmpty) {
                return Center(
                  child: Text(
                    'Tamamlanmış görev bulunmamaktadır',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: viewModel.dutyList.length,
                itemBuilder: (context, index) {
                  var duty = viewModel.dutyList[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                      color: Color(0xFF172a31),
                      borderRadius: BorderRadius.circular(2.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      title: Text(
                        duty.dutyTitle ?? "Bilinmeyen Görev",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: duty.dldDescription != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: Text(
                                duty.dldDescription!,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.sp,
                                ),
                              ),
                            )
                          : null,
                      trailing: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 6.w,
                      ),
                      onTap: () {
                        if (duty.id != null) {
                          TTDNavigator().pushToMain(
                            DutySituationPage(dutyId: duty.id!),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}