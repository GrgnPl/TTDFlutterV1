import 'package:get/get.dart';
import 'package:ttd/data/settings/TTDSettingsRepository.dart';
import 'package:ttd/rest/emp/PersonnelRestService.dart';
import 'package:ttd/services/common/TTDCameraService.dart';

class TTDServiceLocator {
  static final TTDServiceLocator _singleton = TTDServiceLocator._internal();
  TTDServiceLocator._internal();
  factory TTDServiceLocator() {
    return _singleton;
  }

  get<T>() {
    return Get.find<T>();
  }
  init() {
    Get.lazyPut<ITTDPersonelRestService>(() => TTDPersonelRestService(), fenix: true);
    Get.lazyPut<ITTDCameraService>(() => TTDCameraService(), fenix: true);
    Get.lazyPut<ITTDSettingsRepository>(() => TTDSettingsRepository(), fenix: true);
  }
}