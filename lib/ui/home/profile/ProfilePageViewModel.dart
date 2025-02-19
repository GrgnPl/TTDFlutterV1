import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ttd/models/rest/requests/employeeImage/AddEmployeeImageRequest.dart';
import 'package:ttd/models/rest/requests/profile/GetByIdEmployee.dart';
import 'package:ttd/models/rest/responses/profil/EmployeeGetAllResponse.dart';
import 'package:ttd/rest/emp/PersonnelRestService.dart';
import 'package:ttd/ui/ViewModelBase.dart';
import 'package:ttd/ui/login/emplogin/PersonelLoginPage.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';
import 'package:ttd/utils/servicelocator/TTDServiceLocator.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/domain/common/AuthModel.dart';
import '../../../models/domain/common/LoginModel.dart';
import '../../../models/rest/responses/profil/GetByImagesByEmployeeId.dart';
import '../../../services/common/TTDApplicationService.dart';
import '../../login/LoginPage.dart';

class ProfilPageViewModel extends ViewModelBase {
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();

  String? _employeeId;
  EmployeeGetAllResponse? _employeeInfo;
  String? _imageUrl;

  ProfilePageViewModel() {
    initPage();
  }

  initPage() async {
    await controlRemember();
  }

  Future<void> controlRemember() async {
    var rememberMe = await _ittdSettingsRepository!.getSetting("RememberMe");
    if (rememberMe != null && jsonDecode(rememberMe)) {
      // Eğer RememberMe seçilmişse AuthModel kullanılıyor
      var result = await _ittdSettingsRepository!.getSetting("AuthModel");
      if (result != null) {
        AuthModel authModel = AuthModel.fromJson(jsonDecode(result));
        TTDApplicationService.authModel = authModel;
        _employeeId = authModel.employeeId;
        print("${employeeId}");
      }
    } else {
      // Eğer RememberMe seçilmediyse loginModel kullanılacak
      LoginModel? loginModel = TTDApplicationService.loginModel;
      if (loginModel != null) {
        _employeeId = loginModel.employeeId;
        print("${employeeId}");

      } else {
        print("LoginModel bulunamadı. Kullanıcı giriş yapmalıdır.");
        // Burada login sayfasına yönlendirme yapılabilir.
      }
    }
  }

  Future<void> getEmployeeInfo(String id) async {
    if (_personnelRestService != null) {
      try {
        var queryParams = {'id': id};
        var response = await _personnelRestService!.getEmployeeInfo(queryParams);
        _employeeInfo = response;
        print('Employee Info Response: $response');
        print("Employee fetched successfully");
      } catch (e, stacktrace) {
        print("Error fetching employee: $e");
        print("StackTrace: $stacktrace");
      }
    }
  }

  Future<void> uploadImage(String employeeId, File image) async {
    print('Uploading image for Employee ID: $employeeId');
    if (_personnelRestService != null) {
      try {
        var request = AddEmployeeImageRequest(
          EmployeeId: employeeId,
          Image: image,
        );
        print('AddEmployeeImageRequest created: EmployeeId: ${request.EmployeeId}, Image: ${request.Image}');
        var response = await _personnelRestService!.addEmployeeImage(request);
        if (response != null) {
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


  Future<List<GetByImagesByEmployeeId>> getEmployeeImage(String employeeId) async {
    List<GetByImagesByEmployeeId> images = [];

    if (_personnelRestService != null) {
      try {
        var queryParams = {'id': employeeId};
        var response = await _personnelRestService!.getImagesEmployeeById(queryParams);
        if (response != null && response.listOfProfilePhoto != null) {
          images = response.listOfProfilePhoto!;
          print('Images fetched successfully: $images');
        } else {
          print('No images found for employee');
        }
      } catch (e, stacktrace) {
        print("Error fetching employee images: $e");
        print("StackTrace: $stacktrace");
      }
    }

    return images;
  }

  String? get employeeId => _employeeId;
  EmployeeGetAllResponse? get employeeInfo => _employeeInfo;
  String? get imageUrl => _imageUrl; // Getter for imageUrl
}