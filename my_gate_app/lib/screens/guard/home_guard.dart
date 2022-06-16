// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_gate_app/auth/authscreen.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/guard/guard_tabs.dart';
import 'package:my_gate_app/screens/profile2/guard_profile/guard_profile_page.dart';
import 'package:my_gate_app/screens/profile2/model/menu_item.dart';
import 'package:my_gate_app/screens/profile2/utils/menu_items.dart';

// This file calls the GuardTicketTable file with location name as a parameter

class HomeGuard extends StatefulWidget {
  const HomeGuard({Key? key}) : super(key: key);

  @override
  _HomeGuardState createState() => _HomeGuardState();
}

class _HomeGuardState extends State<HomeGuard> {
  // List<String> entries = [];
  List<String> entries = databaseInterface.getLoctions();
  String welcome_message = "Welcome";

  Future<void> get_welcome_message() async {
    String welcome_message_local = await databaseInterface.get_welcome_message(LoggedInDetails.getEmail());
    // print("welcome_message_local: " + welcome_message_local);
    setState(() {
      welcome_message = welcome_message_local;
    });
  }


  //final List<int> colorCodes = <int>[600, 500, 100,600, 500, 100,600, 500, 100,600, 500, 100,600, 500, 100,600, 500, 100,600, 500, 100,];
  @override
  void initState(){
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
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('Guard Home'),
            Text('${welcome_message}', style: TextStyle(fontSize: 15),),

          ],
        ),
        // title: Text('Guard Home'),
        actions: [IconButton(onPressed: () {
            LoggedInDetails.setEmail("");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AuthScreen()),
            );
        }, icon: Icon(Icons.logout))],
      ),
      body: Container(
        color: Colors.black38,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
            MediaQuery
                .of(context)
                .orientation == Orientation.landscape
                ? 3
                : 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: (2 / 1),
          ),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => GuardTabs(
                  location: entries[index],
                      enter_exit: "None",

                ),
                    ));
              },
              child: Container(
                height: 50,
                width: 30,
                //margin: EdgeInsets.only(bottom: 20),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.blue[100 * (index % 3 + 1)],
                  borderRadius: BorderRadius.circular(20),
                ),
                //color: Colors.amber[colorCodes[index]],
                child: Center(
                    child: Text(
                      '${entries[index]}',
                      style: GoogleFonts.roboto(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              ),
            );
          },
          // separatorBuilder: (BuildContext context, int index) =>
          //     const Divider(),
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
          // MaterialPageRoute(builder: (context) => ProfileController()),
          // MaterialPageRoute(builder: (context) => GuardProfilePage(email: LoggedInDetails.getEmail())),
          MaterialPageRoute(builder: (context) => GuardProfilePage(email: LoggedInDetails.getEmail())),
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
