// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_gate_app/auth/authscreen.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/admin/utils/manage_using_excel/manage_excel_tabs.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/screens/guard/visitors/visitor_form.dart';
import 'package:my_gate_app/screens/profile2/admin_profile/admin_profile_page.dart';
import 'package:my_gate_app/screens/profile2/model/menu_item.dart';
import 'package:my_gate_app/screens/profile2/utils/menu_items.dart';

class ManageVisitors extends StatefulWidget {
  const ManageVisitors({Key? key}) : super(key: key);

  @override
  _ManageVisitorsState createState() => _ManageVisitorsState();
}

class _ManageVisitorsState extends State<ManageVisitors> {
  String welcome_message = "Welcome";

  Future<void> get_welcome_message() async {
    String welcome_message_local =
        await databaseInterface.get_welcome_message(LoggedInDetails.getEmail());
    setState(() {
      welcome_message = welcome_message_local;
    });
  }

  @override
  void initState() {
    super.initState();
    get_welcome_message();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          title: Column(
            children: [
              Text('Manage Visitors'),
              Text(
                '${welcome_message}',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
          actions: [
            PopupMenuButton<MenuItem>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                ...MenuItems.itemsFirst.map(buildItem).toList(),
                PopupMenuDivider(),
                ...MenuItems.itemsSecond.map(buildItem).toList(),
              ],
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/admin.jpg',
                  height: 210,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ManageVisitorsButtons(
                context,
                "Visitor Form",
                Colors.cyan,
                VisitorForm(location: "a",),
              ),
              ManageVisitorsButtons(
                context,
                "View Tickets",
                Colors.amber,
                ManageExcelTabs(
                  appbar_title: "Manage Students",
                  add_url: "files/add_students_from_file",
                  modify_url: "files/add_students_from_file",
                  delete_url: "files/delete_students_from_file",
                  entity: "Student",
                  data_entity: "Student",
                  column_names: [
                    "Name",
                    "Entry No.",
                    "Email",
                    "Gender",
                    "Dept.",
                    "Degree",
                    "Hostel",
                    "Room",
                    "Year",
                    "Mobile",
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon, size: 20),
            const SizedBox(width: 12),
            Text(item.text),
          ],
        ),
      );

  void onSelected(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.itemProfile:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AdminProfilePage(
              email: LoggedInDetails.getEmail(),
            ),
          ),
        );
        break;
      case MenuItems.itemLogOut:
        LoggedInDetails.setEmail("");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
        break;
    }
  }
}

Widget ManageVisitorsButtons(BuildContext context, String ButtonText,
    MaterialColor ButtonColor, Widget NextPage) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NextPage));
    },
    child: Container(
      // height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width / 1.2,
      alignment: Alignment.center,
      //margin: EdgeInsets.only(bottom: 20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: ButtonColor,
        borderRadius: BorderRadius.circular(20),
      ),
      //color: Colors.amber[colorCodes[index]],
      child: Center(
          child: Text(
        ButtonText,
        style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
      )),
    ),
  );
}
