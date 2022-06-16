// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unnecessary_this, avoid_print

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/screens/admin/utils/dropdown.dart';
import 'package:my_gate_app/screens/admin/utils/submit_button.dart';
import 'package:my_gate_app/screens/admin/utils/textbox.dart';
import 'package:my_gate_app/screens/utils/custom_snack_bar.dart';

class AddLocations extends StatefulWidget {
  const AddLocations({Key? key}) : super(key: key);

  @override
  _AddLocationsState createState() => _AddLocationsState();
}

class _AddLocationsState extends State<AddLocations> {
  String new_location_name = "None";
  List<String> parent_locations = [];

  // List<String> parent_locations = databaseInterface.getLoctions();
  final location_name_form_key = GlobalKey<FormState>();

  String chosen_parent_location = "None";
  String chosen_pre_approval_needed = "None"; // Takes value "Yes"|"No"|"None"
  String automatic_exit_required = "None"; // Takes value "Yes"|"No"|"None"
  // Add None value to the list parent_locations
  @override
  void initState() {
    super.initState();
    databaseInterface.getLoctions2().then((result) {
      setState(() {
        parent_locations = result;
      });
    });
  }

  Future<void> add_new_location() async {
    print("submit button of add new location pressed");
    // new_location_name = "Main Gate";
    // chosen_parent_location = "None";
    // chosen_pre_approval_needed = "Yes";
    // automatic_exit_required = "No";

    if (new_location_name == "None") {
      print(
          "Display red warning message for new_location_name: Cannot be None");
      final snackBar = get_snack_bar("New Location Name: Cannot be None", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (chosen_pre_approval_needed == "None") {
      print(
          "Display red warning message for chosen_pre_approval_needed: Cannot be None");
      final snackBar = get_snack_bar("Pre Approval Needed: Cannot be None", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    }
    if(automatic_exit_required == "None"){
      print("Display red warning message for automatic_exit_required: Cannot be None");
      final snackBar = get_snack_bar("Automatic Exit Required: Cannot be None", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    String response = await databaseInterface.add_new_location(
        new_location_name,
        chosen_parent_location,
        chosen_pre_approval_needed,
        automatic_exit_required);
    if (response == "New location added successfully") {
      print("Display snackbar: New loction added successfully");
      final snackBar = get_snack_bar("New loction added successfully", Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    } else {
      print("Display snackbar: Failed to add new location");
      print("Display snackbar: " + response);
      final snackBar = get_snack_bar("Failed to add new location", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.orange,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Create New Location",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                  fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            TextBoxCustom(
              labelText: "Enter New Location",
              onSavedFunction: (value) {
                this.new_location_name = value!;
                print("text form : " + this.new_location_name);
              },
              icon: const Icon(
                Icons.add_location,
                color: Colors.black,
              ),
              form_key: this.location_name_form_key,
            ),
            SizedBox(
              height: 50,
            ),
            dropdown(
              context,
              this.parent_locations,
              (String? s) {
                if (s != null) {
                  // print("inside funciton:" + this.chosen_parent_location);
                  this.chosen_parent_location = s;
                  // print(this.chosen_parent_location);
                }
              },
              "Parent Location",
              Icon(
                Icons.corporate_fare,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            dropdown(
              context,
              ["Yes", "No"],
              (String? s) {
                if (s != null) {
                  this.chosen_pre_approval_needed = s;
                }
              },
              "Pre Approval Required",
              Icon(
                Icons.question_answer,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            dropdown(
              context,
              ["Yes", "No"],
                  (String? s) {
                if (s != null) {
                  this.automatic_exit_required = s;
                }
              },
              "Automatic Exit Required",
              Icon(
                Icons.question_answer,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SubmitButton(
              submit_function: () async {
                final location_name_validity =
                    this.location_name_form_key.currentState?.validate();
                FocusScope.of(context).unfocus();
                if (location_name_validity != null && location_name_validity) {
                  this.location_name_form_key.currentState?.save();
                }
                if (location_name_validity != null && location_name_validity) {
                  add_new_location();
                } else {
                  print("some field is invalid");
                }
                add_new_location();
              },
              button_text: "Add",
            )
          ],
        ),
      ),
    );
  }
}
