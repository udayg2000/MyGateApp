import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/screens/admin/utils/dropdown.dart';
import 'package:my_gate_app/screens/admin/utils/submit_button.dart';

class ModifyGuards extends StatefulWidget {
  const ModifyGuards({Key? key}) : super(key: key);

  @override
  _ModifyGuardsState createState() => _ModifyGuardsState();
}

class _ModifyGuardsState extends State<ModifyGuards> {
  String chosen_modify_guard = "None";
  String chosen_modify_guard_email = "None";
  String chosen_modify_guard_location = "None";
  final List<String> guard_names = databaseInterface.getGuardNames();
  // final List<String> guard_emails = databaseInterface.getGuardLocations();
  List<String> guard_emails =[];
  
  // List<String> guard_emails = [];
  List<String> locations=[];
  // final List<String> locations = databaseInterface.getLoctions();
  
  @override
  void initState(){
    super.initState();
    print("Init state called");
    databaseInterface.getLoctions2().then((result){
      setState(() {
        locations=result;
      });
    });
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
        color: Colors.yellow,
        child: Column(
          children: [
             SizedBox(
              height: 50,
            ),
            Text(
              "Modify Guard",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                  fontSize: 30),
            ),
            /*SizedBox(
              height: 50,
            ),

            dropdown(
              context,
              this.guard_names,
                  (String? s) {
                if (s != null) {
                  print("inside funciton:" + this.chosen_modify_guard);
                  this.chosen_modify_guard = s;
                  print(this.chosen_modify_guard);
                }
              },
              "Guard Name",
              Icon(
                Icons.security,
                color: Colors.black,
              ),
            ), */


            SizedBox(
              height: 50,
            ),
            dropdown(
              context,
              this.guard_emails,
                  (String? s) {
                if (s != null) {
                  print("inside funciton:" + this.chosen_modify_guard_email);
                  this.chosen_modify_guard_email = s;
                  print(this.chosen_modify_guard_email);
                }
              },
              "Guard Email",
              Icon(
                Icons.email_outlined,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            dropdown(
              context,
              this.locations,
                  (String? s) {
                if (s != null) {
                  // print("inside funciton:" + this.chosen_parent_location);
                  this.chosen_modify_guard_location = s;
                  // print(this.chosen_parent_location);
                }
              },
              "Guard Location",
              Icon(
                Icons.corporate_fare,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SubmitButton(submit_function: () async {
                if (this.chosen_modify_guard_email!="None" && this.chosen_modify_guard_location!="None"){
                  String response = await databaseInterface.modify_guard(this.chosen_modify_guard_email,this.chosen_modify_guard_location);
                  print("Response: " + response);
                }

            }, button_text: "Update")
          ],
        ),
      ),
    );
  }
}
