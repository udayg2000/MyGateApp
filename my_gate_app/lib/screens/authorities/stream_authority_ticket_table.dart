// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/authorities/authority_ticket_table.dart';

// The code for this file is not updated according to the authority, it is using the guard version

class StreamAuthorityTicketTable extends StatefulWidget {
  const StreamAuthorityTicketTable({
    Key? key,
    required this.is_approved,
    required this.image_path,
  }) : super(key: key);
  final String is_approved;
  final String image_path;

  @override
  State<StreamAuthorityTicketTable> createState() =>
      _StreamAuthorityTicketTableState();
}

class _StreamAuthorityTicketTableState
    extends State<StreamAuthorityTicketTable> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseInterface.get_tickets_for_authorities_stream(
          LoggedInDetails.getEmail(), widget.is_approved),
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
              List<ResultObj2> tickets = [];
              if (snapshot.hasData) {
                tickets = snapshot.data as List<ResultObj2>;
              }
              return AuthorityTicketTable(
                is_approved: widget.is_approved,
                tickets: tickets,
                image_path: widget.image_path
              );
            }
        }
      },
    );
  }
}
