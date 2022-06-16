// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, deprecated_member_use, non_constant_identifier_names, dead_code
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/guard/utils/filter_page.dart';
import 'package:my_gate_app/screens/guard/utils/search_dropdown.dart';
import 'package:my_gate_app/screens/profile2/profile_page.dart';
import 'package:my_gate_app/screens/utils/scrollable_widget.dart';
import 'package:my_gate_app/get_email.dart';

// We pass to this class the value of "is_approved" which takes the value "Accepted"|"Rejected"

class AuthorityTicketTable extends StatefulWidget {
  AuthorityTicketTable({
    Key? key,
    required this.is_approved,
    required this.tickets,
    required this.image_path,
  }) : super(key: key);
  final String is_approved;
  List<ResultObj2> tickets;
  final String image_path;

  @override
  _AuthorityTicketTableState createState() => _AuthorityTicketTableState();
}

class _AuthorityTicketTableState extends State<AuthorityTicketTable> {
  List<ResultObj2> tickets = [];
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

  Future<List<ResultObj2>> get_tickets_for_authority() async {
    String authority_email = LoggedInDetails.getEmail();
    return await databaseInterface.get_tickets_for_authorities(
        authority_email, widget.is_approved);
  }

  Future init() async {
    final tickets = await get_tickets_for_authority();
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
        backgroundColor: Colors.lightGreenAccent,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                widget.image_path,
                height: 150,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: Colors.black,
                    size: 24.0,
                  ),
                  // style: ElevatedButton.styleFrom(
                  //     textStyle: const TextStyle(fontSize: 20),
                  //     primary: Colors.indigoAccent),
                  onPressed: () {
                    final DateFormat formatter = DateFormat('yyyy-MM-dd');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilterPage(
                          chosen_start_date: formatter.format(DateTime.now()),
                          chosen_end_date: formatter.format(DateTime.now()),
                          isSelected: [true, true],
                          onSavedFunction:
                              (String? x, String? y, List<bool> z, bool date_filter_applied, bool ticket_type_filter_applied) {
                            this.chosen_start_date = x!;
                            this.chosen_end_date = y!;
                            this.isSelected = z;
                          },
                        ),
                      ),
                    );
                  },
                  // label: Text(
                  //   '',
                  //   style: GoogleFonts.roboto(),
                  // ),
                ),
                SizedBox(
                  height: 3,
                ),
                dropdown(
                  context,
                  this.search_entry_numbers,
                  (String? s) {
                    if (s != null) {
                      this.chosen_entry_number = s;
                      print(this.chosen_entry_number);
                    }
                  },
                  "Entry Number",
                  Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  border_radius: 100,
                  container_color: Colors.lightGreenAccent,
                  text_color: Colors.black,
                ),
                SizedBox(
                  width: 3,
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 24.0,
                  ),
                  onPressed: () {
                    print(this.chosen_entry_number);
                    print(this.chosen_start_date);
                    print(this.chosen_end_date);
                    print(this.isSelected);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(child: ScrollableWidget(child: buildDataTable())),
          ],
        ),
      );

  Widget buildDataTable() {
    // Fields returned from backend [is_approved, ticket_type, date_time, location, email, student_name, authority_message]

    final columns = [
      'S.No.',
      'Name',
      'Location',
      'Time',
      'Entry/Exit',
      'Authority Message'
    ];

    return DataTable(
      border: TableBorder.all(width: 1, color: Colors.white),
      headingRowColor: MaterialStateProperty.all(Colors.orangeAccent),
      columns: getColumns(columns),
      rows: getRows(widget.tickets),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Column(
            children: [
              const Text('My Text'),
              Container(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.red[200]),
                    columns: getColumns(columns),
                    rows: getRows(widget.tickets),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.red[200]),
      columns: getColumns(columns),
      rows: getRows(widget.tickets),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            // label:  Flexible(
            //   child:Text(column,style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
            // )

            // label: ConstrainedBox(
            //   constraints: BoxConstraints(
            //     maxWidth: 20,
            //     minWidth: 20,
            //   ),
            //   child: Flexible(
            //       child:Text(column,style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),)),
            // ),
            label: Text(
              column,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ))
      .toList();

  List<DataRow> getRows(List<ResultObj2> tickets) {
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

        // final columns = ['S.No.', 'Student Name', 'Location', 'Time Generated', 'Entry/Exit', 'Authority Message'];
        cells: [
          DataCell(Text((index + 1).toString())),
          DataCell(
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(email: ticket.email, isEditable: false)),
                );
              },
              child: Text(
                ticket.student_name.toString(),
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
            ),
          ),
          // DataCell(Text(ticket.student_name.toString())),
          DataCell(Text(ticket.location.toString())),
          DataCell(Text("    " +
              ((ticket.date_time.split("T").last)
                      .split(".")[0]
                      .split(":")
                      .sublist(0, 2))
                  .join(":") +
              "\n" +
              ticket.date_time.split("T")[0])),
          DataCell(Text(ticket.ticket_type.toString())),
          DataCell(Text(ticket.authority_message.toString())),
        ],
      ));
    }
    return row_list;
  }
}
