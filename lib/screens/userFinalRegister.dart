import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:travlog/api/ApiConfig.dart';
import 'package:travlog/api/GraphQLExecutor.dart';
import 'package:travlog/api/Queries.dart';
import 'package:travlog/api/ServiceResult.dart';
import 'package:travlog/screens/home.dart';
import 'package:travlog/utils/constants.dart';
import 'package:travlog/viewmodel/auth/AuthViewModel.dart';
import 'package:travlog/views/TextInputField.dart';
import 'package:travlog/views/extension.dart';

class UserFinalRegister extends StatefulWidget {
  final String username;
  final String password;

  UserFinalRegister({Key key, this.username, this.password}) : super(key: key);

  @override
  _UserFinalRegister createState() => _UserFinalRegister();
}

class _UserFinalRegister extends State<UserFinalRegister> {
  AuthViewModel viewModel = AuthViewModel.getInstance();
  static String username;
  static String password;
  TextEditingController _fullNameController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _bioController = new TextEditingController();
  FocusNode _fullNameFocus = new FocusNode();
  FocusNode _bioFocus = new FocusNode();
  FocusNode _mobileFocus = new FocusNode();

  Widget _buildName() {
    return getDefaultTextInputFiled(
        context, _fullNameController, _fullNameFocus,
        _bioFocus, 'Full name', 'Enter full name');
  }

  Widget _buildBio() {
    return getDefaultTextInputFiled(
        context, _bioController, _bioFocus,
        _mobileFocus, 'Bio', 'Enter bio');
  }

  Widget _buildMobileNumber() {
    return getDefaultTextInputFiled(
        context, _mobileController, _mobileFocus,
        null, 'Mobile Number', 'Enter mobile number');
  }

  _onFinalRegister() async {

    String fullName = _fullNameController.text;
    String mobileNumber = _mobileController.text;
    String bio = _bioController.text;

    ServiceResult result = await viewModel.addExtraUserInfo(
        username, password, fullName, bio, mobileNumber);

    if(result is Failure) {
      print(result.reason);
      showToast(context, result.reason);
      return;
    }

    final dynamic data = (result as Success).data;
    final String token = data['tokenAuth']['token'];

    final AuthLink authLink = AuthLink(
      getToken: () async => 'JWT $token',
    );
    final Link link = authLink.concat(viewModel.getHttpLink());

    print(token);
    print(link.toString());

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(
          username: username,
          url: link,
          token: token,
          password: password,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    username = widget.username;
    password = widget.password;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                  child: Container(
                width: 300,
                height: 120,
                child: Text(
                  'Travlog',
                  style: TextStyle(
                      fontFamily: 'Pacifico', fontSize: 30, color: kTextColor),
                ),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Center(
                  child: Container(
                width: 300,
                height: 60,
                child: Text(
                  'Register',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Comfortaa', fontSize: 30, color: kTextColor),
                ),
              )),
            ),
            _buildName(),
            _buildBio(),
            _buildMobileNumber(),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 1.0),
                  margin: EdgeInsets.all(10),
                  height: 50.0,
                  child: ButtonTheme(
                    minWidth: 330,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black)),
                      onPressed: () {
                        _onFinalRegister();
                      },
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text("Sign Up", style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
