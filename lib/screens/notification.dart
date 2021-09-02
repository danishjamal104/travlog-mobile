import 'package:flutter/material.dart';
import 'package:travlog/utils/constants.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Center(
                child: Container(
                    width: 300,
                    height: 250,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/notification.jpg')),
              ),
            ),
            Text('This will show your notifications',
              style: TextStyle(fontFamily: 'Itim', fontSize: 22, color: kTextColor),)
          ],
        ),
      ),
    );
  }
}