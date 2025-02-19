

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttd/services/common/TTDCameraService.dart';
import 'package:ttd/ui/home/components/BottomNavigation.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

import '../../utils/servicelocator/TTDServiceLocator.dart';
import 'NavigationPageViewModel.dart';

class NavigationPage extends StatelessWidget {
  late NavigationPageViewModel _navigationPageViewModel;
  ITTDCameraService? _cameraService = TTDServiceLocator().get<ITTDCameraService>();

  NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    _navigationPageViewModel = Get.put(NavigationPageViewModel());
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () async {
          _navigationPageViewModel.gotoFirstDutyQR();
        },
        child: Icon(
          Icons.qr_code,
          color: Colors.black, // Icon rengini görünür hale getirmek için ekledik
        ),
        backgroundColor: Colors.white, // Butonun arkaplan rengini belirleyin
        foregroundColor: Colors.black, // Icon'un rengini belirleyin
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _navigationPageViewModel.tabController!.value,
        children: TTDNavigator.navigators,  // Buradaki children dizisi 3 eleman içeriyorsa indeks hatası oluşur.
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
    );
  }
}