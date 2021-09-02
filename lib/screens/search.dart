import 'package:flutter/material.dart';
import 'package:travlog/utils/constants.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

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
                    child: Image.asset('assets/search.jpg')),
              ),
            ),
            Text('He you can search other travelers',
              style: TextStyle(fontFamily: 'Itim', fontSize: 22, color: kTextColor),)
          ],
        ),
      ),
    );
  }
}