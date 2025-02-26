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
import 'package:ttd/ui/home/qr/StartDutyPage.dart';
import 'package:ttd/ui/home/techninalerror/TechninalErrorPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';

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
  final HomePageViewModel viewModel;
  final TextEditingController breakDescriptionController = TextEditingController();
  final TextEditingController breakTimeController = TextEditingController();
  final TextEditingController breakDateController = TextEditingController();
  final ITTDCameraService? _cameraService = TTDServiceLocator().get<ITTDCameraService>();
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();
  late PersonelLoginPageViewModel _personelLoginViewModel;

  HomePage() : viewModel = Get.find<HomePageViewModel>();

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PersonelLoginPageViewModel>()) {
      _personelLoginViewModel = Get.put(PersonelLoginPageViewModel());
    }
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
        toolbarHeight: 8.h,
        backgroundColor: Color(0xFF172a31),
        centerTitle: true,
        title: Image.asset(
          'assets/1.png',
          width: 25.w,
          height: 12.h,
        ),
        automaticallyImplyLeading: false,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 6.w,
                ),
                onPressed: () {
                  TTDNavigator().pushToMain(NotificationPage());
                },
              ),
              GetBuilder<HomePageViewModel>(
                builder: (viewModel) {
                  if (viewModel.notificationCount.value > 0) {
                    return Positioned(
                      right: 2.w,
                      top: 2.w,
                      child: Container(
                        padding: EdgeInsets.all(0.5.w),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 4.w,
                          minHeight: 4.w,
                        ),
                        child: Center(
                          child: Text(
                            '${viewModel.notificationCount.value}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
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
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.refreshData();
        },
        color: Color(0xFF172a31),
        child: Obx(() => Stack(
          children: [
            SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 3.h),
                  buildRoomDutyCountSection(),
                  SizedBox(height: 3.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Odalar",
                              style: TextStyle(
                                color: Color(0xFF172a31),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Container(
                                height: 5.h,
                                child: TextField(
                                  onChanged: (value) => viewModel.searchRooms(value),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Color(0xFF172a31),
                                    fontFamily: 'Poppins',
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Oda Ara...',
                                    hintStyle: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                      fontFamily: 'Poppins',
                                    ),
                                    prefixIcon: Icon(Icons.search, size: 5.w, color: Color(0xFF172a31)),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2.w),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2.w),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2.w),
                                      borderSide: BorderSide(color: Color(0xFF172a31)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        if (viewModel.isLoadingRooms.value)
                          Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF172a31)),
                            ),
                          )
                        else if (viewModel.filteredRooms.isEmpty)
                          Center(
                            child: Column(
                              children: [
                                Icon(Icons.room_outlined, size: 15.w, color: Color(0xFF172a31)),
                                SizedBox(height: 2.h),
                                Text(
                                  "Bu şubeye ait oda bulunamadı.",
                                  style: TextStyle(
                                    color: Color(0xFF172a31),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: viewModel.filteredRooms.length,
                            itemBuilder: (context, index) {
                              var room = viewModel.filteredRooms[index];
                              return Card(
                                elevation: 2,
                                margin: EdgeInsets.only(bottom: 2.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.w),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(3.w),
                                  leading: CircleAvatar(
                                    backgroundColor: Color(0xFF172a31),
                                    child: Icon(Icons.room, color: Colors.white),
                                  ),
                                  title: Text(
                                    room.roomName ?? "Bilinmeyen Oda",
                                    style: TextStyle(
                                      color: Color(0xFF172a31),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios, 
                                    color: Color(0xFF172a31),
                                    size: 5.w,
                                  ),
                                  onTap: () => _showRoomDutyDialog(context, room),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (viewModel.isLoading.value)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF172a31)),
                ),
              ),
          ],
        )),
      ),
    );
  }

  Widget buildRoomDutyCountSection() {
    return Obx(() {
      if (viewModel.roomDutyCountError.value) {
        return Center(child: Text('Error: ${viewModel.roomDutyCountErrorMessage.value}'));
      }

      int appointedCount = viewModel.roomDutyCountList.isNotEmpty
          ? viewModel.roomDutyCountList[0].appointedCount ?? 0
          : 0;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildDutyCard('Tamamlanan Görevler', viewModel.completedTaskCount.value),
              SizedBox(width: 3.w),
              buildDutyCard2('Tamamlanmayan Görevler', viewModel.uncompletedTaskCount.value),
              SizedBox(width: 3.w),
              buildTechnicalCard('Teknik Görevler', viewModel.tehcnicalTaskCount.value),
              SizedBox(width: 3.w),
              buildAppointedCard('Atanacak Görevler', appointedCount),
            ],
          ),
        ),
      );
    });
  }

  void _showRoomDutyDialog(BuildContext context, DutyByEmployeeId room) async {
    List<RoomDuty> roomDuties = await viewModel.getRoomDutyWithTasks(room.id ?? "");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.room, color: Color(0xFF172a31)),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          room.roomName ?? "Bilinmeyen Oda",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF172a31),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                  Divider(),
                  if (roomDuties.isNotEmpty) 
                    ...roomDuties.map((roomDuty) => Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              roomDuty.dutyTitle ?? "",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF172a31),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            width: 20.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF172a31),
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1.w),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                if (roomDuty.dutyStartDate == "Henüz Başlamadı") {
                                  var gidecekRoomId = room.id;
                                  var gidecekGorevID = roomDuty.id;
                                  print("gidecek roomID : $gidecekRoomId gidecekGorevID : $gidecekGorevID");
                                  TTDNavigator().pushToMain(StartDutyPage(dutyID: gidecekGorevID ?? "", roomID: gidecekRoomId ?? "",));
                                } else {
                                  TTDNavigator().pushToMain(FinishTakePhotoPage(dutyId: roomDuty.id ?? ""));
                                }
                              },
                              child: Text(
                                roomDuty.dutyStartDate == "Henüz Başlamadı"
                                    ? "Göreve Başla"
                                    : "Görevi Bitir",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList()
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Text(
                        "Görev bulunmamaktadır",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        );
      },
    );
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

  void showBreakRequestDialog(BuildContext context) {
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