import 'package:flutter/material.dart';
import 'package:travlog/utils/constants.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

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
                    child: Image.asset('assets/add_post.jpg')),
              ),
            ),
            Text('This will help you to post your updates',
              style: TextStyle(fontFamily: 'Itim', fontSize: 22, color: kTextColor),)
          ],
        ),
      ),
    );
  }
}