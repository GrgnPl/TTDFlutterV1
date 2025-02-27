import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ttd/models/rest/requests/technicalerror/TechnicalErrorImageRequest.dart';
import 'package:ttd/models/rest/requests/technicalerror/TechnicalErrorRequest.dart';
import 'package:ttd/ui/home/lostProperty/LostPropertyPage.dart';
import 'package:ttd/ui/home/techninalerror/TechninalErrorPage.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';
import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/rest/requests/lostproperty/PropertyImageRequest.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../../ViewModelBase.dart';

class TechninalErrorTakeImagePageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();

  TechninalErrorTakeImagePageViewModel() {
    initPage();
  }

  initPage() async {
  }

  Future<void> firstuploadImage(String TechnicalErrorId, File image) async {
    print('Uploading image for Property ID: $TechnicalErrorId');
    if (_personnelRestService != null) {
      try {
        var request = TechnicalErrorImageRequest(
          TechnicalErrorId: TechnicalErrorId,
          Image: image,
        );
        print('AddTechnicalImageAdd created: ErrorID: ${request.TechnicalErrorId}, Image: ${request.Image}');
        var response = await _personnelRestService!.addTechnicalErrorImageFirst(request);
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
          TTDNavigator().push(TechninalErrorPage());
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

  Future<void> lastuploadImage(String TechnicalErrorId, File image,String employeeId,String desc) async {
    print('Uploading image for Property ID: $TechnicalErrorId');
    if (_personnelRestService != null) {

      var technicalErrorRequest = TechnicalErrorRequest(
        description: desc
      );
      var response = _personnelRestService!.updateTechnicalError(technicalErrorRequest);
      if(response != null)
      {
        try {
          var request = TechnicalErrorImageRequest(
            TechnicalErrorId: TechnicalErrorId,
            Image: image,
          );
          print('AddTechnicalImageAdd created: ErrorID: ${request.TechnicalErrorId}, Image: ${request.Image}');
          var response = await _personnelRestService!.addTechnicalErrorImageLast(request);
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
            await finishTechnicalDuty(TechnicalErrorId,employeeId);
            print('Image uploaded successfully');
          } else {
            print('Image upload failed');
          }
        } catch (e) {
          print('Image upload error: $e');
        }
      }
    } else {
      print('PersonnelRestService null');
    }
  }



  Future<void> finishTechnicalDuty(String dutyID,String employeeID) async {
    if (_personnelRestService != null) {
      try {
        if(employeeID != null)
        {
          var queryParams = {'id': dutyID, 'employeeId' : employeeID};
          print("finistechnicalduty params : ${queryParams}");
          var response = await _personnelRestService!.finishTechnicalDuty(queryParams);
          print("finishtechnicalduty response: $response");
          Fluttertoast.showToast(
            msg: "Teknik Görev Başarıyla Bitirildi...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          TTDNavigator().push(TechninalErrorPage());
        }
      } catch (e, stacktrace) {
        Fluttertoast.showToast(
          msg: "Bir Hata Oluştu.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print("Teknik Görev Bitirme Hatası: $e");
        print("StackTrace: $stacktrace");
      }
    }  }



}