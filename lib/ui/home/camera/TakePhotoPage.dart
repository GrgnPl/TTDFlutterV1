import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ttd/ui/home/camera/TakePhotoPageViewModel.dart';
import 'package:ttd/ui/home/dutyList/BeforeDutyListPage.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

import '../../../utils/servicelocator/TTDServiceLocator.dart';

import 'package:flutter/material.dart';
enum CameraType { front, back }
CameraType selectedCamera = CameraType.back;

class TakePhotoPage extends StatelessWidget {
  final String roomId;
  final picker = ImagePicker();
  final viewModel = Get.put(TakePhotoPageViewModel());

  TakePhotoPage({required this.roomId});

  @override
  Widget build(BuildContext context) {
    viewModel.getDutyFromRoomId(roomId);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // ya da istediğiniz herhangi bir icon
            onPressed: () {
              TTDNavigator().pop(); // Geri gitme işlemi
            },
          ),
        ),
        backgroundColor: Color(0xFF172A31),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Image.asset(
                'assets/photo.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await onImageButtonPressed(ImageSource.camera);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2D75FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(50, 16, 50, 16),
                  child: Text(
                    'Odanın Fotoğrafını Çekiniz',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (viewModel.roomInfo?.id != null) {
                    viewModel.gotoDutyList(viewModel.roomInfo!.id!);
                  } else {
                    print("Duty ID alınamadı, işlem gerçekleştirilemiyor.");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2D75FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(50, 16, 50, 16),
                  child: Text(
                    'Oda Müsait Değil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> onImageButtonPressed(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        preferredCameraDevice: selectedCamera == CameraType.front
            ? CameraDevice.front
            : CameraDevice.rear,
      );      print("Çekilen Foto: $pickedFile");
      if (pickedFile != null && pickedFile.path != null) {
        final File file = File(pickedFile.path);
        print("File path: ${file.path}");
        int sira = 1;

        if (viewModel.roomInfo?.id != null) {
          await viewModel.uploadImage(viewModel.roomInfo!.id!, file, sira);
        } else {
          print("Duty ID alınamadı, resim yükleme başarısız.");
        }
      } else {
        print("Picked file is null or has null path.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }
}