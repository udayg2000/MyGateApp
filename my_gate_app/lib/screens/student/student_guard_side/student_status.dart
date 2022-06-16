// ignore_for_file: unnecessary_new, deprecated_member_use, non_constant_identifier_names, prefer_const_constructors, unnecessary_this, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, must_be_immutable

import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/admin/utils/dropdown.dart';
import 'package:my_gate_app/screens/utils/custom_snack_bar.dart';

class StudentStatus extends StatefulWidget {
  StudentStatus({
    Key? key,
    required this.location,
    required this.in_or_out,
    required this.inside_parent_location,
    required this.exited_all_children,
    required this.pre_approval_required,
  }) : super(key: key);

  final String location;
  String in_or_out; // "in", "pending_entry", "out", "pending_out"
  String inside_parent_location; // "true" or "false"
  String exited_all_children; // "true" or "false"
  bool pre_approval_required;

  @override
  _StudentStatusState createState() => _StudentStatusState();
}

class _StudentStatusState extends State<StudentStatus> {
  String ticket_raised_message = '';
  String exit_ticket_raised_message = '';
  String parent_location = '';
  String choosen_authority_ticket = "None";
  List<String> enter_authorities_tickets = [];
  List<String> exit_authorities_tickets = [];

  Future<void> get_parent_location_name() async {
    String parent_location_local =
        await databaseInterface.get_parent_location_name(widget.location);
    setState(() {
      parent_location = parent_location_local;
    });
  }

  Future<void> get_authority_tickets_with_status_accepted() async {
    String email = LoggedInDetails.getEmail();
    if (widget.in_or_out == "out") {
      List<String> enter_authorities_tickets_local =
          await databaseInterface.get_authority_tickets_with_status_accepted(
              email, widget.location, "enter");
      setState(() {
        enter_authorities_tickets = enter_authorities_tickets_local;
      });
    } else if (widget.in_or_out == "in") {
      List<String> exit_authorities_tickets_local =
          await databaseInterface.get_authority_tickets_with_status_accepted(
              email, widget.location, "exit");
      setState(() {
        exit_authorities_tickets = exit_authorities_tickets_local;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    get_parent_location_name();
    get_authority_tickets_with_status_accepted();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, // Change the color of background
        
        // ///////////////////////////
  //       decoration: BoxDecoration(
  //           // gradient: LinearGradient(
  //           //   begin: Alignment.topRight,
  //           //   end: Alignment.bottomLeft,
  //           //   stops: [
  //           //     0.1,
  //           //     0.4,
  //           //     0.6,
  //           //     0.9,
  //           //   ],
  //           //   colors: [
  //           //     Colors.yellow.withOpacity(0.3),
  //           //     Colors.red.withOpacity(0.3),
  //           //     Colors.indigo.withOpacity(0.3),
  //           //     Colors.teal.withOpacity(0.3),
  //           //   ],
  //           // )

  //           gradient: LinearGradient(
  //   colors: [
  //     Colors.white,
  //     Colors.white70,
  //   ],
  // ),
  //         ),


        // ///////////////////////////
        
        
        
        
        
        
        
        
        
        child: ListView(
      children: [
        Center(
          child: Wrap(
            children: [
              getStatusSection(),
              if (widget.pre_approval_required) getDropDownMenu(),
              getButtonSection(),
            ],
          ),
        ),
      ],
    ));
  }

  Widget getDropDownMenu() {
    if (widget.in_or_out == 'out') {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(15.0),
            child: dropdown(
              context,
              this.enter_authorities_tickets,
              (String? s) {
                if (s != null) {
                  // print("inside funciton:" + this.chosen_parent_location);
                  this.choosen_authority_ticket = s;
                  // print(this.chosen_parent_location);
                }
              },
              "Choose Authority Ticket",
              Icon(
                Icons.corporate_fare,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ));
    } else if (widget.in_or_out == 'in') {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(15.0),
            child: dropdown(
              context,
              this.exit_authorities_tickets,
              (String? s) {
                if (s != null) {
                  // print("inside funciton:" + this.chosen_parent_location);
                  this.choosen_authority_ticket = s;
                  // print(this.chosen_parent_location);
                }
              },
              "Choose Authority Ticket",
              Icon(
                Icons.corporate_fare,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ));
    } else {
      return Text("");
    }
  }

  // This represents the top half of the page
  Widget getStatusSection() {
    // print("getStatusSection called with in_or_out value: " + widget.in_or_out);
    if (widget.in_or_out == 'in') {
      return StatusIN(location: widget.location);
    } else if (widget.in_or_out == 'pending_entry') {
      return StatusPendingEntry(location: widget.location);
    } else if (widget.in_or_out == 'pending_exit') {
      return StatusPendingExit(location: widget.location);
    } else if (widget.in_or_out == 'out') {
      return StatusOUT(location: widget.location);
    } else {
      return Text("Invalid Status",
          style: TextStyle(
            fontSize: 20,
          ));
    }
  }

  //  This represents the bottom half of the page
  Widget getButtonSection() {
    // print("getButtonSection called with in_or_out value: " + widget.in_or_out);
    if (widget.in_or_out == 'out') {
      if (widget.inside_parent_location == "true") {
        return EnterButton(
          enter_function: show_popup,
          enter_message: this.ticket_raised_message,
        );
      } else {
        return Text(
            "Cannot enter this location if not entered its parent location - ${parent_location}");
      }
    } else if (widget.in_or_out == 'in') {
      if (widget.exited_all_children == "true") {
        return ExitButton(
          exit_function: show_popup,
          exit_message: this.exit_ticket_raised_message,
        );
      } else {
        return Text(
            "Cannot exit this location if not exited all its children location");
      }
    } else {
      return Text("");
    }
  }

  void display_further_status(int statusCode, String person_status){
    Navigator.of(context).pop();
    if(statusCode == 200){
      setState(() {
        // After adding the entry, update the status to "pending_entry"
        widget.in_or_out = person_status;
      });
    }else{
      // snackbar
      final snackBar = get_snack_bar("Failed to raise ticket", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // This function is used to show the pop up when one press enter button
  show_popup(String ticket_type) {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text('Are you sure you want to ' + ticket_type + ' ?'),
              ],
            ),
          ),
          actions: [
            // If one press the Yes button of the popup
            new FlatButton(
              child: new Text('Yes'),
              onPressed: () async {
                int statusCode;
                if (ticket_type == "enter") {
                  statusCode = await enter_button_pressed();
                  display_further_status(statusCode, "pending_entry");

                } else if (ticket_type == "exit") {
                  statusCode = await exit_button_pressed();
                  display_further_status(statusCode, "pending_exit");
                }

                // Navigator.of(context).pop();
              },
            ),
            // If one press the No button of the popup
            new FlatButton(
              child: new Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // When the value is "in", that means you should show the person exit button

  // This is called when we press entry button
  Future<int> enter_button_pressed() async {
    String current_user_email = LoggedInDetails.getEmail();
    databaseInterface db = new databaseInterface();
    String location_local = widget.location;
    String date_time = DateTime.now().toString();
    // DateTime now = DateTime.now();
    // String data_time = DateFormat('kk:mm:ss\n dd-MM-yyyy').toString();
    String ticket_type = "enter";
    // Insert into Guard Ticket Table, a ticket of type "enter". This will also update the status of person as pending_entry
    int statusCode;
    if(widget.pre_approval_required){
      statusCode = await db.insert_in_guard_ticket_table(current_user_email, location_local, date_time, ticket_type, choosen_authority_ticket);
    }else{
      statusCode = await db.insert_in_guard_ticket_table(current_user_email, location_local, date_time, ticket_type, "");
    }
    return statusCode;


  }

  // This is called when we press exit button
  Future<int> exit_button_pressed() async {
    String current_user_email = LoggedInDetails.getEmail();
    databaseInterface db = new databaseInterface();
    String location_local = widget.location;
    String data_time = DateTime.now().toString();
    String ticket_type = "exit";

    int statusCode;
    // Insert into Guard Ticket Table, a ticket of type "Exit". This will also update the status of person as pending_exit
    if(widget.pre_approval_required){
      statusCode = await db.insert_in_guard_ticket_table(current_user_email, location_local, data_time, ticket_type, choosen_authority_ticket);
    }else{
      statusCode = await db.insert_in_guard_ticket_table(current_user_email, location_local, data_time, ticket_type, "");
    }
    return statusCode;
  }

// change_pending() {
//   setState(() {
//     if (in_or_out == "pending_entry") {
//       in_or_out = "in";
//     } else if (in_or_out == "pending_exit") {
//       in_or_out = "out";
//     }
//   });
// }

}

// Displays the checked out image
class StatusOUT extends StatelessWidget {
  const StatusOUT({Key? key, required this.location}) : super(key: key);
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.only(top: 25),
      // padding: const EdgeInsets.all(80),

      
      // padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.blueAccent),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: FittedBox(
              child: Container(
                margin: EdgeInsets.all(10),
                // margin: EdgeInsets.only(top:20),
                height: 200,
                child: Image.asset("assets/images/checked_out_2.jpg"),
                // child: Image.asset("assets/images/checked_out_2.png"),
              ),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Status: Outside ${location}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontFamily: 'roboto'),
          ),
        ],
      ),
    );
  }
}

// Displays the checked in image
class StatusIN extends StatelessWidget {
  const StatusIN({Key? key, required this.location}) : super(key: key);
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.only(top: 25),
      // padding: const EdgeInsets.all(80),


      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.blueAccent),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: FittedBox(
              child: Container(
                margin: EdgeInsets.all(10),
                height: 200,
                child: Image.asset("assets/images/checked_in.png"),
              ),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Status: Inside ${location}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontFamily: 'roboto'),
          ),
        ],
      ),
    );
  }
}

class StatusPendingEntry extends StatelessWidget {
  const StatusPendingEntry({Key? key, required this.location})
      : super(key: key);
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      // padding: const EdgeInsets.all(80),
      padding: const EdgeInsets.only(top: 25),

      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.blueAccent),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: FittedBox(
              child: Container(
                margin: EdgeInsets.all(10),
                height: 200,
                child: Image.asset("assets/images/pending.jpg"),
              ),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Status: Pending Entry Request for ${location}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontFamily: 'roboto'),
          ),
        ],
      ),
    );
  }
}

class StatusPendingExit extends StatelessWidget {
  const StatusPendingExit({Key? key, required this.location}) : super(key: key);
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      // padding: const EdgeInsets.all(80),
      padding: const EdgeInsets.only(top: 25),
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.blueAccent),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: FittedBox(
              child: Container(
                margin: EdgeInsets.all(10),
                height: 200,
                child: Image.asset("assets/images/pending.jpg"),
              ),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Status: Pending Exit request for ${location}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontFamily: 'roboto'),
          ),
        ],
      ),
    );
  }
}

class EnterButton extends StatelessWidget {
  const EnterButton(
      {Key? key, required this.enter_function, required this.enter_message})
      : super(key: key);
  final void Function(String) enter_function;
  final String enter_message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            //color: Colors.green,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    // ignore: prefer_const_literals_to_create_immutables
                    colors: [
                      Color.fromRGBO(255, 143, 158, 1),
                      Color.fromRGBO(255, 188, 143, 1),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blue)))),
                onPressed: () {
                  this.enter_function("enter");
                },
                child: FittedBox(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: 100,
                    child: Image.asset("assets/images/enter_button.png"),
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Text(
            this.enter_message,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ExitButton extends StatelessWidget {
  const ExitButton(
      {Key? key, required this.exit_function, required this.exit_message})
      : super(key: key);
  final void Function(String) exit_function;
  final String exit_message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 143, 158, 1),
                      Color.fromRGBO(255, 188, 143, 1),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blue)))),
                onPressed: () {
                  this.exit_function("exit");
                },
                child: FittedBox(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: 100,
                    child: Image.asset("assets/images/exit_button.jpeg"),
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Text(
            this.exit_message,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
