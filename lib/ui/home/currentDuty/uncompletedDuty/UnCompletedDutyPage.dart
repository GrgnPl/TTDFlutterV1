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

class UnCompletedDutyPage extends StatelessWidget {
  final UnCompletedDutyPageViewModel viewModel = Get.put(UnCompletedDutyPageViewModel());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          bool exit = await _onWillPop(context);
          return exit;
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Color(0xFF172a31),
            centerTitle: true, // Title'ı ortalamak için yeterli
            title: Image.asset(
              'assets/1.png',
              width: 100,
              height: 100,
            ),
          ),
          body: Obx(() {
            Container(
              padding: const EdgeInsets.only(top: 20.0, left: 20.0),
              child: Text(
                "Tamamlanmamış Görevler",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            );
            if (viewModel.dutyList.isEmpty) {
              return Center(child: Text('Tamamlanmamış Görev Yok'));
            } else {
              return ListView.builder(
                itemCount: viewModel.dutyList.length,
                itemBuilder: (context, index) {
                  var duty = viewModel.dutyList[index];
                  String roomName = duty?.dutyTitle ?? "Unknown";
                  String? dutyID = duty?.id;

                  return Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF172a31),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        if (dutyID != null) {
                          TTDNavigator().pushToMain(DutySituationPage(dutyId: dutyID));
                        }
                      },
                      child: Center(
                        child: Text(
                          roomName,
                          style: TextStyle(color: Colors.white,fontSize: 16),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool exit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit'),
        content: Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
    return exit;
  }
}