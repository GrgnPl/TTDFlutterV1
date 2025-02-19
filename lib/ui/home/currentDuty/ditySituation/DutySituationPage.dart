import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDuty.dart';
import 'package:ttd/ui/home/camera/TakePhotoPage.dart';
import 'package:ttd/ui/home/camera/TakePhotoPageViewModel.dart';
import 'package:ttd/ui/home/currentDuty/ditySituation/DutySituationPageViewModel.dart';
import 'package:ttd/ui/home/dutyList/BeforeDutyListPage.dart';
import 'package:ttd/ui/home/finishDuty/FinishDutyPage.dart';
import 'package:ttd/ui/home/finishDuty/FinishTakePhotoPage.dart';
import 'package:ttd/ui/home/qr/StartDutyPage.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

import '../../../../models/rest/responses/duty/currentDuty/CurrentDutyResponse.dart';
import '../../../../utils/servicelocator/TTDServiceLocator.dart';

import 'package:flutter/material.dart';

import '../../NavigationPage.dart';

class DutySituationPage extends StatelessWidget {
  final String dutyId;

  DutySituationPage({required this.dutyId});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,  // Geri gitmeyi engelle
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          toolbarHeight: 60,
          backgroundColor: Color(0xFF172a31),
          centerTitle: true,  // Title'ı ortalamak için yeterli
          title: Image.asset(
            'assets/1.png',
            width: 100,
            height: 100,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // ya da iste diğiniz herhangi bir icon
            onPressed: () {
              TTDNavigator().pushToMain(NavigationPage()); // Geri gitme işlemi
            },
          ),
        ),
        body: ProfileBody(dutyId: dutyId),
      ),
    );
  }
}

class ProfileBody extends StatelessWidget {
  final viewModel = Get.put(DutySituationPageViewModel());
  final String dutyId;

  ProfileBody({required this.dutyId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CurrentDutyResponse?>(
      future: viewModel.getDutyInfo(dutyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Hata oluştu: ${snapshot.error}"));
        }

        var dutyInfo = snapshot.data;
        if (dutyInfo == null) {
          return Center(child: Text("Görev Bilgisi Bulunamadı"));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              _buildDutyDetailTile(Icons.password, 'Görev Adı', dutyInfo.dutyTitle ?? "Bilinmiyor"),
              _buildDutyDetailTile(
                Icons.date_range,
                'Görev Başlama ve Bitiş Tarihi',
                'Başlama: ${dutyInfo.dutyStartDate}\nBitiş: ${dutyInfo.dutyEndDate}',
              ),
              _buildDutyDetailTile(
                Icons.content_copy,
                'Görev İçeriği',
                dutyInfo.task.map((t) => t.taskDescription).join(', '),
              ),
              SizedBox(height: 20),

              // Şartlara göre butonları düzenleme
              if (dutyInfo.dutyStartDate == "Henüz Başlamadı" && dutyInfo.dutyEndDate == "Henüz Bitmedi")
                _buildActionButton('İşe Başla', () {
                  TTDNavigator().pushToMain(StartDutyPage());
                })
              else if (dutyInfo.dutyEndDate == "Henüz Bitmedi")
                _buildActionButton('Görevi Bitir', () {
                  TTDNavigator().pushToMain(FinishTakePhotoPage(roomId: dutyInfo.roomId!));
                })
              else if (dutyInfo.dutyEndDate != "Henüz Bitmedi")
                  _buildActionButton('İş Bitmiş', () {
                    Fluttertoast.showToast(
                      msg: "Bu İş Zaten Bitti.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  })
                else
                  _buildActionButton('Durum Bilinmiyor', () {
                    Fluttertoast.showToast(
                      msg: "Geçersiz işlem durumu.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                    );
                  }),

              // Oda müsait değil butonu
              _buildActionButton('Oda Müsait Değil', () {
                _showUnavailableRoomDialog(context, dutyId);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDutyDetailTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF172a31)),
      ),
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }

  void _showUnavailableRoomDialog(BuildContext context, String dutyId) {
    String? selectedOption; // Dropdown seçim değeri
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Açıklama Seçiniz"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
                isExpanded: true,
                value: selectedOption,
                hint: Text("Bir açıklama seçiniz"),
                items: [
                  DropdownMenuItem(value: "Oda Dolu", child: Text("Oda Dolu")),
                  DropdownMenuItem(value: "Oda İstemiyor", child: Text("Oda İstemiyor")),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue; // Seçilen açıklama
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogu kapat
              },
              child: Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedOption == null) {
                  Fluttertoast.showToast(
                    msg: "Lütfen bir açıklama seçiniz.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                } else {
                  var response = await viewModel.dutyUpdate(dutyId, selectedOption!);
                  if (response != null) {
                    Fluttertoast.showToast(
                      msg: "Güncelleme başarılı.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                    Navigator.of(context).pop(); // Dialogu kapat
                  } else {
                    Fluttertoast.showToast(
                      msg: "Güncelleme sırasında hata oluştu.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                }
              },
              child: Text("Tamam"),
            ),
          ],
        );
      },
    );
  }
}