import 'package:flutter/material.dart';

void AuthorityMessage(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 16,
        child: Container(
          padding: EdgeInsets.only(left:20),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 20),
              Text(message),
            ],
          ),
        ),
      );
    },
  );
}