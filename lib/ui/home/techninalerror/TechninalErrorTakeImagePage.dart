import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ttd/ui/home/lostProperty/LostPropertyPageViewModel.dart';
import 'package:ttd/ui/home/lostProperty/LostPropertyTakeImagePageViewModel.dart';
import 'package:ttd/ui/home/techninalerror/TechninalErrorTakeImagePageViewModel.dart';

enum CameraType { front, back }
CameraType selectedCamera = CameraType.back;


class TechninalErrorTakeImagePage extends StatelessWidget {
  final String TechnicalErrorId;
  final picker = ImagePicker();
  final viewModel = Get.put(TechninalErrorTakeImagePageViewModel());

  TechninalErrorTakeImagePage({required this.TechnicalErrorId});

  @override
  Widget build(BuildContext context) {
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
                    'Teknik Arızanın Fotoğrafını Çekiniz',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onImageButtonPressed(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      preferredCameraDevice: selectedCamera == CameraType.front
          ? CameraDevice.front
          : CameraDevice.rear,
    );

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      print("Çekilen Fotoğraf Yolu: ${file.path}");
      // Fotoğrafı yüklemek için kullanabilirsiniz
      await viewModel.uploadImage(TechnicalErrorId, file);
    } else {
      print("Fotoğraf seçilmedi.");
    }
  }
}