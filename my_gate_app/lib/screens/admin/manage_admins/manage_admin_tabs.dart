// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/admin/manage_admins/add_admins.dart';
import 'package:my_gate_app/screens/admin/manage_admins/delete_admins.dart';
import 'package:my_gate_app/screens/admin/manage_admins/modify_admins.dart';
import 'package:my_gate_app/screens/admin/utils/view_data_tables/stream_data_table.dart';

class ManageAdminTabs extends StatefulWidget {
  const ManageAdminTabs({
    Key? key,
    required this.data_entity,
    required this.column_names,
  }) : super(key: key);
  final String data_entity;
  final List<String> column_names;

  @override
  State<ManageAdminTabs> createState() => _ManageAdminTabsState();
}

class _ManageAdminTabsState extends State<ManageAdminTabs>
    with SingleTickerProviderStateMixin {
  late TabController controller;

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
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Manage Admins"),
            centerTitle: true,
            bottom: TabBar(
              controller: controller,
              // ignore: prefer_const_literals_to_create_immutables
              tabs: [
                Tab(text: 'Add', icon: Icon(Icons.add)),
                // Tab(text: 'Modify', icon: Icon(Icons.mode_edit)),
                // Tab(text: 'Delete', icon: Icon(Icons.delete)),
                Tab(text: 'View', icon: Icon(Icons.remove_red_eye)),
              ],
            ),
          ),
          body: TabBarView(
            controller: controller,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              AddAdmins(),
              // Text("TODO: Modify Admins"),
              // Text("TODO: Delete Admins"),
              StreamAdminDataTable(
                data_entity: widget.data_entity,
                column_names: widget.column_names,
              )
              // ModifyAdmins(),
              // DeleteAdmins(),
            ],
          ),
        ),
      );
}
