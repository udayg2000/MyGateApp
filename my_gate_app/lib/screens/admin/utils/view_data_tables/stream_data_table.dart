// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/admin/utils/view_data_tables/data_table.dart';

class StreamAdminDataTable extends StatefulWidget {
  const StreamAdminDataTable({
    Key? key,
    required this.data_entity,
    required this.column_names,
  }) : super(key: key);
  final String data_entity;
  final List<String> column_names;

  @override
  State<StreamAdminDataTable> createState() => _StreamAdminDataTableState();
}

class _StreamAdminDataTableState extends State<StreamAdminDataTable> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseInterface
          .get_data_for_admin_tables_stream(widget.data_entity),
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
              List<ReadTableObject> table_rows = [];
              if (snapshot.hasData) {
                table_rows = snapshot.data as List<ReadTableObject>;
              }
              return AdminDataTable(
                data_entity: widget.data_entity,
                column_names: widget.column_names,
                tickets: table_rows,
              );
            }
        }
      },
    );
  }
}
