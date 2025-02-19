import 'package:ttd/models/domain/common/AuthModel.dart';

import '../../models/domain/common/LoginModel.dart';

abstract class ITTDApplicationService {
  AuthModel? getAuthModel();
  LoginModel? getLoginModel(); // LoginModel için getter ekledik
}

class TTDApplicationService implements ITTDApplicationService {
  static AuthModel? authModel;
  static LoginModel? loginModel; // LoginModel burada saklanacak

  @override
  AuthModel? getAuthModel() {
    return authModel;
  }

  @override
  LoginModel? getLoginModel() {
    return loginModel;
  }
}