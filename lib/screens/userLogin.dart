import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:toast/toast.dart';
import 'package:travlog/utils/constants.dart';

import 'home.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLogin createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  TextEditingController userController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  FocusNode userFocus = new FocusNode();
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
        controller: userController,
        focusNode: userFocus,
        onFieldSubmitted: (term) {
          _fieldFocusChange(context, userFocus, _passwordFocus);
        },
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: kPrimaryColor)),
            border: const OutlineInputBorder(),
            labelText: 'Username',
            labelStyle: TextStyle(fontFamily: 'sans-serif', color: kTextColor),
            hintStyle: TextStyle(fontFamily: 'sans-serif', fontSize: 15),
            hintText: 'Enter your username'),
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

  _onLogin() async {
    if (userController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      final HttpLink httpLink = HttpLink(
        uri: 'http://127.0.0.1:8000/',
      );

      final String authMutation = '''
                        mutation{
                          tokenAuth(username:"${userController.text}", password:"${_passwordController.text}") {
                             token
                             }
                        }
                        ''';

      GraphQLClient _client = GraphQLClient(
          link: httpLink,
          cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject));

      final MutationOptions options = MutationOptions(
        documentNode: gql(authMutation),
      );

      QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        print(result.exception.toString());
        Toast.show("Sorry, you entered wrong credentials", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }

      final String token = result.data['tokenAuth']['token'];

      final AuthLink authLink = AuthLink(
        getToken: () async => 'JWT $token',
      );
      final Link link = authLink.concat(httpLink);

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
