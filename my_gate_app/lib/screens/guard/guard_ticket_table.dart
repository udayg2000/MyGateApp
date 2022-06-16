// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, deprecated_member_use, non_constant_identifier_names, dead_code
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/guard/utils/authority_message.dart';
import 'package:my_gate_app/screens/guard/utils/filter_page.dart';
import 'package:my_gate_app/screens/guard/utils/search_dropdown.dart';
import 'package:my_gate_app/screens/profile2/profile_page.dart';
import 'package:my_gate_app/screens/utils/scrollable_widget.dart';
import 'guard_ticket_popup.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

// We pass to this class the value of "is_approved" which takes the value "Accepted"|"Rejected"

class GuardTicketTable extends StatefulWidget {
  GuardTicketTable({
    Key? key,
    required this.location,
    required this.is_approved,
    required this.tickets,
    required this.image_path,
  }) : super(key: key);
  final String location;
  final String is_approved;
  final String image_path;
  List<ResultObj> tickets;

  @override
  _GuardTicketTableState createState() => _GuardTicketTableState();
}

enum SingingCharacter { Students, Visitors }
class _GuardTicketTableState extends State<GuardTicketTable> {
  SingingCharacter? _character = SingingCharacter.Students;
  List<ResultObj> tickets = [];
  List<String> search_entry_numbers = [];
  String chosen_entry_number = "None";
  String chosen_start_date = "None";
  String chosen_end_date = "None";
  List<bool> isSelected = [true, true];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<List<ResultObj>> get_tickets_for_guard() async {
    // Depending upon the location and ticket status, fetch the tickets
    // For example fetch all tickets of Main Gate where ticket status is accepted
    return await databaseInterface.get_tickets_for_guard(
        widget.location, widget.is_approved);
  }

  Future init() async {
    final tickets = await get_tickets_for_guard();
    setState(() {
      widget.tickets = tickets;
      // int len = tickets.length;
      // if(len == 0){
      //   TicketResultObj obj = new TicketResultObj.constructor1();
      //   obj.empty_table_entry(obj);
      //   this.tickets = [];
      //   // this.tickets.add(obj);
      // }else{
      //   this.tickets = tickets;
      // }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.indigo,
        body: ScrollableWidget(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

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
              Row(

                children: <Widget>[
                  Container(
                    width:150,
                    child: RadioListTile<SingingCharacter>(
                      title: const Text('Students'),
                      value: SingingCharacter.Students,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 150,
                    child: RadioListTile<SingingCharacter>(
                      title: const Text('Visitors'),
                      value: SingingCharacter.Visitors,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: () {
                      final DateFormat formatter = DateFormat('yyyy-MM-dd');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilterPage(
                            chosen_start_date: formatter.format(DateTime.now()),
                            chosen_end_date: formatter.format(DateTime.now()),
                            isSelected: [true, true],
                            onSavedFunction: (String? x,
                                String? y,
                                List<bool> z,
                                bool date_filter_applied,
                                bool ticket_type_filter_applied) {
                              this.chosen_start_date = x!;
                              this.chosen_end_date = y!;
                              this.isSelected = z;
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  dropdown(context, this.search_entry_numbers, (String? s) {
                    if (s != null) {
                      this.chosen_entry_number = s;
                      print(this.chosen_entry_number);
                    }
                  },
                      "Entry Number",
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      border_radius: 100,
                      container_color: Colors.indigo),
                  SizedBox(
                    width: 3,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: () {
                      print(this.chosen_entry_number);
                      print(this.chosen_start_date);
                      print(this.chosen_end_date);
                      print(this.isSelected);
                    },
                  ),
                  SizedBox(width: 340,)
                ],
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  SizedBox(width: 10,),
                  ScrollableWidget(child: buildDataTable()),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildDataTable() {
    final columns = [
      'Name',
      'Time',
    ];
    return DataTable(
      border: TableBorder.all(width: 1, color: Colors.white),
      headingRowColor: MaterialStateProperty.all(Colors.orangeAccent),
      columns: getColumns(columns),
      rows: getRows(widget.tickets),
      dataRowHeight: 100,
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(
              column,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
        // final columns = ['S.No.', 'Student Name', 'Time Generated', 'Entry/Exit', 'Authority Status'];
        cells: [
          DataCell(
            Row(
              children: [
                if (ticket.authority_status.toString() != 'NA')
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          AuthorityMessage(ticket.authority_status.toString(), context);
                        },
                        icon: Icon(
                          Icons.message_outlined,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                      if (ticket.authority_status.contains("Approved"))
                        Icon(
                          Icons.check,
                          color: Colors.lightBlueAccent,
                          size: 24.0,
                        ),
                      if (ticket.authority_status.contains("Rejected"))
                        Icon(
                          Icons.cancel,
                          color: Colors.lightBlueAccent,
                          size: 24.0,
                        ),
                      if (ticket.authority_status.contains("Pending"))
                        Icon(
                          Icons.timer,
                          color: Colors.lightBlueAccent,
                          size: 24.0,
                        ),
                    ],
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          email: ticket.email.toString(),
                          isEditable: false,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    ticket.student_name.toString(),
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                ),
              ],
            ),
          ),
          // DataCell(
          //   TextButton(
          //     onPressed: () {
          //       Navigator.of(context).push(
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 ProfilePage(email: ticket.email, isEditable: false)),
          //       );
          //     },
          //     child: Text(
          //       ticket.student_name.toString(),
          //       style: TextStyle(color: Colors.lightBlueAccent),
          //     ),
          //   ),
          // ),
          // Text(ticket.student_name.toString())),
          DataCell(Text("    " +
              ((ticket.date_time.split("T").last)
                      .split(".")[0]
                      .split(":")
                      .sublist(0, 2))
                  .join(":") +
              "\n" +
              ticket.date_time.split("T")[0])),
          // DataCell(Text(ticket.ticket_type.toString())),
          // DataCell(Text(ticket.authority_status.toString())),
        ],
      ));
    }
    return row_list;
  }
}
