// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_gate_app/auth/authscreen.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/admin/manage_guard/manage_guards_tabs.dart';
import 'package:my_gate_app/screens/admin/manage_admins/manage_admin_tabs.dart';
import 'package:my_gate_app/screens/admin/manage_locations/manage_location_tabs.dart';
import 'package:my_gate_app/screens/admin/statistics/statistics_tabs.dart';
import 'package:my_gate_app/screens/admin/utils/manage_using_excel/manage_excel_tabs.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/screens/profile2/admin_profile/admin_profile_page.dart';
import 'package:my_gate_app/screens/profile2/model/menu_item.dart';
import 'package:my_gate_app/screens/profile2/utils/menu_items.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  String welcome_message = "Welcome";

  Future<void> get_welcome_message() async {
    String welcome_message_local =
        await databaseInterface.get_welcome_message(LoggedInDetails.getEmail());
    // print("welcome_message_local: " + welcome_message_local);
    setState(() {
      welcome_message = welcome_message_local;
    });
  }

  @override
  void initState() {
    super.initState();
    get_welcome_message();
    // databaseInterface.getLoctions2().then((result){
    //   setState(() {
    //     entries=result;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigoAccent,
            title: Column(
              children: [
                Text('Admin Home'),
                Text(
                  '${welcome_message}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            // title: Text('Admin Home'),
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
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Container(
                // height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/admin.jpg',
                        height: 210,
                      ),
                    ),

                    SizedBox(height: 20,),
                    AdminButton(
                      context,
                      "View Statistics",
                      Colors.cyan,
                      StatisticsTabs(),
                    ),
                    //statistics
                    // AdminButton(context,"Manage Student", Colors.amber,ManageStudentsTabs()),
                    AdminButton(
                      context,
                      "Manage Student",
                      Colors.amber,
                      ManageExcelTabs(
                        appbar_title: "Manage Students",
                        add_url: "/files/add_students_from_file",
                        modify_url: "/files/add_students_from_file",
                        delete_url: "/files/delete_students_from_file",
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
                    AdminButton(
                      context,
                      "Manage Guards",
                      Colors.red,
                      ManageGuardsTabs(data_entity: "Guard", column_names: [
                        "Name",
                        "Location",
                        "Email",
                      ]),
                    ),
                    AdminButton(
                      context,
                      "Manage Admins",
                      Colors.cyan,
                      ManageAdminTabs(
                        data_entity: "Admins",
                        column_names: ["Name", "Email"],
                      ),
                    ),
                    //guard
                    AdminButton(
                      context,
                      "Manage Locations",
                      Colors.deepOrange,
                      ManageLocationTabs(
                        data_entity: "Locations",
                        column_names: [
                          "Location",
                          "Parent Location",
                          "Pre Approval",
                          "Automatic Exit",
                        ],
                      ),
                    ),
                    //locations
                    AdminButton(
                      context,
                      "Manage Hostels",
                      Colors.pink,
                      ManageExcelTabs(
                        appbar_title: "Manage Hostels",
                        add_url: "/files/add_hostels_from_file",
                        modify_url: "/files/add_hostels_from_file",
                        delete_url: "/files/delete_hostels_from_file",
                        entity: "Hostel",
                        data_entity: "Hostels",
                        column_names: [
                          "Hostel Name",
                        ],
                      ),
                    ),
                    AdminButton(
                      context,
                      "Manage Authorities",
                      Colors.teal,
                      ManageExcelTabs(
                        appbar_title: "Manage Authorities",
                        add_url: "/files/add_authorities_from_file",
                        modify_url: "/files/add_authorities_from_file",
                        delete_url: "/files/delete_authorities_from_file",
                        entity: "Authorities",
                        data_entity: "Authorities",
                        column_names: [
                          "Name",
                          "Designation",
                          "Email",
                        ],
                      ),
                    ),
                    AdminButton(
                      context,
                      "Manage Departments",
                      Colors.orange,
                      ManageExcelTabs(
                        appbar_title: "Manage Departments",
                        add_url: "/files/add_departments_from_file",
                        modify_url: "/files/add_departments_from_file",
                        delete_url: "/files/delete_departments_from_file",
                        entity: "Departments",
                        data_entity: "Departments",
                        column_names: [
                          "Department Name",
                        ],
                      ),
                    ),
                    AdminButton(
                      context,
                      "Manage Programs",
                      Colors.purple,
                      ManageExcelTabs(
                        appbar_title: "Manage Programs",
                        add_url: "/files/add_programs_from_file",
                        modify_url: "/files/add_programs_from_file",
                        delete_url: "/files/delete_programs_from_file",
                        entity: "Programs",
                        data_entity: "Programs",
                        column_names: [
                          "Degree Name",
                          "Degree Duration",
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
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
          // MaterialPageRoute(builder: (context) => ProfileController()),
          // MaterialPageRoute(builder: (context) => GuardProfilePage(email: LoggedInDetails.getEmail())),
          MaterialPageRoute(
              builder: (context) =>
                  AdminProfilePage(email: LoggedInDetails.getEmail())),
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

Widget AdminButton(BuildContext context, String ButtonText,
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
