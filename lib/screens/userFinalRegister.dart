import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:travlog/screens/home.dart';
import 'package:travlog/utils/constants.dart';

class UserFinalRegister extends StatefulWidget {
  final String username;
  final String password;

  UserFinalRegister({Key key, this.username, this.password}) : super(key: key);

  @override
  _UserFinalRegister createState() => _UserFinalRegister();
}

class _UserFinalRegister extends State<UserFinalRegister> {
  static String username;
  static String password;
  TextEditingController _fullNameController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _bioController = new TextEditingController();
  FocusNode _fullNameFocus = new FocusNode();
  FocusNode _bioFocus = new FocusNode();
  FocusNode _mobileFocus = new FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _buildName() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 5),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: _fullNameController,
        focusNode: _fullNameFocus,
        onFieldSubmitted: (term) {
          _fieldFocusChange(context, _fullNameFocus, _bioFocus);
        },
        style: TextStyle(fontFamily: 'sans-serif', fontSize: 17),
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: kPrimaryColor)),
          border: const OutlineInputBorder(),
          labelText: 'Full name',
          labelStyle: TextStyle(fontFamily: 'sans-serif', color: kTextColor),
          hintStyle: TextStyle(fontFamily: 'sans-serif', fontSize: 15),
          hintText: 'Enter full name',
        ),
      ),
    );
  }

  Widget _buildBio() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 5),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        style: TextStyle(fontFamily: 'sans-serif', fontSize: 17),
        controller: _bioController,
        focusNode: _bioFocus,
        onFieldSubmitted: (term) {
          _fieldFocusChange(context, _bioFocus, _mobileFocus);
        },
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: kPrimaryColor)),
            border: const OutlineInputBorder(),
            labelText: 'Bio',
            labelStyle: TextStyle(fontFamily: 'sans-serif', color: kTextColor),
            hintStyle: TextStyle(fontFamily: 'sans-serif', fontSize: 15),
            hintText: 'Enter bio'),
      ),
    );
  }

  Widget _buildMobileNumber() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 5),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        style: TextStyle(fontFamily: 'sans-serif', fontSize: 17),
        controller: _mobileController,
        focusNode: _mobileFocus,
        onFieldSubmitted: (value) {
          _mobileFocus.unfocus();
          //_onLogin();
        },
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: kPrimaryColor)),
            border: const OutlineInputBorder(),
            labelText: 'Mobile number',
            labelStyle: TextStyle(fontFamily: 'sans-serif', color: kTextColor),
            hintStyle: TextStyle(fontFamily: 'sans-serif', fontSize: 15),
            hintText: 'Enter mobile number'),
      ),
    );
  }

  _onFinalRegister() async {
    if (_fullNameController.text.isNotEmpty &&
        _mobileController.text.isNotEmpty) {
      final HttpLink httpLink = HttpLink(
        uri: 'http://127.0.0.1:8000/',
      );

      var fullName = _fullNameController.text.toString().split(" ");
      var firstName = fullName[0];
      var lastName = fullName[1];
      print(username);
      print(password);
      print(fullName);
      print(_bioController.text);

      String profileUpdate() {
        return '''
                        mutation{
                          tokenAuth(username:"$username", password:"$password") {
                             token
                             }
                          updateProfile(phoneNo:"${_mobileController.text}", firstName:"$firstName", lastName: "$lastName", bio: "${_bioController.text}") {
                            __typename
                             }
                             }
                        ''';
      }

      GraphQLClient _client = GraphQLClient(
          link: httpLink,
          cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject));

      final MutationOptions options = MutationOptions(
        documentNode: gql(profileUpdate()),
      );

      QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        print(result.exception.toString());
      }

      final String token = result.data['tokenAuth']['token'];

      final AuthLink authLink = AuthLink(
        getToken: () async => 'JWT $token',
      );
      final Link link = authLink.concat(httpLink);

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
