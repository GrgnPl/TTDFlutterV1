import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ttd/ui/home/lostProperty/LostPropertyPage.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';
import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/rest/requests/lostproperty/PropertyImageRequest.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../../ViewModelBase.dart';

class LostPropertyTakeImagePageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();

  LostPropertyTakeImagePageViewModel() {
    initPage();
  }

  initPage() async {
    // Gerekirse başlangıç ayarları
  }

  Future<void> uploadImage(String propertyId, File image) async {
    print('Uploading image for Property ID: $propertyId');
    if (_personnelRestService != null) {
      try {
        var request = PropertyImageRequest(
          PropertyId: propertyId,
          Image: image,
        );
        print('AddEmployeeImageRequest created: EmployeeId: ${request.PropertyId}, Image: ${request.Image}');
        var response = await _personnelRestService!.addLostPropertyImage(request);
        if (response != null) {
          Fluttertoast.showToast(
            msg: response != null
                ? "Başarıyla Fotoğraf Yüklendi Lütfen Bekleyin."
                : "Fotoğraf Yükleme Sırasında Bir Hata Oluştu.Lütfen Tekrar Deneyin.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: response != null ? Colors.green : Colors.red,
            textColor: Colors.white,
          );
          TTDNavigator().pushToMain(LostPropertyPage());
          print('Image uploaded successfully');
        } else {
          print('Image upload failed');
        }
      } catch (e) {
        print('Image upload error: $e');
      }
    } else {
      print('PersonnelRestService null');
    }
  }

}