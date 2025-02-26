import 'package:ttd/ui/home/camera/TakePhotoPage.dart';

import '../../../rest/emp/PersonnelRestService.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../../ViewModelBase.dart';

class StartDutyPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();

  StartDutyPageViewModel()
  {
    initPage();
  }

  initPage() async{
  }
  void gotoPhoto(String id) {
    TTDNavigator().pushToMain(TakePhotoPage(dutyId: id)); // id parametresini geç
  }

}