import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

import '../NavigationPage.dart';
import '../home/HomePageViewModel.dart';
import 'NotificationPageViewModel.dart';

class NotificationPage extends StatelessWidget {
  final NotificationPageViewModel viewModel = Get.put(NotificationPageViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF172a31),
          title: Row(
            children: [
              Text('Duyurular', style: TextStyle(color: Colors.white)),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              TTDNavigator().pop();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      print("Okundu İşaretle yazısına basıldı!");
                      viewModel.isLoading.value = true;
                      await viewModel.markAllAsRead();
                      viewModel.isLoading.value = false;
                    },
                    child: Text(
                      "Okundu İşaretle",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Obx(() {
          if (viewModel.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (viewModel.notifications.isEmpty) {
            return Center(child: Text('Henüz bir duyuru yok.'));
          }
          return ListView.builder(
            itemCount: viewModel.notifications.length,
            itemBuilder: (context, index) {
              var notification = viewModel.notifications[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0), // Cardlar arasındaki boşluğu azaltmak için
                child: Card(
                  margin: EdgeInsets.all(4.0), // Card'ın kendi içindeki margin değerini azaltmak için
                  child: ListTile(
                    title: Text(
                      notification.notificationTitle ?? 'Bilinmeyen Başlık',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.notificationBody ?? 'Bilinmeyen İçerik',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 4.0), // İçerik ile durum metni arasında biraz boşluk bırakmak için
                        Text(
                          notification.status == true ? "Okunmamış" : "Okunmuş",
                          style: TextStyle(
                            color: notification.status == true ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      notification.notificationDate ?? 'Bilinmeyen Tarih',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              );
            },
          );
        }),
    );
  }
}