

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttd/ui/ViewModelBase.dart';
import 'package:ttd/ui/home/components/BottomNavigation.dart';
import 'package:ttd/ui/home/qr/StartDutyPage.dart';

import '../../rest/emp/PersonnelRestService.dart';
import '../../utils/navigation/TTDNavigator.dart';
import '../../utils/servicelocator/TTDServiceLocator.dart';

class NavigationPageViewModel extends ViewModelBase with GetSingleTickerProviderStateMixin{
  RxInt currentTabIndex = 0.obs;
  RxInt currentStateIndex = 0.obs;
  var currentTab = TabItem.home.obs;
  Rx<TabController>? tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this).obs;
  }
  
  
  gotoFirstDutyQR(){
    TTDNavigator().pushToMain(StartDutyPage());
  }

  void changeTab(TabItem newTab, BuildContext _context) {
    if (newTab.index >= tabController!.value.length) {
      // Geçerli bir indeks olmadığında
      return;
    }
    currentStateIndex.value = newTab.index;
    currentTabIndex.value = newTab.index;
    currentTab.value = newTab;
    tabController!.value.animateTo(currentTabIndex.value);
  }
}