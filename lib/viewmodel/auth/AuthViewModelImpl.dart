import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:graphql/src/link/http/link_http.dart';
import 'package:travlog/api/GraphQLExecutor.dart';
import 'package:travlog/api/Queries.dart';
import 'package:travlog/api/ServiceResult.dart';
import 'package:travlog/viewmodel/auth/AuthViewModel.dart';

class AuthViewModelImpl implements AuthViewModel{

  GraphQLExecutor gqlExecutor;
  Queries queries;
  String emailRegex = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  AuthViewModelImpl() {
    gqlExecutor = GraphQLExecutor.getInstance();
    queries = Queries.getInstance();
  }

  @override
  Future<ServiceResult> login(String username, String password) async  {
    if(!validateField(username)) {
      return ServiceResult.Failure("Invalid username");
    }
    if(!validatePassword(password)) {
      return ServiceResult.Failure("Invalid password");
    }

    return await gqlExecutor.mutation(queries.loginUser(username, password));
  }

  @override
  Future<ServiceResult> registerNewUser(String username,
      String password, String email) async  {
    if(!validateField(username)) {
      return ServiceResult.Failure("Invalid username");
    }
    if(!validatePassword(password)) {
      return ServiceResult.Failure("Invalid password");
    }
    if(!validateEmail(email)) {
      return ServiceResult.Failure("Invalid email");
    }

    return await gqlExecutor.mutation(queries.registerUser(username,
         password, email));
  }

  @override
  Future<ServiceResult> addExtraUserInfo(String username, String password, String fullName,
      String bio, String mobileNumber) async {

    if(!validateField(fullName)){
      return ServiceResult.Failure("Invalid fullName");
    }
    if(!validateField(bio)) {
      return ServiceResult.Failure("Bio can't be empty");
    }
    if(!validateField(mobileNumber) && double.tryParse(mobileNumber) == null) {
      return ServiceResult.Failure("Please enter 10 digit mobile number");
    }

    var fullNameList = fullName.split(" ");
    var firstName = fullNameList[0];
    var lastName = fullNameList[1];
    String query = queries.profileUpdate(
        username, password, firstName, lastName, mobileNumber, bio);

    return gqlExecutor.mutation(query);
  }

  @override
  HttpLink getHttpLink() {
    return gqlExecutor.getHttpLink();
  }

  // validates the string and return `true` if [field] is valid
  bool validateField(String field) {
    if(field == null){
      return false;
    }
    field = field.trim();
    return field.isNotEmpty;
  }

  // Returns `true` is [password] is valid else `false`
  bool validatePassword(String password) {
    if(!validateField(password)) {
      return false;
    }
    // add all the condition checks in this array
    var conditions = [
      password.length < 8
    ];

    conditions.forEach((element) {
      if(!element) {
        return false;
      }
    });
    return true;
  }

  // Returns `true` is [email] is valid else `false`, xxxx@<domain>.<something>
  bool validateEmail(String email) {
    if(!validateField(email)) {
      return false;
    }
    return RegExp(emailRegex).hasMatch(email);
  }

}