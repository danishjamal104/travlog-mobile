import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:toast/toast.dart';
import 'package:travlog/api/GraphQLExecutor.dart';
import 'package:travlog/api/ServiceResult.dart';
import 'package:travlog/api/Queries.dart';
import 'package:travlog/utils/constants.dart';
import 'package:travlog/viewmodel/auth/AuthViewModel.dart';
import 'package:travlog/viewmodel/auth/AuthViewModelImpl.dart';
import 'package:travlog/views/extension.dart';

import 'home.dart';
import 'package:travlog/views/TextInputField.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLogin createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  AuthViewModel viewModel = AuthViewModel.getInstance();
  TextEditingController userController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  FocusNode userFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();

  Widget _buildUsername() {
    return getDefaultTextInputFiled(context,
        userController, userFocus, _passwordFocus,
        'Username', 'Enter your username');
  }

  Widget _buildPassword() {
    return getDefaultTextInputFiled(context,
        _passwordController, _passwordFocus, null,
        'Password', 'Enter secure password');
  }

  _onLogin() async {

    String username = userController.text;
    String password = _passwordController.text;

    var result = await viewModel.login(username, password);

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
    print(_passwordController.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(
          username: userController.text,
          url: link,
          token: token,
          password: _passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Comfortaa', fontSize: 30, color: kTextColor),
                ),
              )),
            ),
            _buildUsername(),
            _buildPassword(),
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
                        _onLogin();
                      },
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text("Log In", style: TextStyle(fontSize: 15)),
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
