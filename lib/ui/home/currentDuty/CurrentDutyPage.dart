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
import 'package:sizer/sizer.dart';

import '../../../models/rest/responses/duty/dutyByBranchId/DutyData.dart';
import '../../../models/rest/responses/profil/GetByImagesByEmployeeId.dart';
import '../../login/LoginPage.dart';
import '../NavigationPage.dart';
import '../components/BottomNavigation.dart';
import 'CurrentDutyPageViewModel.dart';

class CurrentDutyPage extends StatelessWidget {
  final viewModel = Get.put(CurrentDutyPageViewModel());

  Future<void> _refreshData() async {
    try {
      await viewModel.updateListView();
    } catch (e) {
      print('Yenileme hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        TTDNavigator().pushToMain(NavigationPage(initialTab: TabItem.duty));
        return false;
      },
      child: Scaffold(
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
            onPressed: () {
              TTDNavigator().pushToMain(NavigationPage(initialTab: TabItem.duty));
            },
          ),
        ),
        body: RefreshIndicator(
          color: Color(0xFF172a31),
          onRefresh: _refreshData,
          child: Obx(() {
            if (viewModel.isLoadingDutys.value) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF172a31)),
                ),
              );
            }

            if (viewModel.activeDuties.isEmpty) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: 100.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_outlined, size: 15.w, color: Colors.blue),
                        SizedBox(height: 2.h),
                        Text(
                          'Aktif görev bulunmamaktadır',
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Aktif Görevler",
                        style: TextStyle(
                          color: Color(0xFF172a31),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Divider(color: Colors.grey.withOpacity(0.3)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: viewModel.activeDuties.length,
                    itemBuilder: (context, index) {
                      var duty = viewModel.activeDuties[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(3.w),
                          title: Text(
                            duty?.task?.first.taskName ?? "Görev Adı: Bilinmiyor",
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
                                      duty?.dldDescription ?? 'Açıklama bulunmuyor',
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
                            Icons.arrow_forward_ios,
                            color: Color(0xFF172a31),
                            size: 5.w,
                          ),
                          onTap: () {
                            if (duty?.id != null) {
                              TTDNavigator().pushToMain(
                                DutySituationPage(dutyId: duty!.id!),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
