// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, deprecated_member_use, non_constant_identifier_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/utils/scrollable_widget.dart';

class StudentAuthoritiesTicketTable extends StatefulWidget {
  StudentAuthoritiesTicketTable(
      {Key? key, required this.location, required this.tickets})
      : super(key: key);
  final String location;
  List<ResultObj> tickets;

  @override
  _StudentAuthoritiesTicketTableState createState() =>
      _StudentAuthoritiesTicketTableState();
}

class _StudentAuthoritiesTicketTableState
    extends State<StudentAuthoritiesTicketTable> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
        body: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(1),
                child: Text(
                  "",
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Expanded(child: ScrollableWidget(child: buildDataTable())),
          ],
        ),
      );

  Widget buildDataTable() {
    final columns = [
      'S.No.',
      'Time\nGenerated',
      'Entry/\nExit',
      'Authority\nStatus'
    ];

    return DataTable(
      border: TableBorder.all(width: 2, color: Colors.black),
      headingRowColor: MaterialStateProperty.all(Colors.pink),
      columns: getColumns(columns),
      rows: getRows(widget.tickets),
      dataRowHeight: 100,
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(
              column,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ))
      .toList();

  List<DataRow> getRows(List<ResultObj> tickets) {
    List<DataRow> row_list = [];
    for (int index = 0; index < tickets.length; index++) {
      var ticket = tickets[index];
      row_list.add(DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          // All rows will have the same selected color.
          if (states.contains(MaterialState.selected)) {
            return Theme.of(context).colorScheme.primary.withOpacity(0.08);
          }
          // Even rows will have a grey color.
          if (index.isEven) {
            return Colors.grey.withOpacity(0.3);
          }
          return null; // Use default value for other states and odd rows.
        }),
        // final columns = ['S.No.', 'Time Generated', 'Entry/Exit','Guard Approval','Authority Status'];
        cells: [
          DataCell(Text((index + 1).toString(), style: TextStyle(color: Colors.black))),
          DataCell(Text("    " +
              ((ticket.date_time.split("T").last)
                      .split(".")[0]
                      .split(":")
                      .sublist(0, 2))
                  .join(":") +
              "\n" +
              ticket.date_time.split("T")[0], style: TextStyle(color: Colors.black))),
          DataCell(Text(ticket.ticket_type.toString(), style: TextStyle(color: Colors.black))),
          DataCell(Text(ticket.authority_status.toString(), style: TextStyle(color: Colors.black))),
        ],
      ));
    }
    return row_list;
  }
}
