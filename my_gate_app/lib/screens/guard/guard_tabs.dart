// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:my_gate_app/auth/authscreen.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/guard/guard_ticket_table.dart';
import 'package:my_gate_app/screens/guard/pending_guard_ticket_table.dart';
import 'package:my_gate_app/screens/guard/stream_guard_ticket_table.dart';
import 'package:my_gate_app/screens/guard/stream_selectable_page.dart';
import 'package:my_gate_app/screens/profile2/guard_profile/guard_profile_page.dart';
import 'package:my_gate_app/screens/profile2/model/menu_item.dart';
import 'package:my_gate_app/screens/profile2/utils/menu_items.dart';

class GuardTabs extends StatefulWidget {
  const GuardTabs({
    Key? key,
    required this.location,
    required this.enter_exit,
  }) : super(key: key);
  final String location;
  final String enter_exit;

  @override
  State<GuardTabs> createState() => _GuardTabsState();
}

class _GuardTabsState extends State<GuardTabs>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  List<ResultObj> tickets = [];

  // The initState and dispose state are required for adding the tabs
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget enterExitHeader(){
    if(widget.enter_exit == 'enter'){
       return Text(
          "Enter Tickets",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold),
      );
    }                 
    else{
      return Text(
        "Exit Tickets",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold),
      );
    }
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Column(
              children: [
                enterExitHeader(),
                Text(
                  widget.location,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            centerTitle: true,
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
            bottom: TabBar(
              controller: controller,
              // ignore: prefer_const_literals_to_create_immutables
              tabs: [
                Tab(
                  icon: Icon(Icons.pending_actions),
                  text: 'Pending\n Tickets',
                ),
                Tab(
                  icon: Icon(Icons.approval),
                  text: 'Approved\n Tickets',
                ),
                Tab(
                  icon: Icon(Icons.cancel),
                  text: 'Rejected\n Tickets',
                )
              ],
            ),
          ),
          body: TabBarView(
            controller: controller,
            children: [
              // StreamSelectablePage(location: widget.location,),
              SelectablePage(location: widget.location, enter_exit: widget.enter_exit),
              // Present in file pending_guard_ticket_table.dart
              // GuardTicketTable(location: widget.location, is_approved: "Approved",),
              // GuardTicketTable(location: widget.location, is_approved: "Rejected",),
              StreamGuardTicketTable(
                location: widget.location,
                is_approved: "Approved",
                enter_exit: widget.enter_exit,
                image_path: 'assets/images/approved.jpg',
              ),
              StreamGuardTicketTable(
                  location: widget.location,
                  is_approved: "Rejected",
                  enter_exit: widget.enter_exit,
                  image_path: 'assets/images/rejected.jpg'),
            ],
          ),
        ),
      );

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
                  GuardProfilePage(email: LoggedInDetails.getEmail())),
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
