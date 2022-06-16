import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:my_gate_app/screens/profile2/themes.dart';

AppBar buildAppBar(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final icon = CupertinoIcons.moon_stars;
  var icon_color = Colors.blue.shade300;
  // var icon_color = Colors.black;
  // if( color == "black"){
  //   icon_color=Colors.black;
  // }
  return AppBar(
    leading: BackButton(),
    // leading: IconButton(icon:Icon(Icons.arrow_back),
    //         // onPressed:() => Navigator.pop(context, false),
    //         onPressed:() => Navigator.of(context).pop(),
    // ),
    backgroundColor: Colors.transparent,
    
    iconTheme: IconThemeData(color: icon_color),
    // backgroundColor: Colors.blue.shade300,
    elevation: 0,
    // actions: [
    //   ThemeSwitcher(
    //     builder: (context) => IconButton(
    //       icon: Icon(icon),
    //       onPressed: () {
    //         final theme = isDarkMode ? MyThemes.lightTheme : MyThemes.darkTheme;

    //         final switcher = ThemeSwitcher.of(context);
    //         switcher.changeTheme(theme: theme);
    //       },
    //     ),
    //   ),
    // ],
  );
}

