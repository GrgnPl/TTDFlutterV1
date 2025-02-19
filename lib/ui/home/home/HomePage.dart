


import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:ttd/models/rest/responses/duty/dutyByEmployeeId/DutyByEmployeeId.dart';
import 'package:ttd/ui/home/camera/TakePhotoPage.dart';
import 'package:ttd/ui/home/currentDuty/appointedDuty/AppointedDutyPage.dart';
import 'package:ttd/ui/home/currentDuty/completedDuty/CompletedDutyPage.dart';
import 'package:ttd/ui/home/currentDuty/CurrentDutyPage.dart';
import 'package:ttd/ui/home/currentDuty/uncompletedDuty/UnCompletedDutyPage.dart';
import 'package:ttd/ui/home/currentDuty/uncompletedDuty/UnCompletedDutyPageViewModel.dart';
import 'package:ttd/ui/home/finishDuty/FinishTakePhotoPage.dart';
import 'package:ttd/ui/home/home/HomePageViewModel.dart';
import 'package:ttd/ui/home/notification/NotificationPage.dart';
import 'package:ttd/ui/home/techninalerror/TechninalErrorPage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/rest/responses/additionaltask/Task.dart';
import '../../../models/rest/responses/duty/roomDuty/RoomDuty.dart';
import '../../../models/rest/responses/duty/roomDuty/Tasks.dart';
import '../../../models/rest/responses/room/GetAllRoomByBranchId.dart';
import '../../../models/rest/responses/room/Room.dart';
import '../../../services/common/TTDCameraService.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../../login/emplogin/PersonelLoginPageViewModel.dart';
import '../dutyList/BeforeDutyListPage.dart';
import '../techninalerror/TechninalErrorPageViewModel.dart';

class HomePage extends StatelessWidget {
  final HomePageViewModel viewModel = Get.put(HomePageViewModel());
  final TextEditingController breakDescriptionController = TextEditingController();
  final TextEditingController breakTimeController = TextEditingController();
  final TextEditingController breakDateController = TextEditingController();
  final ITTDCameraService? _cameraService = TTDServiceLocator().get<ITTDCameraService>();
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();
  late PersonelLoginPageViewModel _personelLoginViewModel;

  @override
  Widget build(BuildContext context) {
    _personelLoginViewModel = Get.put(PersonelLoginPageViewModel());
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Yeni bildirim alındı: ${message.notification?.title}');

      if (viewModel.employeeId != null) {
        // Yeni bildirim geldiğinde bildirim sayısını güncellemek için API'yi tetikleyin
        viewModel.fetchNotificationCount(viewModel.employeeId!);
      } else {
        print('Employee ID null, bildirim sayısı güncellenemedi.');
      }
    });
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color(0xFF172a31),
        centerTitle: true,  // Title'ı ortalamak için yeterli
        title: Image.asset(
          'assets/1.png',
          width: 100,
          height: 100,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                onPressed: () {
                  TTDNavigator().pushToMain(NotificationPage());
                },
              ),
              GetBuilder<HomePageViewModel>(
                builder: (viewModel) {
                  if (viewModel.notificationCount.value > 0) {
                    return Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            '${viewModel.notificationCount.value}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: viewModel.refreshRoomDutyCounts(), // İlk yüklemede verileri yeniler
        builder: (context, snapshot) {
          if (viewModel.roomDutyCountLoading.value) {
            return Center(child: CircularProgressIndicator()); // Yüklenirken gösterilecek
          }

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
                      child: Text('Hayır'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Evet'),
                    ),
                  ],
                ),
              );
              return shouldExit ?? false;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  buildRoomDutyCountSection(),
                  SizedBox(height: 20),
                  buildRoomsSection(),
                  buildBreakRequestButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildRoomDutyCountSection() {
    return Obx(() {
      if (viewModel.roomDutyCountLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (viewModel.roomDutyCountError.value) {
        return Center(child: Text('Error: ${viewModel.roomDutyCountErrorMessage.value}'));
      }

      int completedCount = viewModel.roomDutyCountList.isNotEmpty
          ? viewModel.roomDutyCountList[0].completedCount ?? 0
          : 0;
      int notCompletedCount = viewModel.roomDutyCountList.isNotEmpty
          ? viewModel.roomDutyCountList[0].uncompletedCount ?? 0
          : 0;

      int technicalErrorCount = viewModel.errorCountList.isNotEmpty
          ? viewModel.errorCountList[0].completedCount ?? 0
          : 0;

      int appointedCount = viewModel.roomDutyCountList.isNotEmpty
          ? viewModel.roomDutyCountList[0].appointedCount ?? 0
          : 0;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildDutyCard('Tamamlanan Görevler', completedCount),
              SizedBox(width: 10),
              buildDutyCard2('Tamamlanmayan Görevler', notCompletedCount),
              SizedBox(width: 10),
              buildTechnicalCard('Teknik Görevler', technicalErrorCount),
              SizedBox(width: 10),
              buildAppointedCard('Atanacak Görevler', appointedCount),
            ],
          ),
        ),
      );
    });
  }

  Widget buildRoomsSection() {
    return Obx(() {
      if (viewModel.isLoadingRooms.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (viewModel.roomList.isEmpty) {
        return Center(child: Text("Bu şubeye ait oda bulunamadı."));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: viewModel.roomList.length,
        itemBuilder: (context, index) {
          DutyByEmployeeId room = viewModel.roomList[index];
          String roomName = room.roomName ?? "Unknown";
          String roomId = room.id ?? "";
          print("Görev için gidecek oda ids'i $roomId");

          return Container(
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF172a31),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: ListTile(
              title: Text(
                roomName,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.start,
              ),
              onTap: () async {
                RoomDuty? roomDuty = await viewModel.getRoomDutyWithTasks(roomId);

                List<Tasks> activeTasks = await viewModel.getActiveTasksForRoom(roomId);

                String statusText = (roomDuty?.dutyStartDate == "Henüz Başlamadı")
                    ? "Görev Başlamadı"
                    : "Görev Devam Ediyor";
                print("Aktif görevlerin uzunluğu: ${activeTasks.length}");
                for (var task in activeTasks) {
                  print("Görev: ${task.taskName} - ${task.taskDescription}");
                }
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    var filteredTasks = activeTasks.where((task) => task.status == true).toList();
                    return AlertDialog(
                      title: Text("Aktif Görevler - $roomName"),
                      content: filteredTasks.isNotEmpty
                          ? SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: filteredTasks.map((task) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                                title: Text(task.taskName ?? ""),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(task.taskDescription ?? ""),
                                    Text(statusText),
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    if (statusText == "Görev Başlamadı") {
                                      print("$statusText");
                                      TTDNavigator().pushToMain(TakePhotoPage(roomId: roomId));
                                    } else {
                                      print("$statusText");
                                      TTDNavigator().pushToMain(FinishTakePhotoPage(roomId: roomId));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF172a31), // Butonun arka plan rengi
                                  ),
                                  child: Text(
                                    statusText == "Görev Başlamadı" ? "İşe Başla" : "İşi Bitir",
                                    style: TextStyle(color: Colors.white), // Buton metnini beyaz yaptık
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                          : Center(child: Text("Bu Odada Aktif Görev Yoktur")),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Kapat", style: TextStyle(color: Color(0xFF172a31))),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      );
    });
  }

  Widget buildDutyCard(String title, int count) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFF172a31),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                TTDNavigator().pushToMain(CompletedDutyPage());
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(3),
                backgroundColor: Color(0xFF172a31),
              ),
              child: Text(
                'Detaylar',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '$title: $count',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDutyCard2(String title, int count) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFF172a31),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                TTDNavigator().pushToMain(UnCompletedDutyPage());
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(3),
                backgroundColor: Color(0xFF172a31),
              ),
              child: Text(
                'Detaylar',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '$title: $count',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTechnicalCard(String title, int count) {
    final TechninalErrorPageViewModel viewModel = Get.put(TechninalErrorPageViewModel());
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFF172a31),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                TTDNavigator().push(TechninalErrorPage());
                viewModel.fetchEmployeeInfoAndRooms();
                viewModel.getTechnicalErrorByDeparmentId();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(3),
                backgroundColor: Color(0xFF172a31),
              ),
              child: Text(
                'Detaylar',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '$title: $count',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppointedCard(String title, int count) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFF172a31),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                TTDNavigator().pushToMain(AppointedDutyPage());
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(3),
                backgroundColor: Color(0xFF172a31),
              ),
              child: Text(
                'Detaylar',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '$title: $count',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildBreakRequestButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
          onPressed: () {
            _showBreakRequestDialog(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Color(0xFF172a31)),
          ),
          child: Text(
            'Mola talebi oluştur',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showBreakRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Mola Talebi Oluştur",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: breakDescriptionController,
                decoration: InputDecoration(
                  labelText: "Mola Açıklaması",
                  labelStyle: TextStyle(color: Color(0xFF172a31)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF172a31)),
                  ),
                ),
                cursorColor: Color(0xFF172a31),
              ),
              TextField(
                controller: breakTimeController,
                decoration: InputDecoration(
                  labelText: "Süresi (dk)",
                  labelStyle: TextStyle(color: Color(0xFF172a31)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF172a31)),
                  ),
                ),
                keyboardType: TextInputType.number, // Yalnızca rakamları gösteren klavye
                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Sadece rakamlara izin ver
                cursorColor: Color(0xFF172a31),
              ),
              TextField(
                controller: breakDateController,
                decoration: InputDecoration(
                  labelText: "Gün",
                  suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF172a31)),
                  labelStyle: TextStyle(color: Color(0xFF172a31)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF172a31)),
                  ),
                ),
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    breakDateController.text =
                        DateFormat('yyyy-MM-dd').format(selectedDate);
                  }
                },
                readOnly: true,
                cursorColor: Color(0xFF172a31),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "İptal",
                style: TextStyle(color: Color(0xFF172a31)),
              ),
            ),
            TextButton(
              onPressed: () {
                // Boşluk kontrolü
                if (breakDescriptionController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Mola açıklaması boş olamaz",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }

                if (breakTimeController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Süre boş olamaz",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }

                if (breakDateController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Tarih boş olamaz",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }

                viewModel.submitBreakRequest(
                  context,
                  breakDescriptionController.text,
                  breakTimeController.text,
                  breakDateController.text,
                );

                // Gönderim sonrası alanları temizle
                breakDescriptionController.clear();
                breakTimeController.clear();
                breakDateController.clear();
              },
              child: Text(
                "Gönder",
                style: TextStyle(color: Color(0xFF172a31)),
              ),
            ),
          ],
        );
      },
    );
  }


}