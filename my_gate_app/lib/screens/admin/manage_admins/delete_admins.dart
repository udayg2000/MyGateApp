import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/screens/admin/utils/dropdown.dart';
import 'package:my_gate_app/screens/admin/utils/submit_button.dart';
import 'package:my_gate_app/screens/admin/utils/textbox.dart';

class DeleteGuards extends StatefulWidget {
  const DeleteGuards({Key? key}) : super(key: key);

  @override
  _DeleteGuardsState createState() => _DeleteGuardsState();
}

class _DeleteGuardsState extends State<DeleteGuards> {
  String chosen_delete_guard_name = "None";
  String chosen_delete_guard_email = "None";

  final List<String> guard_names = databaseInterface.getGuardNames();
  // final List<String> guard_emails = databaseInterface.getGuardLocations();
  List<String> guard_emails = [];

  @override
  void initState(){
    super.initState();
    databaseInterface.get_all_guard_emails().then((result){
      setState(() {
        guard_emails= result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.cyanAccent,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Delete Guard",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                  fontSize: 30),
            ),
            /* SizedBox(
              height: 50,
            ),

            dropdown(
              context,
              this.guard_names,
                  (String? s) {
                if (s != null) {
                  print("inside funciton:" + this.chosen_delete_guard_name);
                  this.chosen_delete_guard_name = s;
                  print(this.chosen_delete_guard_name);
                }
              },
              "Guard Name",
              Icon(
                Icons.security,
                color: Colors.black,
              ),
            ), */
            SizedBox(height: 50,),
            dropdown(
              context,
              this.guard_emails,
                  (String? s) {
                if (s != null) {
                  print("inside funciton:" + this.chosen_delete_guard_email);
                  this.chosen_delete_guard_email = s;
                  print(this.chosen_delete_guard_email);
                }
              },
              "Guard Email",
              Icon(
                Icons.email_outlined,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 50,),
            SubmitButton(submit_function: () async {
                if (this.chosen_delete_guard_email!="None"){
                  String response = await databaseInterface.delete_guard(this.chosen_delete_guard_email);
                  print("Response: " + response);
                }

            }, button_text: "Delete")
          ],
        ),
      ),
    );
  }
}
