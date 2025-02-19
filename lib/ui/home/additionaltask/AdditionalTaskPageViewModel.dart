import 'dart:async';
import 'package:get/get.dart';
import 'package:ttd/utils/servicelocator/TTDServiceLocator.dart';
import 'package:ttd/ui/ViewModelBase.dart';
import '../../../models/rest/responses/additionaltask/Task.dart';
import '../../../rest/emp/PersonnelRestService.dart';

class AdditionalTaskPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService =
  TTDServiceLocator().get<ITTDPersonelRestService>();
  RxList<Task> taskList = <Task>[].obs;

  AdditionalTaskPageViewModel() {
    // İlk yükleme sırasında listeyi güncelle
    updateListView();
  }

  // Manuel olarak listeyi güncelleme işlemi
  Future<void> updateListView() async {
    await getAllAdditionalTasks();
  }

  Future<List<Task>> getAllAdditionalTasks() async {
    try {
      var response = await _personnelRestService!.getAllAdditionalTasks();
      if (response != null && response.listOfAdditionalTask != null) {
        // Her bir AdditionalTask içindeki task'ları topluyoruz
        List<Task> allTasks = [];
        for (var additionalTask in response.listOfAdditionalTask!) {
          if (additionalTask.tasks != null) {
            allTasks.addAll(additionalTask.tasks!);
          }
        }
        taskList.assignAll(allTasks);
        return allTasks;
      } else {
        return [];
      }
    } catch (e) {
      print('Get All Additional Tasks Error: $e');
      return [];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}