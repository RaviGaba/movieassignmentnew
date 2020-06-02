import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movieassignmentnew/utils/Constants.dart';
import 'package:movieassignmentnew/utils/RightToLeftAnimation.dart';
import 'package:movieassignmentnew/utils/Toast.dart';
import 'package:movieassignmentnew/utils/custom_progress_dialog.dart';

import 'HomePage.dart';

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
  final navigatorKey = GlobalKey<NavigatorState>();
  bool isMovieNameValid = true, isMovieYearValid = true;
  final movieNameControler = TextEditingController();
  final movieYearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        // defining HomePage route
        routes: <String, WidgetBuilder>{
          '/home_page': (BuildContext context) => new Homepage()
        },

        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              centerTitle: true, // set the actionbar title to center
              title: Text("Login Page"),
            ),
            body: loginPageDesign(context)),
      debugShowCheckedModeBanner: false,
    );
  }

  loginPageDesign(BuildContext context) {
    TextStyle textStyle = new TextStyle(fontSize: 20.0, color: Colors.black);

    // movie name text field
    final movieNameTextField = TextField(
      controller: movieNameControler,
      maxLines: 1,
      style: textStyle,
      onChanged: (text) {
        setState(() {
          isMovieNameValid = true;
        });
      },
      decoration: InputDecoration(
          labelText: "Movie Name",
          hintText: "Enter Movie Name",
          errorText: !isMovieNameValid ? "Movie name can not be blank" : null,
          contentPadding: EdgeInsets.all(15.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    // movie release year text field
    final movieReleasedYearTextField = TextField(
      controller: movieYearController,
      maxLines: 1,
      style: textStyle,
      keyboardType: TextInputType.number,
      onChanged: (text) {
        setState(() {
          isMovieYearValid = true;
        });
      },
      decoration: InputDecoration(
          labelText: "Release Year",
          errorText: !isMovieYearValid ? "Movie year can not be blank" : null,
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
      onPressed: () {
        if (movieNameControler.text.trim().length == 0) {
          // check if movie name is blank
          setState(() {
            isMovieNameValid = false;
          });
        } else if (movieYearController.text.trim().length == 0) {
          // check if movie release year is blank
          setState(() {
            isMovieYearValid = false;
          });
        } else {
          // movie name and year are filled check with API

          final contextMaterial = navigatorKey.currentState.overlay.context;

          var dialog = CustomProgressDialog(
            message: "Please Wait",
          );
          showDialog(
              barrierDismissible: false,
              context: contextMaterial,
              builder: (BuildContext context) => dialog);

          // network call
          fetchMovieData(
              context, movieNameControler.text, movieYearController.text);
        }
      },
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

  Future fetchMovieData(BuildContext contextNew, String movieValue,
      String movieReleasedYear) async {
    final contextMaterial = navigatorKey.currentState.overlay.context;

    final response = await http.get("${API_URL}t=${movieValue}&y=${movieReleasedYear}");
    print(response.body);
    final responseJson = json.decode(response.body);

    String responseData = responseJson['Response'] as String;
    String movieName = responseJson['Title'] as String;

    // convert movie name coming from api to lower case to compare with name entered by user, because sometime entered name is sub part of movie full name
    responseData.compareTo("True") == 0
        ? movieName = movieName.toLowerCase()
        : movieName = null;

    Navigator.pop(contextMaterial); // remove progress bar

    FocusScope.of(context)
        .requestFocus(FocusNode()); // hide keyboard from screen forcefully

    if (responseData.compareTo("True") == 0 &&
        movieName.compareTo(movieNameControler.text.trim().toLowerCase()) ==
            0) {
      showToast("Login Success");
      Navigator.of(contextMaterial).push(FadeRouteBuilder(page:Homepage())); // Navigate to page with slide right to left animation
    } else {
      showToast("Movie Name & Releasing Year is not Correct");
    }
  }

}



