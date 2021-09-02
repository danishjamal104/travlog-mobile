import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:travlog/screens/profile_page.dart';
import 'package:travlog/utils/constants.dart';

import 'home.dart';

class EditProfile extends StatefulWidget {
  final String username;
  final String password;

  const EditProfile({this.username, this.password});

  @override
  _EditProfile createState() => _EditProfile(username, password);
}

class _EditProfile extends State<EditProfile> {
  final String username;
  final String password;
  static String fullNameText;
  static String phoneNoText;
  static String bioText;
  static String usernameText;

  TextEditingController _fullNameController =
      new TextEditingController(text: fullNameText);
  TextEditingController _usernameController =
      new TextEditingController(text: usernameText);
  TextEditingController _mobileController =
      new TextEditingController(text: phoneNoText);
  TextEditingController _bioController =
      new TextEditingController(text: bioText);
  FocusNode _usernameFocus = new FocusNode();
  FocusNode _fullNameFocus = new FocusNode();
  FocusNode _bioFocus = new FocusNode();
  FocusNode _mobileFocus = new FocusNode();

  _EditProfile(this.username, this.password);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchProfile();
  }

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
          _fieldFocusChange(context, _fullNameFocus, _usernameFocus);
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
          _fieldFocusChange(context, _usernameFocus, _bioFocus);
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

  fetchProfile() async {
    final HttpLink httpLink = HttpLink(
      uri: 'http://127.0.0.1:8000/',
    );
    String _userProfile = '''
        query Login{
          user(username:"$username") {
            firstName
            lastName
            username
            phone
            bio          
            }
        }
    ''';
    GraphQLClient _client = GraphQLClient(
        link: httpLink,
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject));

    final QueryOptions queryOptions = QueryOptions(
        documentNode: gql(_userProfile),
        variables: <String, dynamic>{
          'username': username,
        });

    QueryResult queryResult = await _client.query(queryOptions);

    if (queryResult.hasException) {
      print(queryResult.exception.toString());
    }

    final LazyCacheMap userDetail = queryResult.data['user'];

    usernameText = userDetail['username'];
    fullNameText =
        userDetail['firstName'].toString() + " " + userDetail['lastName'];
    phoneNoText = userDetail['phone'];
    bioText = userDetail['bio'];

    print(usernameText);
    print(fullNameText);
    print(bioText);
    print(phoneNoText);
  }

  updteProfile() async {
    if (_usernameController.text.isNotEmpty) {
      final HttpLink httpLink = HttpLink(
        uri: 'http://127.0.0.1:8000/',
      );
      var fullName = _fullNameController.text.toString().split(" ");
      var firstName = fullName[0];
      var lastName = fullName[1];

      String editProfileMutation() {
        return '''
                        mutation{
                          tokenAuth(username:"$username", password:"$password") {
                             token
                             }
                          updateProfile(username:"${_usernameController.text}", 
                                firstName:"$firstName", 
                                lastName: "$lastName",
                                bio: "${_bioController.text}"
                                phoneNo: "${_mobileController.text}") {
                                  __typename
                             }
                             }
                        ''';
      }

      GraphQLClient _client = GraphQLClient(
          link: httpLink,
          cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject));

      final MutationOptions options = MutationOptions(
        documentNode: gql(editProfileMutation()),
      );

      QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        print(result.exception.toString());
      }

      print("Paass " + password);
      final String token = result.data['tokenAuth']['token'];

      final AuthLink authLink = AuthLink(
        getToken: () async => 'JWT $token',
      );
      final Link link = authLink.concat(httpLink);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            username: username,
            password: password,
            url: link,
            token: token,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(
              fontFamily: 'Comfortaa', color: Colors.black, fontSize: 22),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                  child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  image: DecorationImage(
                      image: AssetImage('assets/demo_profile.jpg'),
                      fit: BoxFit.cover),
                ),
              )),
            ),
            _buildName(),
            _buildUsername(),
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
                        updteProfile();
                      },
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text("Update", style: TextStyle(fontSize: 15)),
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
