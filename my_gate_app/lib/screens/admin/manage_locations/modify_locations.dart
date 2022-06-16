// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/screens/admin/utils/dropdown.dart';
import 'package:my_gate_app/screens/admin/utils/submit_button.dart';
import 'package:my_gate_app/screens/admin/utils/textbox.dart';
import 'package:my_gate_app/screens/utils/custom_snack_bar.dart';

class ModifyLocations extends StatefulWidget {
  const ModifyLocations({Key? key}) : super(key: key);

  @override
  _ModifyLocationsState createState() => _ModifyLocationsState();
}

class _ModifyLocationsState extends State<ModifyLocations> {
  String chosen_modify_location = "None";
  String chosen_parent_location = "None";
  String chosen_pre_approval_needed = "None"; // Takes value "Yes"|"No"|"None"
  String automatic_exit_required = "None"; // Takes value "Yes"|"No"|"None"
  List<String> parent_locations = [];
  // List<String> parent_locations = databaseInterface.getLoctions();

  @override
  void initState(){
    super.initState();
    databaseInterface.getLoctions2().then((result){
      setState(() {
        parent_locations=result;
      });
    });
  }

  Future<void> modify_locations() async {
    print("submit button of modify locations pressed");

    if (chosen_modify_location == "None") {
      print(
          "Display red warning message for chosen_modify_location: Cannot be None");
      final snackBar = get_snack_bar("chosen modify location: Cannot be None", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (chosen_pre_approval_needed == "None") {
      print(
          "Display red warning message for chosen_pre_approval_needed: Cannot be None");
      final snackBar = get_snack_bar("chosen pre approval needed: Cannot be None", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if(automatic_exit_required == "None"){
      print("Display red warning message for automatic_exit_required: Cannot be None");
      final snackBar = get_snack_bar("automatic exit required: Cannot be None", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    String response = await databaseInterface.modify_locations(
        chosen_modify_location,
        chosen_parent_location,
        chosen_pre_approval_needed,
        automatic_exit_required);
    if (response == "Location updated successfully") {
      print("Display snackbar: Location updated successfully");
      final snackBar = get_snack_bar("Location updated successfully", Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    } else {
      print("Display snackbar: Failed to update location");
      print("Display snackbar: " + response);
      final snackBar = get_snack_bar("Failed to update location", Colors.red);
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
        color: Colors.yellow,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Modify Location",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                  fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            dropdown(
              context,
              this.parent_locations,
              (String? s) {
                if (s != null) {
                  print("inside funciton:" + this.chosen_modify_location);
                  this.chosen_modify_location = s;
                  print(this.chosen_modify_location);
                }
              },
              "Location To Modify",
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
              this.parent_locations,
              (String? s) {
                if (s != null) {
                  print("inside funciton:" + this.chosen_parent_location);
                  this.chosen_parent_location = s;
                  print(this.chosen_parent_location);
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
            SizedBox(
              height: 50,
            ),
            SubmitButton(
                submit_function: () async {
                  modify_locations();
                },
                button_text: "Update")
          ],
        ),
      ),
    );
  }
}
