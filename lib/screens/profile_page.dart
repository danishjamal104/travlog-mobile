import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:travlog/screens/editProfile.dart';
import 'package:travlog/utils/app_data.dart';
import 'package:travlog/components/profile_model.dart';

class UserProfilePage extends StatefulWidget {
  final String username;
  final String token;
  final String password;

  const UserProfilePage({this.username, this.token, this.password});

  @override
  _UserProfilePageState createState() => _UserProfilePageState(username, token, password);
}

class _UserProfilePageState extends State<UserProfilePage> {
  final String username;
  final String token;
  final String password;
  ScrollController _controller;
  Profile profile;

  _UserProfilePageState(this.username, this.token, this.password);

  @override
  void initState() {
    profile = AppData.profiles[0];
    super.initState();
  }

  String _userProfile() {
    return '''
        query{
          user(username:"$username") {
            username
            email
            firstName
            bio
            lastName
          }
        }
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Query(
        options: QueryOptions(
            documentNode: gql(_userProfile()),
            variables: <String, dynamic>{
              'username': username,
            }),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (result.data == null) {
            print(username);
            print('No Profile');
            return Center(child: Text('Names not found.'));
          }
          print(password);
          return _profileView(result, profile, token, password);
        },
      ),
    );
  }
}

Widget _profileView(QueryResult result, Profile profile, String token, String password) {
  final profileInfo = result.data['user'];
  return Container(
    //child: SizedBox(height: 20),
    child: HeaderSection(
      profile: profile,
      profileInfo: profileInfo,
      token: token,
      password: password,
    ),
    //SizedBox(height: 40),
    //],
  );
}

class HeaderSection extends StatelessWidget {
  final String token;
  final String password;
  final Profile profile;
  final profileInfo;

  HeaderSection({
    this.token,
    this.password,
    this.profile,
    this.profileInfo,
    Key key,
  }) : super(key: ValueKey<String>(profile.imageUrl));

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                labelStyle: TextStyle(
                    fontFamily: 'Roboto', fontWeight: FontWeight.w600),
                unselectedLabelColor: Colors.black54,
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'Roboto',
                ),
                tabs: [
                  Tab(
                    text: "Photos",
                  ),
                  Tab(text: "Itinerary"),
                  Tab(text: "Videos"),
                ]),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            //Add this to give height
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [
              Container(
                child: Text(
                  "Home Body",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Roboto'),
                ),
              ),
              Container(
                child: Text(
                  "Articles Body",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Roboto'),
                ),
              ),
              Container(
                child: Text(
                  "User Body",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Roboto'),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void handleClick(String value, BuildContext context) {
    switch (value) {
      case 'Logout':
        print("logout");
        break;
      case 'Settings':
        break;
      case 'Edit Profile':
        print(password);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfile(
              password: password,
              username: profileInfo['username'],
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Travlog',
          style: TextStyle(
              fontFamily: 'pacifico', color: Colors.black, fontSize: 28),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (choice) => handleClick(choice, context),
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings', 'Edit Profile'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(fontFamily: 'Roboto'),
                  ),
                );
              }).toList();
            },
          ),
        ],
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  image: DecorationImage(
                      image: AssetImage(profile.imageUrl), fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: Text(
                  profileInfo['firstName'] + " " + profileInfo['lastName'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'Roboto'),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Text(
                  '@' + profileInfo['username'].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      color: Colors.black54),
                ),
              ),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Text(
                  profileInfo['bio'].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Roboto'),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          profile.totalFollowers,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto'),
                        ),
                        SizedBox(height: 3),
                        Text('Followers')
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          profile.ratings + '/10',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto'),
                        ),
                        SizedBox(height: 3),
                        Text('Rating')
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          profile.totalFollowing,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto'),
                        ),
                        SizedBox(height: 3),
                        Text('Following')
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _tabSection(context),
            ],
          ),
        ),
      ),
    );
  }
}
