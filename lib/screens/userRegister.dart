import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:travlog/api/ServiceResult.dart';
import 'package:travlog/screens/userFinalRegister.dart';
import 'package:travlog/utils/constants.dart';
import 'package:travlog/viewmodel/auth/AuthViewModel.dart';
import 'package:travlog/views/TextInputField.dart';
import 'package:travlog/views/extension.dart';

class UserRegister extends StatefulWidget {
  @override
  _UserRegister createState() => _UserRegister();
}

class _UserRegister extends State<UserRegister> {
  AuthViewModel viewModel = AuthViewModel.getInstance();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  FocusNode _usernameFocus = new FocusNode();
  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();

  Widget _buildUsername() {
    return getDefaultTextInputFiled(context, _usernameController, _usernameFocus, _emailFocus, 'Username', 'Enter username');
  }

  Widget _buildEmail() {
    return getDefaultTextInputFiled(context, _emailController, _emailFocus, _passwordFocus, 'Email address', 'Enter email address');
  }

  Widget _buildPassword() {
    return getDefaultTextInputFiled(context, _passwordController, _passwordFocus, null,  'Password', 'Enter secure password');
  }

  _onRegister() async {

    String username = _usernameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;

    ServiceResult result = await viewModel.registerNewUser(
        username, password, email);

    if(result is Failure) {
      showToast(context, result.reason);
      print(result.reason);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UserFinalRegister(
          username: _usernameController.text,
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
                  'Register',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Comfortaa', fontSize: 30, color: kTextColor),
                ),
              )),
            ),
            _buildUsername(),
            _buildEmail(),
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
                        _onRegister();
                      },
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text("Next", style: TextStyle(fontSize: 15)),
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
