// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/student/student_guard_side/student_ticket_table.dart';

class StreamStudentTicketTable extends StatefulWidget {
  const StreamStudentTicketTable({ Key? key, required this.location, required this.pre_approval_required,}) : super(key: key);
  final String location;
  final bool pre_approval_required;  

  @override
  State<StreamStudentTicketTable> createState() => _StreamStudentTicketTableState();
}

class _StreamStudentTicketTableState extends State<StreamStudentTicketTable> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseInterface.get_tickets_for_student(LoggedInDetails.getEmail().toString(), widget.location),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return const Text("Error", style: TextStyle(fontSize:24, color:Colors.red));
            } else {
              // String in_or_out = snapshot.data.toString();
              List<ResultObj> tickets = [];
              if(snapshot.hasData) {
                tickets = snapshot.data as List<ResultObj>;
              }
              return StudentTicketTable(location: widget.location, tickets: tickets, pre_approval_required:widget.pre_approval_required);
            }
        }
      },
    );
  }
}