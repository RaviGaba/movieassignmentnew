import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of our application.
  @override
  LoginPageState createState() {
    // TODO: implement createState
    return new LoginPageState();
  }
}

class LoginPageState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              centerTitle: true, // set the actionbar title to center
              title: Text("Login Page"),
            ),
            body: loginPageDesign(context)));
  }


  loginPageDesign(BuildContext context) {
    TextStyle textStyle = new TextStyle(fontSize: 20.0, color: Colors.black);

    final movieNameTextField = TextField(
      maxLines: 1,
      style: textStyle,
      decoration: InputDecoration(
          labelText: "Movie Name",
          hintText: "Enter Movie Name",
          contentPadding: EdgeInsets.all(15.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final movieReleasedYearTextField = TextField(
      maxLines: 1,
      style: textStyle,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: "Release Year",
          hintText: "Enter Released Year",
          contentPadding: EdgeInsets.all(15.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final submitButton = RaisedButton(
      child: Text("Submit"),
      color: Colors.blue,
      textColor: Colors.white,
      padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
      onPressed: (){},
    );

    return Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 25.0,
                ),
                SizedBox(
                  child: Image.asset('assets/images/movie_icon.png'),
                  height: 120.0,
                  width: 120.0,
                ),
                SizedBox(
                  height: 50.0,
                ),
                movieNameTextField,
                SizedBox(
                  height: 35.0,
                ),
                movieReleasedYearTextField,
                SizedBox(
                  height: 50.0,
                ),
                submitButton
              ],
            ),
          ),
        ));
  }

}
