import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:travlog/screens/userFinalRegister.dart';
import 'package:travlog/utils/constants.dart';

import 'home.dart';

class UserRegister extends StatefulWidget {
  @override
  _UserRegister createState() => _UserRegister();
}

class _UserRegister extends State<UserRegister> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  FocusNode _usernameFocus = new FocusNode();
  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _buildUsername() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 5),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        style: TextStyle(fontFamily: 'sans-serif', fontSize: 17),
        controller: _usernameController,
        focusNode: _usernameFocus,
        onFieldSubmitted: (term) {
          _fieldFocusChange(context, _usernameFocus, _emailFocus);
        },
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: kPrimaryColor)),
            border: const OutlineInputBorder(),
            labelText: 'Username',
            labelStyle: TextStyle(fontFamily: 'sans-serif', color: kTextColor),
            hintStyle: TextStyle(fontFamily: 'sans-serif', fontSize: 15),
            hintText: 'Enter username'),
      ),
    );
  }

  Widget _buildEmail() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 5),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        style: TextStyle(fontFamily: 'sans-serif', fontSize: 17),
        controller: _emailController,
        focusNode: _emailFocus,
        onFieldSubmitted: (term) {
          _fieldFocusChange(context, _emailFocus, _passwordFocus);
        },
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: kPrimaryColor)),
            border: const OutlineInputBorder(),
            labelText: 'Email address',
            labelStyle: TextStyle(fontFamily: 'sans-serif', color: kTextColor),
            hintStyle: TextStyle(fontFamily: 'sans-serif', fontSize: 15),
            hintText: 'Enter email address'),
      ),
    );
  }

  Widget _buildPassword() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 5),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        obscureText: true,
        controller: _passwordController,
        focusNode: _passwordFocus,
        onFieldSubmitted: (value) {
          _passwordFocus.unfocus();
          //_onLogin();
        },
        style: TextStyle(fontFamily: 'sans-serif', fontSize: 17),
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: kPrimaryColor)),
          border: const OutlineInputBorder(),
          labelText: 'Password',
          labelStyle: TextStyle(fontFamily: 'sans-serif', color: kTextColor),
          hintStyle: TextStyle(fontFamily: 'sans-serif', fontSize: 15),
          hintText: 'Enter secure password',
        ),
      ),
    );
  }

  _onRegister() async {
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      final HttpLink httpLink = HttpLink(
        uri: 'http://127.0.0.1:8000/',
      );

      String registerMutation() {
        return '''
                        mutation{
                          createUser(username:"${_usernameController.text}", password:"${_passwordController.text}", email: "${_emailController.text}") {
          __typename
                             }
                             }
                        ''';
      }

      GraphQLClient _client = GraphQLClient(
          link: httpLink,
          cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject));

      final MutationOptions options = MutationOptions(
        documentNode: gql(registerMutation()),
      );

      QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        print(result.exception.toString());
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
