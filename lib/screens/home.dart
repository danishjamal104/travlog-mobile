import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:travlog/screens/dashboard.dart';
import 'package:travlog/screens/new_add.dart';
import 'package:travlog/screens/profile_page.dart';
import 'package:travlog/screens/notification.dart';
import 'package:travlog/screens/search.dart';
import 'package:travlog/utils/constants.dart';

class Home extends StatefulWidget {
  final Link url;
  final String username;
  final String token;
  final String password;

  const Home({Key key, this.username, this.url, this.token, this.password})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  static Link url;
  static String username;
  static String password;
  static String token;

  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    print("pass" + password.toString());
    final List<Widget> _children = [
      Dashboard(),
      Search(),
      AddPost(),
      Notifications(),
      UserProfilePage(
        username: widget.username,
        token: token,
        password: widget.password,
      ),
    ];

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(link: widget.url, cache: InMemoryCache()),
    );

    url = widget.url;
    username = widget.username;
    password = widget.password;

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        body: _children[_pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.home,
                color: kTextColor,
              ),
              title: new Text(
                'Home',
                style: TextStyle(
                  color: kTextColor,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.search,
                color: kTextColor,
              ),
              title: new Text(
                'Search',
                style: TextStyle(color: kTextColor),
              ),
            ),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.add_circle_outline,
                color: kTextColor,
              ),
              title: new Text('Add', style: TextStyle(color: kTextColor)),
            ),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.notifications_none,
                color: kTextColor,
              ),
              title:
                  new Text('Notification', style: TextStyle(color: kTextColor)),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  color: kTextColor,
                ),
                title: Text('Profile', style: TextStyle(color: kTextColor)))
          ],
          onTap: onTabTapped,
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }
}
