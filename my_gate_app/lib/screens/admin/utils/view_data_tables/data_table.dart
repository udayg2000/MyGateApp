// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, deprecated_member_use, non_constant_identifier_names, dead_code, must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/profile2/admin_profile/admin_profile_page.dart';
import 'package:my_gate_app/screens/profile2/authority_profile/authority_profile_page.dart';
import 'package:my_gate_app/screens/profile2/guard_profile/guard_profile_page.dart';
import 'package:my_gate_app/screens/profile2/profile_page.dart';
import 'package:my_gate_app/screens/utils/scrollable_widget.dart';

// We pass to this class the value of "is_approved" which takes the value "Accepted"|"Rejected"

class AdminDataTable extends StatefulWidget {
  AdminDataTable(
      {Key? key,
      required this.data_entity,
      required this.column_names,
      required this.tickets})
      : super(key: key);
  final String data_entity;
  final List<String> column_names;
  List<ReadTableObject> tickets;

  @override
  _AdminDataTableState createState() => _AdminDataTableState();
}

class _AdminDataTableState extends State<AdminDataTable> {
  List<ResultObj> tickets = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<List<ReadTableObject>> get_tickets_for_guard() async {
    return await databaseInterface.get_data_for_admin(widget.data_entity);
  }

  Future init() async {
    final tickets = await get_tickets_for_guard();
    setState(() {
      widget.tickets = tickets;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(1),
                child: Text(
                  // "Ticket Table",
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
    // final columns = [
    //   'S.No.',
    //   'Student Name',
    //   'Time Generated',
    //   'Entry/Exit',
    //   'Authority Status'
    // ];
    return DataTable(
      border: TableBorder.all(width: 1),
      headingRowColor: MaterialStateProperty.all(Colors.red[200]),
      columns: getColumns(widget.column_names),
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

  List<DataCell> getDataCells(var ticket) {
    List<DataCell> cell_list = [];
    String table_name = widget.data_entity;
    if (table_name == 'Student') {
      cell_list.add(DataCell(TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(email: ticket.email.toString() , isEditable: false)),
          );
        },
        child: Text(ticket.name.toString()),
      )));
      cell_list.add(DataCell(Text(ticket.entry_no.toString())));
      cell_list.add(DataCell(Text(ticket.email.toString())));
      cell_list.add(DataCell(Text(ticket.gender.toString())));
      cell_list.add(DataCell(Text(ticket.department.toString())));
      cell_list.add(DataCell(Text(ticket.degree_name.toString())));
      cell_list.add(DataCell(Text(ticket.hostel.toString())));
      cell_list.add(DataCell(Text(ticket.room_no.toString())));
      cell_list.add(DataCell(Text(ticket.year_of_entry.toString())));
      cell_list.add(DataCell(Text(ticket.mobile_no.toString())));
    } else if (table_name == 'Guard') {
      cell_list.add(DataCell(TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    GuardProfilePage(email: ticket.email.toString())),
          );
        },
        child: Text(ticket.name.toString()),
      )));
      cell_list.add(DataCell(Text(ticket.location_name.toString())));
      cell_list.add(DataCell(Text(ticket.email.toString())));
    } else if (table_name == 'Admins') {
      cell_list.add(DataCell(TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    AdminProfilePage(email: ticket.email.toString())),
          );
        },
        child: Text(ticket.name.toString()),
      )));
      cell_list.add(DataCell(Text(ticket.email.toString())));
    } else if (table_name == 'Locations') {
      cell_list.add(DataCell(Text(ticket.location_name.toString())));
      cell_list.add(DataCell(Text(ticket.parent_location.toString())));
      cell_list.add(DataCell(Text(ticket.pre_approval_required.toString())));
      cell_list.add(DataCell(Text(ticket.automatic_exit_required.toString())));
    } else if (table_name == 'Hostels') {
      cell_list.add(DataCell(Text(ticket.hostel.toString())));
    } else if (table_name == 'Authorities') {
      cell_list.add(DataCell(TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    AuthorityProfilePage(email: ticket.email.toString())),
          );
        },
        child: Text(ticket.name.toString()),
      )));
      cell_list.add(DataCell(Text(ticket.designation.toString())));
      cell_list.add(DataCell(Text(ticket.email.toString())));
    } else if (table_name == 'Departments') {
      cell_list.add(DataCell(Text(ticket.department.toString())));
    } else if (table_name == 'Programs') {
      cell_list.add(DataCell(Text(ticket.degree_name.toString())));
      cell_list.add(DataCell(Text(ticket.degree_duration.toString())));
    }
    return cell_list;
  }

  List<DataRow> getRows(List<ReadTableObject> tickets) {
    List<DataRow> row_list = [];
    //
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
        // final columns = ['S.No.', 'Student Name', 'Time Generated', 'Entry/Exit', 'Authority Status'];
        cells: getDataCells(ticket),
        // cells: [
        //   DataCell(Text((index + 1).toString())),
        //   DataCell(Text(ticket.ticket_type.toString())),
        //   DataCell(Text(ticket.authority_status.toString())),
        // ],
      ));
    }
    return row_list;
  }
}
