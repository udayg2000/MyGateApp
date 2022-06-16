// ignore_for_file: unnecessary_new, sized_box_for_whitespace, deprecated_member_use, prefer_const_constructors, avoid_print, non_constant_identifier_names, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_gate_app/auth/forgot_password.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/admin/home_admin.dart';
import 'package:my_gate_app/screens/authorities/authority_main.dart';
import 'package:my_gate_app/screens/authorities/authority_tabs.dart';
import 'package:my_gate_app/screens/choose_user_type.dart';
import 'package:my_gate_app/screens/guard/enter_exit.dart';
import 'package:my_gate_app/screens/guard/guard_tabs.dart';
import 'package:my_gate_app/screens/guard/home_guard.dart';
import 'package:my_gate_app/screens/profile2/model/user.dart';
import 'package:my_gate_app/screens/profile2/profile_page.dart';
import 'package:my_gate_app/screens/profile2/profile_page_2.dart';
import 'package:my_gate_app/screens/student/home_student.dart';
import 'package:my_gate_app/screens/student/raise_ticket_for_guard_or_authorities.dart';
import 'package:my_gate_app/screens/student/student_guard_side/student_tabs.dart';
import 'package:my_gate_app/screens/utils/custom_snack_bar.dart';
import 'package:my_gate_app/screens/utils/display_snack_bar.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _guard_location = '';
  LoginResultObj is_authenticated = LoginResultObj("", "");

  // var _reentered_password = '';
  // var _username = '';
  // bool isLoginPage = false;
  bool _obscureText = true;

  Future<void> startauthentication() async {
    final validity = _formkey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (validity != null && validity) {
      _formkey.currentState?.save();
      // Add basic checks for email and password in the frontend
      is_authenticated = await databaseInterface.login_user(_email, _password);
      if (is_authenticated.person_type != "NA") {
        LoggedInDetails.setEmail(_email);
      }
    }
  }

  Future<void> guardLocation() async {
    databaseInterface db = new databaseInterface();
    await db.get_guard_by_email(_email).then((GuardUser result) {
      setState(() {
        _guard_location = result.location;
        print("Result Location in Auth form" + result.location);
      });
    });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/spiral3.png"),
            // // image: Image.asset("assets/images/spiral3.png"),
            fit: BoxFit.cover,
          ),
        ),
        // child: new BackdropFilter(
        //   filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        //   child: new Container(
        //     decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
        //   ),
        // ),
        child: ListView(
          children: [
            // Container(
            //   margin: EdgeInsets.all(10),
            //   height: 200,
            //   child: Image.asset('images/spiral1.JPG'),
            // ),
            Text(
              'Login Page',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // SizedBox(
            //   height: 4,
            // ),
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
                      keyboardType: TextInputType.emailAddress,
                      key: const ValueKey('email'),
                      // how does this work?
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Invalid Email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: const BorderSide(),
                        ),
                        labelText: "Enter Email",
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: _obscureText,
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
                        labelText: "Enter Password",
                        labelStyle: GoogleFonts.roboto(),
                        suffixIcon: GestureDetector(
                          onTap: _toggle,
                          child: new Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // TextFormField(
                    //   obscureText: _obscureText,
                    //   keyboardType: TextInputType.emailAddress,
                    //   key: const ValueKey('confirmPassword'),
                    //   // how does this work?
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Password is empty';
                    //     }
                    //     if (value != _password) {
                    //       //return value;
                    //       return 'Password does not match';
                    //     }
                    //     return null;
                    //   },
                    //   onChanged: (value) {
                    //     _reentered_password = value;
                    //   },
                    //   onSaved: (value) {
                    //     _reentered_password = value!;
                    //   },
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //       borderRadius: new BorderRadius.circular(8.0),
                    //       borderSide: const BorderSide(),
                    //     ),
                    //     labelText: "Re-Enter Password",
                    //     labelStyle: GoogleFonts.roboto(),
                    //     suffixIcon: GestureDetector(
                    //       onTap: _toggle,
                    //       child: new Icon(_obscureText
                    //           ? Icons.visibility
                    //           : Icons.visibility_off),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 10),
                    Container(
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()),
                            );
                            // forgot_password();
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.roboto(
                                fontSize: 15, color: Colors.white),
                          )),
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
                          'Login',
                          style: GoogleFonts.roboto(fontSize: 16),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () async {
                          await startauthentication();
                          // is_authenticated.person_type = "Guard";
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //     builder: (context) => EntryExit(
                          //       guard_location: _guard_location,
                          //     ),
                          //   ),
                          // // );
                          // is_authenticated.person_type = "Authority";
                          // LoggedInDetails.setEmail("chiefwarden@iitrpr.ac.in");
                          
                          // is_authenticated.person_type = "Student";
                          // LoggedInDetails.setEmail("2019csb1107@iitrpr.ac.in");
                          

                          if (is_authenticated.person_type == "Student") {
                            print("Inside Student");
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomeStudent()),
                            );

                            // Navigator.of(context).pushReplacement(
                            //   MaterialPageRoute(
                            //       builder: (context) => ProfilePage(email: '2019csb1107@iitrpr.ac.in',isEditable: false,)),
                            // );


                            // Navigator.of(context).pushReplacement(
                            //   MaterialPageRoute(
                            //       builder: (context) => StudentTabs(
                            //         location: 'Main Gate',
                            //         pre_approval_required: true,
                            //       )),
                            // );
                          } else if (is_authenticated.person_type == "Guard") {
                            await guardLocation();
                            // print("Inside Guard");
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => EntryExit(
                                        guard_location: _guard_location,
                                      )),
                            );
                          } else if (is_authenticated.person_type ==
                              "Authority") {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => AuthorityMain()),
                            );
                          } else if (is_authenticated.person_type == "Admin") {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomeAdmin()),
                            );
                          } else {
                            print("Login failed .... display snackbar");
                            final snackBar =
                                get_snack_bar("Login failed", Colors.red);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            print(is_authenticated.message);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

//class RoundedRectangularBorder {}
