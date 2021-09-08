import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:travlog/api/ServiceResult.dart';

import 'AuthViewModelImpl.dart';

abstract class AuthViewModel {
  AuthViewModel._() {}

  static AuthViewModelImpl _viewModelInstance;
  static AuthViewModel getInstance() {
    if(_viewModelInstance == null) {
      _viewModelInstance = AuthViewModelImpl();
    }
    return _viewModelInstance;
  }

  Future<ServiceResult> login(String username, String password);
  Future<ServiceResult> registerNewUser(String username,
      String password, String email);
  Future<ServiceResult> addExtraUserInfo(String username, String password,
      String fullName, String bio, String mobileNumber);
  HttpLink getHttpLink();
}