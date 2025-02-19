import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ttd/ui/home/additionaltask/AdditionalTaskPage.dart';
import 'package:ttd/ui/home/duty/DutyPage.dart';
import 'package:ttd/ui/home/duty/DutyPageViewModel.dart';
import 'package:ttd/ui/home/employeeDutyLocations/EmployeeDutyLocationsPage.dart';
import 'package:ttd/ui/home/hallway/HallwayPage.dart';
import 'package:ttd/ui/home/lostProperty/LostPropertyPage.dart';
import 'package:ttd/ui/home/profile/PersonelUpdatePageViewModel.dart';
import 'package:ttd/ui/home/profile/ProfilePageViewModel.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:ttd/ui/home/techninalerror/TechninalErrorPage.dart';
import 'package:ttd/ui/home/workAccident/WorkAccidentPage.dart';
import 'package:ttd/ui/home/workinghoursystem/WorkingHoursSystemExitPage.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/rest/responses/profil/GetByImagesByEmployeeId.dart';
import '../../../services/common/TTDCameraService.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../../login/LoginPage.dart';
import '../currentDuty/CurrentDutyPage.dart';
import 'PersonelUpdatePage.dart';



class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profil Uygulaması',
      theme: ThemeData(),
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();
  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(ProfilPageViewModel());
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
        iconTheme: IconThemeData(
          color: Colors.white,  // İkon rengi beyaz yapılıyor
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF172A31),
              ),
              child: Image.asset(
                'assets/1.png',
                width: 100,
                height: 100,
              ),

            ),
            ListTile(
              leading: Icon(Icons.emergency),
              title: Text('Kaza Raporu'),
              onTap: () {
                  TTDNavigator().pushToMain(WorkAccidentPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Görev Yerlerim'),
              onTap: () {
                TTDNavigator().pushToMain(EmployeeDutyLocationsPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Aktif Görevler'),
              onTap: () {
                TTDNavigator().pushToMain(CurrentDutyPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.warning),
              title: Text('Teknik Arıza Talebi Oluştur'),
              onTap: () {
                TTDNavigator().pushToMain(TechninalErrorPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Kayıp Eşyalar'),
              onTap: () {
                TTDNavigator().pushToMain(LostPropertyPage());
              },
            ),
            /*ListTile(
              leading: Icon(Icons.settings),
              title: Text('Ek Görevler'),
              onTap: () {
                TTDNavigator().pushToMain(AdditionalTaskPage());
              },
            ),*/
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Çıkış Yap'),
              onTap: () async {
                TTDNavigator().pushToMain(WorkingHoursSystemExitPage());
              },
            ),
          ],
        ),
      ),
      body: ProfileBody(),
    );
  }
}
class ProfileBody extends StatelessWidget {
  final ProfilPageViewModel viewModel = Get.put(ProfilPageViewModel());
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: viewModel.controlRemember(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Hata oluştu: ${snapshot.error}"));
        }
        var empId = viewModel.employeeId;
        if (empId == null) {
          return Center(child: Text("Employee ID bulunamadı"));
        }
        return FutureBuilder<void>(
          future: viewModel.getEmployeeInfo(empId),
          builder: (context, employeeSnapshot) {
            if (employeeSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (employeeSnapshot.hasError) {
              return Center(
                  child: Text(
                      "Employee bilgisi alınamadı: ${employeeSnapshot.error}"));
            }
            var employeeInfo = viewModel.employeeInfo;
            if (employeeInfo == null) {
              return Center(child: Text("Çalışan bilgisi bulunamadı"));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                FutureBuilder<List<GetByImagesByEmployeeId>>(
                  future: viewModel.getEmployeeImage(empId),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (imageSnapshot.hasError) {
                      return Center(
                          child: Text(
                              "Fotoğraf yüklenemedi: ${imageSnapshot.error}"));
                    }
                    if (imageSnapshot.data == null ||
                        imageSnapshot.data!.isEmpty) {
                      // If no image found, display default image
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/t.png'),
                      );
                    }
                    var latestImage = imageSnapshot.data!.first;
                    String imageUrl =
                        'https://tidy.ozztech.net:2083/Uploads/Employee/${latestImage.employeeId}/${latestImage.imagePath}';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        onImageButtonPressed(ImageSource.gallery);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF172a31)),
                      ),
                      child: Text(
                        'Fotoğraf Ekle',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Adı ve Soyadı',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      '${employeeInfo.firstName} ${employeeInfo.lastName}'), // Kullanıcının adı ve soyadı
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text('E-posta',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(employeeInfo.email ??
                      'N/A'), // Kullanıcının e-posta adresi
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('Telefon Numarası',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      employeeInfo.phoneNumber ?? 'N/A'), // Telefon numarası
                ),
                ListTile(
                  leading: Icon(Icons.badge),
                  title: Text('Görevi',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(employeeInfo.title ??
                      'N/A'), // employeeId'yi buraya ekliyoruz
                ),
                ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text('İşe Başlama Tarihi',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(employeeInfo.dateOfStart ??
                      'N/A'), // employeeId'yi buraya ekliyoruz
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    TTDNavigator().pushToMain(PersonelUpdatePage());
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF172a31)),
                  ),
                  child: Text(
                    'Kişisel Bilgileri Güncelle',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void onImageButtonPressed(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      print("Çekilen Foto: $pickedFile");
      if (pickedFile != null) {
        var empId = viewModel.employeeId;
        if (empId == null) {
          print('Employee ID null');
          return;
        }
        final File file = File(pickedFile.path);
        print('File Path: ${file.path}');
        await viewModel.uploadImage(empId, file);
      } else {
        print('Fotoğraf seçilmedi.');
      }
    } catch (e) {
      print('Fotoğraf seçme hatası: $e');
    }
  }
}