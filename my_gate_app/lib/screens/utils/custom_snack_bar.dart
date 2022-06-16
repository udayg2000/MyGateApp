import 'package:flutter/material.dart';

SnackBar get_snack_bar(
  String message,
  MaterialColor bg_color,
) {
  return SnackBar(
    content: Row(
      children: [
        Icon(
          Icons.info_outline,
          color: Colors.white,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          message,
          style: TextStyle(color: Colors.white,),
        ),
      ],
    ),
    backgroundColor: bg_color,
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(10),
  );
}
