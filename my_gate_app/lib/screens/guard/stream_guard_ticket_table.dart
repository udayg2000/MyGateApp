// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/guard/guard_ticket_table.dart';

class StreamGuardTicketTable extends StatefulWidget {
  const StreamGuardTicketTable({
    Key? key,
    required this.location,
    required this.is_approved,
    required this.enter_exit,
    required this.image_path
  }) : super(key: key);
  final String location;
  final String is_approved;
  final String enter_exit;
  final String image_path;

  @override
  State<StreamGuardTicketTable> createState() => _StreamGuardTicketTableState();
}

class _StreamGuardTicketTableState extends State<StreamGuardTicketTable> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseInterface.get_tickets_for_guard_stream(
          widget.location, widget.is_approved, widget.enter_exit),
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
              return GuardTicketTable(
                location: widget.location,
                is_approved: widget.is_approved,
                tickets: tickets,
                image_path: widget.image_path,
              );
            }
        }
      },
    );
  }
}
