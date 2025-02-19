import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ttd/models/rest/responses/duty/Duty.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/Tasks.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDuty.dart';
import 'package:ttd/models/rest/responses/empupdate/EmpUpdateResponse.dart';
import 'package:ttd/ui/home/NavigationPage.dart';
import 'package:ttd/ui/home/currentDuty/ditySituation/DutySituationPage.dart';
import 'package:ttd/ui/home/home/HomePage.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/domain/common/AuthModel.dart';
import '../../../models/domain/common/LoginModel.dart';
import '../../../models/rest/responses/materialmanagement/MaterialManagement.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../services/common/TTDApplicationService.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';

class BeforeDutyListPageViewModel extends GetxController {
  late ITTDPersonelRestService _personnelRestService;
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();

  String? _employeeId;

  BeforeDutyListPageViewModel() {
    _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
    initPage();
  }

  void initPage() async {
    await controlRemember();
  }

  void showSafetyMeasuresDialog(BuildContext context, String dutyId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Maske ve eldivenlerinizi takmanız ve iş bitimine kadar çıkarmamanız gerekmektedir.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Tehlikeli Maddeler:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '- Tehlikeli madde bilgisi bulunmamaktadır',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Icon(
                Icons.warning,
                color: Colors.black,
                size: 50,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF172a31),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  startDuty(dutyId); // Görevi başlat
                  Navigator.of(context).pop(); // Dialog'u kapat
                },
                child: Text('Güvenlik Önlemlerini Aldım', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> controlRemember() async {
    var rememberMe = await _ittdSettingsRepository!.getSetting("RememberMe");
    if (rememberMe != null && jsonDecode(rememberMe)) {
      var result = await _ittdSettingsRepository!.getSetting("AuthModel");
      if (result != null) {
        AuthModel authModel = AuthModel.fromJson(jsonDecode(result));
        TTDApplicationService.authModel = authModel;
        _employeeId = authModel.employeeId;
      }
    } else {
      LoginModel? loginModel = TTDApplicationService.loginModel;
      if (loginModel != null) {
        _employeeId = loginModel.employeeId;
      } else {
        print("LoginModel bulunamadı. Kullanıcı giriş yapmalıdır.");
      }
    }
  }

  Future<void> startDuty(String dutyID) async {
    if (_personnelRestService != null) {
      try {
        if(_employeeId != null)
          {
            var queryParams = {'id': dutyID, 'employeeId' : _employeeId};
            var response = await _personnelRestService.startDuty(queryParams);
            print('Görev başlatma yanıtı: $response');
            print("Görev oda ID'sinden başarıyla başlatıldı");
            Fluttertoast.showToast(
              msg: "Göreve Başlanıldı.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
            TTDNavigator().pushToMain(DutySituationPage(dutyId: dutyID));
          }
      } catch (e, stacktrace) {
        Fluttertoast.showToast(
          msg: "Bir Hata Oluştu.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print("Oda ID'sinden görev başlatma hatası: $e");
        print("StackTrace: $stacktrace");
      }
    }
  }
}