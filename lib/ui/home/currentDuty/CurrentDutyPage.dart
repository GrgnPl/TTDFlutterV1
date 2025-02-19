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

import '../../../models/rest/responses/duty/dutyByBranchId/DutyData.dart';
import '../../../models/rest/responses/profil/GetByImagesByEmployeeId.dart';
import '../../login/LoginPage.dart';
import 'CurrentDutyPageViewModel.dart';

class CurrentDutyPage extends StatelessWidget {
  final DutyPageViewModel viewModel = Get.put(DutyPageViewModel());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Color(0xFF172a31),
          centerTitle: true,  // Title'ı ortalamak için yeterli
          title: Image.asset(
            'assets/1.png',
            width: 100,
            height: 100,
          ),
        ),
        body: Obx(() {
          if (viewModel.isLoadingDutys.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (viewModel.dutyList.isEmpty) {
            return Center(child: Text('Görev bulunamadı.'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Text(
                    "Aktif Görevler",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10), // Başlık ile liste arasına boşluk ekleyelim
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.dutyList.length,
                    itemBuilder: (context, index) {
                      DutyData? duty = viewModel.dutyList[index];
                      String dutyTitle = duty?.dutyTitle ?? "Görev Başlığı Yok";
                      String dutyId = duty?.id ?? "ID Yok";

                      return Container(
                        height: 60,
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFF172a31),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            dutyTitle,
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            // Göreve tıklandığında yapılacak işlemler
                            print('Görev ID: $dutyId');
                            // Burada örneğin detay sayfasına yönlendirme yapabilirsiniz
                            // TTDNavigator().pushToMain(GorevDetayPage(dutyId: dutyId));
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          }
        }),
      ),
    );
  }
}
