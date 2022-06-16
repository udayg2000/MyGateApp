// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_gate_app/auth/authscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_gate_app/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent, //use your hex code here
        ),
      ),
      home: Splash(),
      // home: AuthScreen(),
      // home:StreamBuilder(
      //     stream: FirebaseAuth.instance.authStateChanges(),
      //     builder: (context, usersnapshot) {
      //       if (usersnapshot.hasData) {
      //         //return MyHomePage(title: 'Flutter Demo Home Page');              
      //         // LoggedInDetails.setEmail(getLoggedInPersonEmail().toString());
      //         return ChooseUser();
      //       } else {
      //         return AuthScreen();
      //       }
      //     }),
      debugShowCheckedModeBanner: false,
    );
  }
}
