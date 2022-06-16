// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unnecessary_this, avoid_print

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/screens/admin/utils/dropdown.dart';
import 'package:my_gate_app/screens/admin/utils/submit_button.dart';
import 'package:my_gate_app/screens/admin/utils/textbox.dart';

class AddAdmins extends StatefulWidget {
  const AddAdmins({Key? key}) : super(key: key);

  @override
  _AddAdminsState createState() => _AddAdminsState();
}

class _AddAdminsState extends State<AddAdmins> {
  String new_admin_name = "None";
  String new_admin_email = "None";

  final admin_name_form_key = GlobalKey<FormState>();
  final admin_email_form_key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
              "Add New Admin",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                  fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            TextBoxCustom(
              labelText: "Enter Admin Name",
              form_key: this.admin_name_form_key,
              onSavedFunction: (value) {
                this.new_admin_name = value!;
              },
              icon: const Icon(
                Icons.security,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TextBoxCustom(
              labelText: "Enter Admin Email",
              form_key: this.admin_email_form_key,
              onSavedFunction: (value) {
                this.new_admin_email = value!;
              },
              icon: const Icon(
                Icons.email_outlined,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SubmitButton(
              button_text: "Add",
              submit_function: () async {
                final guard_name_validity = this.admin_name_form_key.currentState?.validate();
                FocusScope.of(context).unfocus();
                if (guard_name_validity != null && guard_name_validity) {
                  this.admin_name_form_key.currentState?.save();
                }
                final guard_email_validity = this.admin_email_form_key.currentState?.validate();
                FocusScope.of(context).unfocus();
                if (guard_email_validity != null && guard_email_validity) {
                  this.admin_email_form_key.currentState?.save();
                }
                if (this.new_admin_name != "None" && this.new_admin_email != "None") {
                  String response = await databaseInterface.add_admin_form(this.new_admin_name,this.new_admin_email);
                  print("Response: " + response);
                }
                else{
                  print("One of the fields in None");
                  print("value of new_admin_name: " + new_admin_name);
                  print("value of new_admin_email: " + new_admin_email);
                }
              },              
            )
          ],
        ),
      ),
    );
  }
}
