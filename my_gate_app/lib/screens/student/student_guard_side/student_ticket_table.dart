// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, deprecated_member_use, non_constant_identifier_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/student/student_ticket_popup.dart';
import 'package:my_gate_app/screens/utils/scrollable_widget.dart';


class StudentTicketTable extends StatefulWidget {
  StudentTicketTable({ Key? key, required this.location, required this.tickets, required this.pre_approval_required,}) : super(key: key);
  final String location;
  List<ResultObj> tickets;
  final bool pre_approval_required;

  @override
  _StudentTicketTableState createState() => _StudentTicketTableState();
}

class _StudentTicketTableState extends State<StudentTicketTable> {

  // List<TicketResultObj> tickets = [];

  @override
  void initState() {
    super.initState();
    // init();
  }

  // Future<List<TicketResultObj>> getData(String email) async {
  //   databaseInterface db = new databaseInterface();
  //   return await db.get_tickets_for_student(email);
  // }

  // Future init() async {
  //   final tickets = await getData('test@gmail.com');
  //   setState(() {
  //     int len = tickets.length;
  //     if(len == 0){
  //       TicketResultObj obj = new TicketResultObj.constructor1();
  //       obj.empty_table_entry(obj);
  //       this.tickets = [];
  //       this.tickets.add(obj);
  //     }else{
  //       this.tickets = tickets;
  //     }
  //   } );
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white, // added now
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
    List<String> columns_ = [];
    if(widget.pre_approval_required){
      columns_ = ['S.No.', 'Time', 'Entry/Exit','Guard Approval','Authority Status'];
    }else{
      columns_ = ['S.No.', 'Time', 'Entry/Exit','Guard Approval'];

    }
    List<String> columns = columns_;
    return DataTable(
      // border: TableBorder.all(width: 2, color: Colors.white),
      border: TableBorder.all(width: 2, color: Colors.black),
      // border: TableBorder.all(width: 2, color: Colors.black),
      headingRowColor: MaterialStateProperty.all(Colors.pink),
      columns: getColumns(columns, ),
      rows: getRows(widget.tickets),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
    // label: Text(column,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
    label: Text(column,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),

  ))
      .toList();

  List<DataRow> getRows(List<ResultObj> tickets){
    List<DataRow> row_list = [];
    for (int index = 0; index < tickets.length; index++){
      var ticket = tickets[index];
      if(widget.pre_approval_required){
        row_list.add(DataRow(
          color: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                // All rows will have the same selected color.
                if (states.contains(MaterialState.selected)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                  // return Colors.black.withOpacity(0.8);
                }
                // Even rows will have a grey color.
                if (index.isEven) {
                  return Colors.grey.withOpacity(0.3);
                  // return Colors.black.withOpacity(0.4);
                }
                return null; // Use default value for other states and odd rows.
                // return Colors.black.withOpacity(0.8);
              }),
          // final columns = ['S.No.', 'Time Generated', 'Entry/Exit','Guard Approval','Authority Status'];
          cells: [
            DataCell(Text((index+1).toString(), style: TextStyle(color: Colors.black))),
            DataCell(Text("    "+((ticket.date_time.split("T").last).split(".")[0].split(":").sublist(0,2)).join(":")+"\n"+ticket.date_time.split("T")[0], style: TextStyle(color: Colors.black))),
            DataCell(Text(ticket.ticket_type.toString(), style: TextStyle(color: Colors.black))),
            DataCell(Text(ticket.is_approved.toString(), style: TextStyle(color: Colors.black))),
            DataCell(Text(ticket.authority_status.toString(), style: TextStyle(color: Colors.black))),
          ],
        ));
      }else{
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
            DataCell(Text((index+1).toString(), style: TextStyle(color: Colors.black))),
            DataCell(Text("    "+((ticket.date_time.split("T").last).split(".")[0].split(":").sublist(0,2)).join(":")+"\n"+ticket.date_time.split("T")[0], style: TextStyle(color: Colors.black))),
            DataCell(Text(ticket.ticket_type.toString(), style: TextStyle(color: Colors.black))),
            DataCell(Text(ticket.is_approved.toString(), style: TextStyle(color: Colors.black))),
          ],
        ));
      }
    }
    return row_list;
  }

}

