// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/admin/utils/view_data_tables/stream_data_table.dart';
import 'add_locations.dart';
import 'delete_locations.dart';
import 'modify_locations.dart';

class ManageLocationTabs extends StatefulWidget {
  const ManageLocationTabs({
    Key? key,
    required this.data_entity,
    required this.column_names,
  }) : super(key: key);
  final String data_entity;
  final List<String> column_names;

  @override
  State<ManageLocationTabs> createState() => _ManageLocationTabsState();
}

class _ManageLocationTabsState extends State<ManageLocationTabs>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  List<ResultObj> tickets = [];

  // The initState and dispose state are required for adding the tabs
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
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
            title: Text("Manage Locations"),
            centerTitle: true,
            bottom: TabBar(
              controller: controller,
              tabs: [
                Tab(text: 'Add', icon: Icon(Icons.add)),
                Tab(text: 'Modify', icon: Icon(Icons.mode_edit)),
                Tab(text: 'Delete', icon: Icon(Icons.delete)),
                Tab(text: 'View', icon: Icon(Icons.remove_red_eye)),
              ],
            ),
          ),
          body: TabBarView(
            controller: controller,
            children: [
              AddLocations(),
              ModifyLocations(),
              DeleteLocations(),
              StreamAdminDataTable(
                data_entity: widget.data_entity,
                column_names: widget.column_names,
              )
            ],
          ),
        ),
      );
}
