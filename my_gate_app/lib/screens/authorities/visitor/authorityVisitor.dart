// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_gate_app/auth/authscreen.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/authorities/visitor/past_authority_visitor_ticket_table.dart';
import 'package:my_gate_app/screens/authorities/visitor/pending_authority_visitor_ticket_table.dart';
// import 'package:my_gate_app/screens/authorities/pending_authority_ticket_table.dart';
// import 'package:my_gate_app/screens/authorities/stream_authority_ticket_table.dart';
// import 'package:my_gate_app/screens/profile2/authority_profile/authority_edit_profile_page.dart';
// import 'package:my_gate_app/screens/profile2/authority_profile/authority_profile_page.dart';
// import 'package:my_gate_app/screens/profile2/model/menu_item.dart';
// import 'package:my_gate_app/screens/profile2/utils/menu_items.dart';

class AuthorityVisitor extends StatefulWidget {
  const AuthorityVisitor({Key? key}) : super(key: key);

  @override
  State<AuthorityVisitor> createState() => _AuthorityVisitorState();
}

class _AuthorityVisitorState extends State<AuthorityVisitor>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  List<ResultObj> tickets = [];

  // The initState and dispose state are required for adding the tabs
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length:2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Visitor Tickets"),
            // actions: [
            //   PopupMenuButton<MenuItem>(
            //     onSelected: (item) => onSelected(context, item),
            //     itemBuilder: (context) => [
            //       ...MenuItems.itemsFirst.map(buildItem).toList(),
            //       PopupMenuDivider(),
            //       ...MenuItems.itemsSecond.map(buildItem).toList(),
            //     ],
            //   ),
            // ],
            centerTitle: true,
            bottom: TabBar(
              controller: controller,
              // ignore: prefer_const_literals_to_create_immutables
              tabs: [
                Tab(
                    // child: Text('Pending\nTickets', style: TextStyle(color: Colors.green),),
                    text: 'Pending\n Tickets',
                    icon: Icon(Icons.pending_actions)),
                Tab(
                  text: 'Past\n Tickets',
                  icon: Icon(Icons.approval),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: controller,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              PendingAuthorityVisitorTicketTable(),
              PastAuthorityVisitorTicketTable(),
              // PendingAuthorityTicketTable(),
              // StreamAuthorityTicketTable(
              //   is_approved: "Approved",
              //   image_path: 'assets/images/approved.jpg',
              // ),
              // StreamAuthorityTicketTable(
              //   is_approved: "Rejected",
              //   image_path: 'assets/images/rejected.jpg',
              // ),
            ],
          ),
        ),
      );

}
