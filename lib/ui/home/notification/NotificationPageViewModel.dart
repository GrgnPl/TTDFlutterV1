import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ttd/models/rest/responses/notification/StatusUpdateResponse.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/domain/common/AuthModel.dart';
import '../../../models/rest/responses/notification/GetNotificationCountByEmpId.dart';
import '../../../models/rest/responses/notification/GetNotificationCountByEmpIdResponse.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../services/common/TTDApplicationService.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../home/HomePageViewModel.dart';

class NotificationPageViewModel extends GetxController {
  late ITTDPersonelRestService _personnelRestService;
  var notifications = <GetNotificationCountByEmpId>[].obs;
  var isLoading = false.obs; // Progress circle için kontrol

  NotificationPageViewModel() {
    _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
    initPage();
  }

  void initPage() async {
    await controlRemember();
    await fetchNotifications();
  }

  Future<void> controlRemember() async {
    var result = await TTDServiceLocator().get<ITTDSettingsRepository>()!.getSetting("AuthModel");
    if (result != null) {
      AuthModel authModel = AuthModel.fromJson(jsonDecode(result));
      TTDApplicationService.authModel = AuthModel(
        employeeId: authModel.employeeId,
        token: authModel.token,
        expiration: authModel.expiration,
      );
    }
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true; // Loading başlat
      var employeeId = TTDApplicationService.authModel?.employeeId;
      if (employeeId != null) {
        var queryParams = {'id': employeeId};
        GetNotificationCountByEmpIdResponse response = await _personnelRestService.getNotificationCountByEmpId(queryParams);
        notifications.assignAll(response.data);
      } else {
        print("Error: Employee ID is null");
      }
    } catch (e) {
      print("Error occurred while fetching notifications: $e");
    } finally {
      isLoading.value = false; // Loading durdur
    }
  }

  // Tüm bildirimleri okundu olarak işaretleyen metod
  Future<void> markAllAsRead() async {
    try {
      isLoading.value = true; // Loading başlat
      for (var notification in notifications) {
        if (notification.id != null && notification.status == true) {
          await statusUpdateNotification(notification.id!);
        }
      }
      notifications.forEach((notification) {
        notification.status = false; // Her bildirimi okundu olarak işaretle
      });
      notifications.refresh(); // Listeyi güncelle
      print("All notifications marked as read.");

      // Bildirim sayısını sıfırla
      HomePageViewModel viewModel = Get.find<HomePageViewModel>();
      viewModel.notificationCount.value = 0; // veya bildirim sayısını burada güncelleyin
    } catch (e) {
      print("Error occurred while marking notifications as read: $e");
    } finally {
      isLoading.value = false; // Loading durdur
    }
  }

  // Bildirim durumunu güncelleyen metod
  Future<void> statusUpdateNotification(String notificationId) async {
    try {
      var employeeId = TTDApplicationService.authModel?.employeeId;
      if (employeeId != null) {
        var queryParams = {'id': notificationId};
        StatusUpdateResponse response = await _personnelRestService.notificationUpdateById(queryParams);
        // İsteğe bağlı: Güncellenmiş notification'ı modelde işaretleyebilirsiniz.
      } else {
        print("Error: Employee ID is null");
      }
    } catch (e) {
      print("Error occurred while updating notification status: $e");
    }
  }
}