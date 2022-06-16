// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/admin/manage_student/upload_invalid_email.dart';
import 'package:my_gate_app/screens/admin/manage_student/upload_valid_email.dart';

class ManageStudentsTabs extends StatefulWidget {
  const ManageStudentsTabs({Key? key}): super(key: key);

  @override
  State<ManageStudentsTabs> createState() => _ManageStudentsTabsState();
}

class _ManageStudentsTabsState extends State<ManageStudentsTabs>
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
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        title: Text("Manage Students"),
        centerTitle: true,
        bottom: TabBar(
          controller: controller,
          tabs: [
            Tab(text: 'Add', icon: Icon(Icons.add)),
            Tab(text: 'Delete', icon: Icon(Icons.delete)),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          UploadValidEmail(),
          UploadInvalidEmail(),
        ],
      ),
    ),
  );
}
