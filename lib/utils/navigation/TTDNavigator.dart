import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ttd/main.dart';
import 'package:ttd/ui/home/NavigationPageViewModel.dart';
import 'package:ttd/ui/home/duty/DutyPage.dart';
import 'package:ttd/ui/home/home/HomePage.dart';
import 'package:ttd/ui/home/profile/ProfilePage.dart';


class TTDNavigator {
  static final TTDNavigator _singleton = TTDNavigator._internal();
  TTDNavigator._internal();
  factory TTDNavigator() {
    return _singleton;
  }

  static List<Widget> navigators = [
    Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (route) => MaterialPageRoute(
        settings: route,
        builder: (context) => HomePage(),
      ),
    ),
    Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (route) => MaterialPageRoute(
        settings: route,
        builder: (context) => DutyPage(),
      ),
    ),
    Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (route) => MaterialPageRoute(
        settings: route,
        builder: (context) => ProfilePage(),
      ),
    ),
  ];

  void pushAndRemoveUntil(Widget widget) {
    Get.offAll(() => widget);
  }

  Future<T?> push<T>(Widget widget) async {
    return await Get.to<T>(() => widget);
  }

  void pop() {
    if (Get.currentRoute.isNotEmpty) {
      Get.back();
    }
  }

  void pushToMain(Widget widget) {
    Get.to(widget);
  }

  Future<T?> pushReplacementFromMain<T>(Widget widget) async {
    return await Get.off<T>(() => widget);
  }

  void popUntilCurrentTab() {
    Get.until((route) => route.isFirst);
  }

  void popAllCategory() {
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.until((route) => route.isFirst);
    });
  }

  void popUntilInMain(Widget widget) {
    Get.offAll(widget);
  }
}