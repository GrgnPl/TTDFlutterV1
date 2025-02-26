import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttd/ui/home/duty/DutyPage.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/domain/common/AuthModel.dart';
import '../../../models/domain/common/LoginModel.dart';
import '../../../models/rest/requests/dutyImage/DutyImageBeforeRequest.dart';
import '../../../models/rest/responses/duty/dutyById/DutyByIdResponse.dart';
import '../../../models/rest/responses/duty/roomDuty/RoomDuty.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../services/common/TTDApplicationService.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../../ViewModelBase.dart';
import '../dutyList/BeforeDutyListPage.dart';
import 'AfterDutyListPage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FinishTakePhotoPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();

  String? _employeeId;
  String? _dutyId;

  RxList<DutyByIdResponse> dutyList = <DutyByIdResponse>[].obs;
  RxList<RoomDuty> roomInfo = <RoomDuty>[].obs;

  String? get employeeId => _employeeId;
  String? get dutyId => _dutyId;

  final isUploading = false.obs;

  FinishTakePhotoPageViewModel() {
    _init();
  }

  void _init() async {
    try {
      await controlRemember();
      if (_employeeId == null) {
        print('Employee ID hala null!');
        // Alternatif olarak LoginModel'den almayı dene
        var loginModel = TTDApplicationService.loginModel;
        if (loginModel != null) {
          _employeeId = loginModel.employeeId;
          print('LoginModel\'den employee ID alındı: $_employeeId');
        }
      } else {
        print('Employee ID başarıyla ayarlandı: $_employeeId');
      }
      await fetch();
    } catch (e) {
      print('Init error: $e');
    }
  }

  Future<void> fetch() async {
    await fetchEmployeeInfoAndRooms();
  }

  Future<void> fetchEmployeeInfoAndRooms() async {
    if (_employeeId != null) {
      await getEmployeeInfo(_employeeId!);
    }
  }

  Future<void> controlRemember() async {
    try {
      var rememberMe = await _ittdSettingsRepository!.getSetting("RememberMe");
      print('RememberMe değeri: $rememberMe');
      
      if (rememberMe != null && jsonDecode(rememberMe)) {
        var result = await _ittdSettingsRepository!.getSetting("AuthModel");
        print('AuthModel raw data: $result');
        
        if (result != null) {
          AuthModel authModel = AuthModel.fromJson(jsonDecode(result));
          TTDApplicationService.authModel = authModel;
          _employeeId = authModel.employeeId;
          print('AuthModel\'den employee ID ayarlandı: $_employeeId');
        } else {
          print('AuthModel verisi bulunamadı');
        }
      } else {
        print('RememberMe aktif değil, LoginModel kontrol ediliyor');
        LoginModel? loginModel = TTDApplicationService.loginModel;
        if (loginModel != null) {
          _employeeId = loginModel.employeeId;
          print('LoginModel\'den employee ID ayarlandı: $_employeeId');
        } else {
          print("LoginModel bulunamadı. Kullanıcı giriş yapmalıdır.");
        }
      }
    } catch (e, stackTrace) {
      print('ControlRemember error: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> getEmployeeInfo(String id) async {
    try {
      var queryParams = {'id': id};
      var response = await _personnelRestService!.getEmployeeInfo(queryParams);
    } catch (e) {
      print('Employee bilgisi alınamadı: $e');
    }
  }

  Future<File?> compressImage(File file) async {
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf('.');
      final outPath = '${filePath.substring(0, lastIndex)}_compressed.jpg';

      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 85,
        minWidth: 1280,
        minHeight: 960,
        rotate: 0,
      );

      if (result != null) {
        final compressedSize = await result.length();
        print('Sıkıştırılmış dosya boyutu: ${compressedSize / 1024}KB');
        return File(result.path);
      }
      return null;
    } catch (e) {
      print('Resim sıkıştırma hatası: $e');
      return null;
    }
  }

  Future<void> processImageUpload(String dutyId, File image, int imageNumber) async {
    await getDutyByDutyId(dutyId);

    if (dutyId != null) {
      await uploadImage(dutyId, image, imageNumber);
    } else {
      print("Duty ID alınamadı, resim yükleme başarısız.");
    }
  }

  Future<void> getDutyFromRoomId(String roomId) async {
    if (_personnelRestService != null) {
      try {

        print('Gidecek Room ID: $roomId'); // Debug için

        var queryParams = {'id': roomId};
        var response = await _personnelRestService!.getDutyFromRoomId(queryParams);

        if (response!=null) {
          try {
            var roomDuties = response.listOfRoomDuty?.where((duty) =>
            duty.id?.isNotEmpty == true && duty.employeeName!.any((employee) => employee.id == _employeeId) ?? false).toList();
            roomInfo.clear();
            roomInfo.assignAll(roomDuties!);
            print(roomDuties);
            if (roomDuties!.isNotEmpty) {
              print("roomDuties Boş Değil");
            } else {
              print('Bu çalışana ait görev bulunamadı');
              Get.snackbar(
                'Uyarı',
                'Bu odada size atanmış bir görev bulunamadı.',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          } catch (e) {
            print('Görev filtreleme hatası: $e');
          }
        } else {
          print('Oda için görev bulunamadı');
          Get.snackbar(
            'Uyarı',
            'Bu oda için görev bulunamadı.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e, stacktrace) {
        print('Görev bilgisi alınırken hata: $e');
        print('StackTrace: $stacktrace');
        Get.snackbar(
          'Hata',
          'Görev bilgisi alınırken bir hata oluştu.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }


  Future<void> getDutyByDutyId(String dutyId) async {
    if (_personnelRestService != null) {
      try {

        print('Gidecek Duty ID: $dutyId'); // Debug için

        var queryParams = {'id': dutyId};
        var response = await _personnelRestService!.getDutyById(queryParams);
        print("employeeId : $_employeeId");
        if (response!=null) {
          try {
            dutyList.clear();
            dutyList.assign(response);
            var employeeDuties = response.employeeId.where((element) {
              return element.id == _employeeId;
            }).toList();

            if (employeeDuties.isNotEmpty) {
              print("employeeDuties Boş Değil");
            } else {
              print('Bu çalışana ait görev bulunamadı');
              Get.snackbar(
                'Uyarı',
                'Bu odada size atanmış bir görev bulunamadı.',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          } catch (e) {
            print('Görev filtreleme hatası: $e');
          }
        } else {
          print('Oda için görev bulunamadı');
          Get.snackbar(
            'Uyarı',
            'Bu oda için görev bulunamadı.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e, stacktrace) {
        print('Görev bilgisi alınırken hata: $e');
        print('StackTrace: $stacktrace');
        Get.snackbar(
          'Hata',
          'Görev bilgisi alınırken bir hata oluştu.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }



  Future<void> uploadImage(String dutyId, File image, int imageNumber) async {
    if (isUploading.value) {
      print('Zaten bir yükleme işlemi devam ediyor');
      return;
    }

    try {
      isUploading.value = true;
      print('Yükleme işlemi başladı');

      // Dosya boyutunu kontrol et
      final fileSize = await image.length();
      print('Yükleme öncesi fotoğraf boyutu: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB');

      File imageToUpload = image;
      if (fileSize > 1024 * 1024) { // 1MB'dan büyükse
        print('Fotoğraf sıkıştırılıyor...');
        final compressedImage = await compressImage(image);
        if (compressedImage != null) {
          imageToUpload = compressedImage;
          final newSize = await imageToUpload.length();
          print('Sıkıştırma sonrası fotoğraf boyutu: ${(newSize / 1024 / 1024).toStringAsFixed(2)} MB');
        }
      }

      var request = DutyImageBeforeRequest(
        DutyId: dutyId,
        ImageDate: DateTime.now().toIso8601String(),
        ImageNumber: imageNumber,
        Image: imageToUpload,
      );

      var response = await _personnelRestService!.addDutyImageAfter(request);

      if (response != null) {
        print('Resim başarıyla yüklendi');
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Dialog'u kapat
        }
        print("BeforeDutyListPageGidecekID : $dutyId");
        TTDNavigator().pushToMain(AfterDutyListPage(dutyId: dutyId));
      } else {
        print('Resim yükleme başarısız');
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Hata durumunda da dialog'u kapat
        }
        throw Exception('Resim yükleme başarısız');
      }
    } catch (e) {
      print('Resim yükleme hatası: $e');
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Hata durumunda da dialog'u kapat
      }
      rethrow;
    } finally {
      print('Yükleme işlemi tamamlandı');
      isUploading.value = false;
    }
  }

  gotoDutyList(String dutyId) {
    print("AfterDutyListPageGidecekID : $dutyId");
    TTDNavigator().pushToMain(AfterDutyListPage(dutyId: dutyId));
  }
}