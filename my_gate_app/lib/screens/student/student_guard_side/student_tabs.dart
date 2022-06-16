// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_gate_app/screens/student/student_guard_side/stream_student_status.dart';
import 'package:my_gate_app/screens/student/student_guard_side/stream_student_ticket_table.dart';

// This file calls EnterLocation in the first tab and GeneralStudentTicketPage in the second tab

class StudentTabs extends StatefulWidget {
  const StudentTabs({
    Key? key,
    required this.location,
    required this.pre_approval_required,
  }) : super(key: key);
  final String location;
  final bool pre_approval_required;

  @override
  State<StudentTabs> createState() => _StudentTabsState();
}

class _StudentTabsState extends State<StudentTabs>
    with SingleTickerProviderStateMixin {
  late TabController controller;

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
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.location),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.red,
              controller: controller,
              tabs: [
                Tab(text: 'Status', icon: Icon(Icons.account_circle)),
                Tab(text: 'History', icon: Icon(Icons.history)),
              ],
            ),
          ),
          body: TabBarView(
            controller: controller,
            children: [
              StreamStudentStatus(
                location: widget.location,
                pre_approval_required: widget.pre_approval_required,
              ),
              // EnterLocation(location: widget.location),
              StreamStudentTicketTable(
                location: widget.location,
                pre_approval_required: widget.pre_approval_required,
              ),
              // GeneralStudentTicketPage(location: widget.location)
              // AllStudentTickets(location: widget.location),
            ],
          ),
        ),
      );
}
