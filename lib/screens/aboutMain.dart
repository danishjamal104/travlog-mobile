import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:travlog/screens/userLogin.dart';
import 'package:travlog/screens/userRegister.dart';
import 'package:travlog/utils/constants.dart';

class AboutMain extends StatefulWidget {
  @override
  _AboutMain createState() => _AboutMain();
}

class _AboutMain extends State<AboutMain> {

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
                    width: 200,
                    height: 120,
                    child: Image.asset('assets/travlog.png')),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Center(
                child: Container(
                    width: 250,
                    height: 250,
                    child: Image.asset('assets/travel_click.gif')),
              ),
            ),
            SizedBox(height: 20),
            Text('Are you a travel \nenthusiasts? Go \nbeyond traveling', textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Itim', fontSize: 22, color: kTextColor),),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 1.0),
                  margin: EdgeInsets.all(10),
                  height: 50.0,
                  child: ButtonTheme(
                    minWidth: 150,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.black)),
                    onPressed: () { Navigator.push(
                        context, MaterialPageRoute(builder: (_) => UserLogin()));},
                    color: Colors.white,
                    textColor: Colors.black,
                    child: Text("Login",
                        style: TextStyle(fontSize: 15)),
                  ),
                ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 1.0),
                  margin: EdgeInsets.all(10),
                  height: 50.0,
                  child: ButtonTheme(
                    minWidth: 150,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserRegister()));},
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text("Register",
                          style: TextStyle(fontSize: 15)),
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