import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ttd/services/common/TTDCameraService.dart';
import 'package:ttd/ui/home/components/BottomNavigation.dart';
import 'package:ttd/ui/home/profile/ProfilePage.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

import '../../utils/servicelocator/TTDServiceLocator.dart';
import 'NavigationPageViewModel.dart';
import 'duty/DutyPage.dart';
import 'home/HomePage.dart';
import 'home/HomePageViewModel.dart';

class NavigationPage extends StatelessWidget {
  late NavigationPageViewModel _navigationPageViewModel;
  ITTDCameraService? _cameraService = TTDServiceLocator().get<ITTDCameraService>();
  final TabItem initialTab;

  NavigationPage({super.key, this.initialTab = TabItem.home}) {
    // Initialize HomePageViewModel once
    if (!Get.isRegistered<HomePageViewModel>()) {
      Get.put(HomePageViewModel());
    }
  }

  @override
  Widget build(BuildContext context) {
    // View modelleri başlat
    _navigationPageViewModel = Get.put(NavigationPageViewModel());

    // Set initial tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialTab != TabItem.home) {
        _navigationPageViewModel.changeTab(initialTab, context);
      }
    });

    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Çıkış Yap'),
            content: Text('Uygulamadan çıkmak istiyor musunuz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Hayır',
                  style: TextStyle(
                    color: Color(0xFF172a31),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Evet',
                  style: TextStyle(
                    color: Color(0xFF172a31),
                  ),
                ),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          onPressed: () async {
            _navigationPageViewModel.gotoFirstDutyQR();
          },
          child: Icon(
            Icons.qr_code,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() => IndexedStack(
                index: _navigationPageViewModel.currentTab.value.index,
                children: [
                  HomePage(),
                  DutyPage(),
                  ProfilePage(),
                ],
              )),
            ),
            Obx(() => _navigationPageViewModel.currentTab.value == TabItem.home 
              ? Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                    bottom: 2.h,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      (Get.find<HomePageViewModel>()).showBreakRequestDialog(Get.context!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF172a31),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                    child: Text(
                      'Mola talebi oluştur',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink()
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigation(
          tabController: _navigationPageViewModel.tabController!.value,
          unreadNotificationCount: 0,
          onSelectedTab: (value) {
            if (value == _navigationPageViewModel.currentTab.value) {
              TTDNavigator().popUntilCurrentTab();
            } else {
              _navigationPageViewModel.changeTab(value, context);
            }
          },
        ),
      ),
    );
  }
}