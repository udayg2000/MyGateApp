import 'package:flutter/material.dart';
import 'package:my_gate_app/screens/student/student_authorities_side/generate_preapproval_ticket.dart';
import 'package:my_gate_app/screens/student/student_authorities_side/stream_student_authorities_ticket_table.dart';
import 'package:my_gate_app/screens/student/student_authorities_side/stream_student_authority_status.dart';

// This file calls EnterLocation in the first tab and GeneralStudentTicketPage in the second tab

class StudentAuthoritiesTabs extends StatefulWidget {
  const StudentAuthoritiesTabs({Key? key, required this.location})
      : super(key: key);
  final String location;

  @override
  State<StudentAuthoritiesTabs> createState() => _StudentAuthoritiesTabsState();
}

class _StudentAuthoritiesTabsState extends State<StudentAuthoritiesTabs>
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
          controller: controller,
          tabs: [
            Tab(text: 'Generate\nTicket', icon: Icon(Icons.add)),
            Tab(text: 'Past\nTickets', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          GeneratePreApprovalTicket(location: widget.location),
          // StreamStudentAuthorityStatus(location: widget.location),
          StreamStudentAuthoritiesTicketTable(location: widget.location),
        ],
      ),
    ),
  );
}
