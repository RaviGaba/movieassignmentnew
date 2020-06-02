import 'package:flutter/material.dart';

class CustomProgressDialog extends StatelessWidget {
  String message;

  CustomProgressDialog({@required this.message});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    final progressMessage = Text(
      message,
      style: TextStyle(color: Colors.black, fontSize: 20.0),
    );

    final progressBar = CircularProgressIndicator();

    final cardView = Container(
      padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10.0)]),
      child: Row(
        children: <Widget>[
          progressBar,
          SizedBox(
            width: 50.0,
          ),
          progressMessage
        ],
      ),
    );

    return cardView;
  }
}
