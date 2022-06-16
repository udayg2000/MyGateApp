// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, avoid_print, must_be_immutable
import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/screens/admin/utils/dropdown.dart';
import 'package:my_gate_app/screens/admin/utils/submit_button.dart';
import 'package:my_gate_app/screens/admin/utils/textbox.dart';
import 'package:my_gate_app/screens/utils/custom_snack_bar.dart';
import 'package:my_gate_app/screens/utils/scrollable_widget.dart';

class VisitorForm extends StatefulWidget {
  const VisitorForm({
    Key? key,
    required this.location,
  }) : super(key: key);
  final String location;

  @override
  _VisitorFormState createState() => _VisitorFormState();
}

class _VisitorFormState extends State<VisitorForm> {
  String visitor_name = "";
  String mobile_number = "";
  String car_number = "";
  List<String> authorities = [];
  String purpose = "";

  List<String> duration = [
    "15 min",
    "30 min",
    "45 min",
    "1 hour",
    "2 hours",
    "3 hours",
    "4 hours",
    "5 hours",
    "> 5 hours"
  ];

  String authority_name = "None";
  String authority_email = "None";
  String authority_designation = "None";
  String duration_of_stay = "None";

  final student_message_form_key = GlobalKey<FormState>();

  Future<void> get_authorities_list() async {
    List<String> authorities_backend = await databaseInterface.get_authorities_list();
    setState(() {
      authorities = authorities_backend;
    });
  }

  @override
  void initState() {
    super.initState();
    get_authorities_list();
  }

  void display_further_status(int statusCode) {
    Navigator.of(context).pop();
    if (statusCode == 200) {
      final snackBar =
          get_snack_bar("Ticket raised successfully", Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = get_snack_bar("Failed to raise ticket", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text('Visitor Form'),
          ],
        ),
      ),
      body: ScrollableWidget(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [Colors.lightBlueAccent, Colors.lightGreenAccent]),
          ),
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Image.asset(
              'assets/images/visitor.webp',
              // 'assets/images/ticket.jpg',
              height: 300,
              width: 300,
            ),
            SizedBox(
              height: 10,
            ),
            dropdown(
              context,
              authorities,
              (String? s) {
                if (s != null) {
                  int idx = s.indexOf("\n");
                  var list_authority = [s.substring(0,idx).trim(), s.substring(idx+1).trim()];
                  idx = list_authority[0].indexOf(", ");
                  var list_auth_name_design = [list_authority[0].substring(0,idx).trim(), list_authority[0].substring(idx+1).trim()];

                  authority_name = list_auth_name_design[0];
                  authority_designation = list_auth_name_design[1];
                  authority_email = list_authority[1];
                }
              },
              "Choose Authority",
              Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            dropdown(
              context,
              duration,
              (String? s) {
                if (s != null) {
                  duration_of_stay = s;
                }
              },
              "Duration of stay",
              Icon(
                Icons.access_time_outlined,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TextBoxCustom(
              labelText: "Visitor Name",
              onChangedFunction: (value) {
                visitor_name = value!;
              },
              icon: const Icon(
                // Icons.mail_outline,
                Icons.person,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TextBoxCustom(
              labelText: "Mobile Number",
              onChangedFunction: (value) {
                mobile_number = value!;
              },
              icon: const Icon(
                Icons.mail_outline,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TextBoxCustom(
              labelText: "Vehicle Number",
              onChangedFunction: (value) {
                car_number = value!;
              },
              icon: const Icon(
                Icons.directions_car_outlined,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TextBoxCustom(
              labelText: "Purpose of visit",
              onChangedFunction: (value) {
                purpose = value!;
              },
              icon: const Icon(
                Icons.message,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SubmitButton(
              button_text: "Generate",
              submit_function: () async {
                int statusCode = await databaseInterface.insert_in_visitors_ticket_table(visitor_name,mobile_number,car_number,authority_name,
                authority_email,authority_designation,purpose,"enter",duration_of_stay);
                display_further_status(statusCode); // Used to display the snackbar
              },
            ),
            SizedBox(
              height: 50,
            ),
          ]),
        ),
      )
    );
  }
}
