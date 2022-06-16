// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:my_gate_app/screens/student/student_authorities_side/student_authorities_tabs.dart';
import 'package:my_gate_app/screens/student/student_guard_side/student_tabs.dart';

class RaiseTicketForGuardOrAuthorities extends StatefulWidget {
  const RaiseTicketForGuardOrAuthorities(
      {Key? key, required this.location, required this.pre_approval_required})
      : super(key: key);
  final String location;
  final bool pre_approval_required;

  @override
  State<RaiseTicketForGuardOrAuthorities> createState() =>
      _RaiseTicketForGuardOrAuthoritiesState();
}

class _RaiseTicketForGuardOrAuthoritiesState
    extends State<RaiseTicketForGuardOrAuthorities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Raise Request"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.white]),
        ),
        child: Center(
          child: Column(
            // add Column
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text('Welcome', style: TextStyle( // your text
              //     fontSize: 50.0,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white)
              // ),
              // RaisedButton(onPressed: () {Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => StudentTicketTable(location: widget.location))
              // );
              // }, child: Text('Raise Ticket for Guard'),
              // ), // your button beneath text
              Image.asset('assets/images/security-guard.png'),
              SizedBox(height: 100,),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentTabs(
                                location: widget.location,
                                pre_approval_required:
                                    widget.pre_approval_required,
                              )));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      // colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                      colors: [Colors.red, Colors.purple],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Raise Ticket for Guard",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentAuthoritiesTabs(
                              location: widget.location)));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.greenAccent, Colors.lightBlueAccent],
                        // colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Raise Ticket for Authorities",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              // RaisedButton(onPressed: () {}, child: Text('Raise Ticket for Authorities'),), // your button beneath text
            ],
          ),
        ),
      ),
    );
  }
}
