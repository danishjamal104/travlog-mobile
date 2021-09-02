import 'package:flutter/material.dart';
import 'package:travlog/utils/constants.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

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
                    child: Image.asset('assets/dashboard.jpg')),
              ),
            ),
            Text('This will be your dashboard',
              style: TextStyle(fontFamily: 'Itim', fontSize: 22, color: kTextColor),)
          ],
        ),
      ),
    );
  }
}