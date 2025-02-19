import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../models/rest/responses/hallway/Hallway.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';

class HallwayPageViewModel extends GetxController {
  late ITTDPersonelRestService? _personnelRestService =
  TTDServiceLocator().get<ITTDPersonelRestService>();

  Future<List<Hallway>> getHallwaysByUserId() async {
    try {
      String userId = 'user_id'; // Kullanıcı ID'si buradan alınmalı
      var response = await _personnelRestService!.getAllHallway();
      if (response != null) {
        // Filtreleme işlemi kullanıcı kimliğine göre burada yapılabilir
        List<Hallway> userHallways = response.listofHallway!
            .where((hallway) => hallway.id == userId)
            .toList();
        return userHallways;
      } else {
        return [];
      }
    } catch (e) {
      print('Get Hallways Error: $e');
      return[];
    }
    }
}