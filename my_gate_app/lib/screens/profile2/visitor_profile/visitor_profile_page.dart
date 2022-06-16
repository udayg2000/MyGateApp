// ignore_for_file: non_constant_identifier_names, unused_local_variable, unnecessary_new

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/profile2/authority_profile/authority_edit_profile_page.dart';
// import 'package:my_gate_app/screens/profile2/guard_profile/guard_edit_profile_page.dart';
import 'package:my_gate_app/screens/profile2/model/user.dart';
import 'package:my_gate_app/screens/profile2/utils/user_preferences.dart';
import 'package:my_gate_app/screens/profile2/widget/appbar_widget.dart';
import 'package:my_gate_app/screens/profile2/widget/button_widget.dart';
import 'package:my_gate_app/screens/profile2/widget/profile_widget.dart';
import 'package:my_gate_app/screens/profile2/edit_profile_page.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:my_gate_app/screens/profile2/widget/textfield_widget.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/profile2/model/user.dart';
import 'package:my_gate_app/screens/utils/custom_snack_bar.dart';


class VisitorProfilePage extends StatefulWidget {
  final ResultObj4 visitorObject;
  final bool isEditable;
  const VisitorProfilePage({Key? key, required this.visitorObject, required this.isEditable}): super(key: key);
  @override
  _VisitorProfilePageState createState() => _VisitorProfilePageState();
}

class _VisitorProfilePageState extends State<VisitorProfilePage> {
  late final TextEditingController controller_name;
  late final TextEditingController controller_mobile_no; //
  late final TextEditingController controller_car_number; //
  late final TextEditingController controller_purpose; // 
  late final TextEditingController controller_authority_message; /// give procedure to 
  late final TextEditingController controller_date_time_of_ticket_raised; // 
  // late final TextEditingController controller_date_time_authority; /// capture it 
  late final TextEditingController controller_duration_of_stay; //

  Future<void> init() async {
    databaseInterface db = new databaseInterface();
    controller_name.text = widget.visitorObject.visitor_name;
    controller_mobile_no.text = widget.visitorObject.mobile_no; 
    controller_car_number.text = widget.visitorObject.car_number; 
    controller_purpose.text = widget.visitorObject.purpose; 
    controller_authority_message.text = widget.visitorObject.authority_message;

    var _date_time = widget.visitorObject.date_time_of_ticket_raised;
     _date_time = _date_time.split("T")[1].split(".")[0] + " " + _date_time.split("T")[0];
    
    
    controller_date_time_of_ticket_raised.text = _date_time; 
    // controller_date_time_authority.text = widget.visitorObject.date_time_authority ;
    controller_duration_of_stay.text = widget.visitorObject.duration_of_stay; 

    setState(() {
    });

  }

  @override
  void initState(){
    super.initState();
    controller_name = TextEditingController();
    controller_mobile_no = TextEditingController(); 
    controller_car_number = TextEditingController(); 
    controller_purpose = TextEditingController(); 
    controller_authority_message = TextEditingController(); 
    controller_date_time_of_ticket_raised = TextEditingController();
    // controller_date_time_authority = TextEditingController(); 
    controller_duration_of_stay = TextEditingController(); 
    init();
  }

  void display_further_status(int statusCode) {
    Navigator.of(context).pop();
    if (statusCode == 200) {
      final snackBar =
          get_snack_bar("Action successful", Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = get_snack_bar("Action failed", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 24),
              builText(controller_name,"Full Name", false,1),
              const SizedBox(height: 24),
              builText(controller_mobile_no,"Mobile No", false,1),
              const SizedBox(height: 24),
              builText(controller_car_number,"Car Number", false,1),
              const SizedBox(height: 24),
              builText(controller_purpose,"Purpose", false,1),
              const SizedBox(height: 24),
              builText(controller_authority_message,"Authority Message", widget.isEditable,1),
              const SizedBox(height: 24),
              builText(controller_date_time_of_ticket_raised,"Ticket Generation Time", false,1),
              const SizedBox(height: 24),
              builText(controller_duration_of_stay,"Duration of Visit", false,1),
              const SizedBox(height: 24),
              if(widget.isEditable)
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[                    
                    ElevatedButton(
                      child: const Text("Approve Ticket"),
                      onPressed: () async {
                        widget.visitorObject.authority_message = controller_authority_message.text;
                        print("calling insert_in_visitors_ticket_table_2");
                        int statusCode = await databaseInterface.insert_in_visitors_ticket_table_2("Approved", widget.visitorObject);
                        print("status code: $statusCode");
                        display_further_status(statusCode); // Used to display the snackbar
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green),
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15, horizontal: 15)),
                        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 15, color: Colors.black)),
                        ),
                    ),
                    const SizedBox(width: 5),
                    ElevatedButton(
                      child: const Text("Reject Ticket"),
                      onPressed: () async {
                        widget.visitorObject.authority_message = controller_authority_message.text;
                        int statusCode = await databaseInterface.insert_in_visitors_ticket_table_2("Rejected", widget.visitorObject);
                        display_further_status(statusCode); // Used to display the snackbar
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15, horizontal: 15)),
                        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 15, color: Colors.black)),
                        ),
                      ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            ],
          ),
        );
  }

  Widget builText(TextEditingController controller, String label, final bool enabled,int maxLines) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            enabled: enabled,
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: maxLines,
          ),
        ],
      );

}