// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_gate_app/auth/authform.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(title: Text('Authentication'),
      appBar: AppBar(
      // backgroundColor: Color(0x44000000),
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 30,
      ),
      body: AuthForm(),
    );
  }
}
