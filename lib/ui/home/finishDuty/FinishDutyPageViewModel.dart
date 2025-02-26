import 'package:ttd/ui/home/camera/TakePhotoPage.dart';

import '../../../rest/emp/PersonnelRestService.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../../ViewModelBase.dart';
import 'FinishTakePhotoPage.dart';

class FinishDutyPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();

  FinishDutyPageViewModel()
  {
    initPage();
  }

  initPage() async{
  }
  void gotoPhoto(String id) {
    //TTDNavigator().pushToMain(FinishTakePhotoPage(roomId: id)); // id parametresini geç
  }

}