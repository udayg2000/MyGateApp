import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/student/student_authorities_side/student_authorities_ticket_table.dart';

class StreamStudentAuthoritiesTicketTable extends StatefulWidget {
  const StreamStudentAuthoritiesTicketTable({Key? key, required this.location})
      : super(key: key);
  final String location;

  @override
  State<StreamStudentAuthoritiesTicketTable> createState() =>
      _StreamStudentAuthoritiesTicketTableState();
}

class _StreamStudentAuthoritiesTicketTableState
    extends State<StreamStudentAuthoritiesTicketTable> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseInterface.get_authority_tickets_for_student(
          LoggedInDetails.getEmail().toString(), widget.location),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return const Text("Error",
                  style: TextStyle(fontSize: 24, color: Colors.red));
            } else {
              // String in_or_out = snapshot.data.toString();
              List<ResultObj> tickets = [];
              if (snapshot.hasData) {
                tickets = snapshot.data as List<ResultObj>;
              }
              return StudentAuthoritiesTicketTable(
                  location: widget.location, tickets: tickets);
            }
        }
      },
    );
  }
}
