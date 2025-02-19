import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ttd/models/rest/responses/duty/Duty.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDuty.dart';

import '../../../models/rest/responses/duty/roomDuty/Tasks.dart';
import '../camera/TakePhotoPageViewModel.dart';
import 'BeforeDutyListPageViewModel.dart';


class BeforeDutyListPage extends StatelessWidget {
  final String dutyId;
  final takePhotoViewModel = Get.put(TakePhotoPageViewModel()); // TakePhotoPageViewModel'i kullanıyoruz
  final beforeDutyListViewModel = Get.put(BeforeDutyListPageViewModel()); // BeforeDutyListPageViewModel'i kullanıyoruz

  BeforeDutyListPage({required this.dutyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Görev Detayları', style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Color(0xFF172a31),
      ),
      body: FutureBuilder<void>(
        future: takePhotoViewModel.getDutyFromRoomId(dutyId), // dutyId'ye göre görev detaylarını getir
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          } else if (takePhotoViewModel.roomInfo?.task == null || takePhotoViewModel.roomInfo!.task.isEmpty) {
            return Center(child: Text('Görev bulunamadı.'));
          } else {
            var activeTasks = takePhotoViewModel.roomInfo!.task.where((task) => task.status == true).toList();

            if (activeTasks.isEmpty) {
              return Center(
                child: Text(
                  'Bu Odaya Atanmış Görev Yoktur',
                  style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Yapılacak Görevler", // Görev adı gösteriliyor.
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: activeTasks.length,
                      itemBuilder: (context, index) {
                        var task = activeTasks[index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              'Görev Adı : ${task.taskName}' ?? 'Bilinmeyen Görev',
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              'Görev Açıklaması : ${task.taskDescription}' ?? 'Bilinmeyen Açıklama',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        print("Giden duty ID ${dutyId}");
                        beforeDutyListViewModel.showSafetyMeasuresDialog(context, dutyId); // BeforeDutyListPageViewModel'deki startDuty metodu çalıştırılır
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF172a31),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                        child: Text(
                          'Göreve Başla',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}