// ignore_for_file: unnecessary_new, sized_box_for_whitespace, deprecated_member_use, prefer_const_constructors, avoid_print, non_constant_identifier_names, unused_field

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_gate_app/auth/authscreen.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/database/database_interface.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formkey = GlobalKey<FormState>();
  var _password = '';
  var _reentered_password = '';
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  LoginResultObj is_authenticated = LoginResultObj("", "");

  Future<String> reset_password() async {
    final validity = _formkey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (validity != null && validity) {
      _formkey.currentState?.save();
      String message = await databaseInterface.reset_password(
          widget.email, _password.toString());
      return message;
    }

    return "Password RESET Failed";
  }

  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/reset_password.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              Text(
                'Reset Password Page',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                // ignore: prefer_const_constructors
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 140,
                ),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: _obscureText1,
                        keyboardType: TextInputType.emailAddress,
                        key: const ValueKey('password'),
                        // how does this work?
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is empty';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _password = value;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: const BorderSide(),
                          ),
                          labelText: "Enter New Password",
                          labelStyle: GoogleFonts.roboto(),
                          suffixIcon: GestureDetector(
                            onTap: _toggle1,
                            child: new Icon(_obscureText1
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: _obscureText2,
                        keyboardType: TextInputType.emailAddress,
                        key: const ValueKey('confirmPassword'),
                        // how does this work?
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is empty';
                          }
                          if (value != _password) {
                            //return value;
                            return 'Password does not match';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _reentered_password = value;
                        },
                        onSaved: (value) {
                          _reentered_password = value!;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: const BorderSide(),
                          ),
                          labelText: "Re-Enter New Password",
                          labelStyle: GoogleFonts.roboto(),
                          suffixIcon: GestureDetector(
                            onTap: _toggle2,
                            child: new Icon(_obscureText2
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        width: double.infinity,
                        height: 75,
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        child: RaisedButton(
                          child: Text(
                            'Reset Password',
                            style: GoogleFonts.roboto(fontSize: 16),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            print("RESET Password pressed");
                            String message = await reset_password();
                            print(message);
                            if (message == "Password RESET Successful") {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => AuthScreen()),
                              );
                            } else {
                              // TODO
                              // Text(
                              //   message,
                              //   style: GoogleFonts.roboto(fontSize: 16),
                              // );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

//class RoundedRectangularBorder {}
