// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, deprecated_member_use, non_constant_identifier_names, avoid_print, must_be_immutable, prefer_collection_literals, prefer_typing_uninitialized_variables
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/guard/utils/authority_message.dart';
import 'package:my_gate_app/screens/guard/utils/filter_page.dart';
import 'package:my_gate_app/screens/guard/utils/search_dropdown.dart';
import 'package:my_gate_app/screens/guard/visitors/visitor_form.dart';
import 'package:my_gate_app/screens/utils/custom_snack_bar.dart';
import 'package:my_gate_app/screens/profile2/profile_page.dart';
import 'package:my_gate_app/screens/utils/scrollable_widget.dart';
import 'guard_ticket_popup.dart';

// Rename this class to PendingGuardTicketTable and change in all files where it being called

class SelectablePage extends StatefulWidget {
  const SelectablePage({Key? key, required this.location, required this.enter_exit}) : super(key: key);
  final String location;
  final String enter_exit;

  @override
  _SelectablePageState createState() => _SelectablePageState();
}

enum SingingCharacter { Students, Visitors }
class _SelectablePageState extends State<SelectablePage> {
  SingingCharacter? _character = SingingCharacter.Students;
  String ticket_accepted_message = '';
  String ticket_rejected_message = '';
  String Person = "Students";

  List<ResultObj> tickets = [];
  List<ResultObj4> tickets_visitors = [];
  List<ResultObj> selectedTickets = [];
  List<ResultObj4> selectedTickets_visitors = [];

  List<ResultObj> selectedTickets_action = [];
  List<ResultObj4> selectedTickets_visitors_action = [];

  var entryNumToEmailMap = new Map();
  var emailToEntryNumMap = new Map();

  List<String> list_of_persons = [];
  String chosen_entry_number = "None";
  String chosen_mobile_number = "None";
  String chosen_name = "None";

  String chosen_start_date = "None";
  String chosen_end_date = "None";
  bool date_filter_applied = false;
  bool ticket_type_filter_applied = false;

  List<bool> isSelected = [true, true];

  Future<void> accept_selected_tickets() async {
    databaseInterface db = new databaseInterface();
    int status_code = 0;
    if(Person == 'Students'){
      status_code = await db.accept_selected_tickets(selectedTickets);
    }else if(Person == 'Visitors'){
      status_code = await db.accept_selected_tickets_visitors(selectedTickets_visitors);
    }
    if (status_code == 200) {
      await init();
      final snackBar = get_snack_bar("Selected tickets accepted", Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = get_snack_bar("Failed to accept the tickets", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> reject_selected_tickets() async {
    databaseInterface db = new databaseInterface();
    int status_code = 0;
    if(Person == 'Students'){
      status_code = await db.reject_selected_tickets(selectedTickets);
    }else if(Person == 'Visitors'){
      status_code = await db.reject_selected_tickets_visitors(selectedTickets_visitors);
    }
    if (status_code == 200) {
      await init();
      final snackBar = get_snack_bar("Selected tickets rejected", Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = get_snack_bar("Failed to reject the tickets\n", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> accept_action_tickets() async {
    databaseInterface db = new databaseInterface();
    int status_code = 0;
    if(Person == 'Students'){
      status_code = await db.accept_selected_tickets(selectedTickets_action);
    }else if(Person == 'Visitors'){
      status_code = await db.accept_selected_tickets_visitors(selectedTickets_visitors_action);
    }
    if (status_code == 200) {
      await init();
      final snackBar = get_snack_bar("Ticket Accepted", Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = get_snack_bar("Failed to accept that ticket", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> reject_action_tickets() async {
    databaseInterface db = new databaseInterface();
    int status_code = 0;
    if(Person == 'Students'){
      status_code = await db.reject_selected_tickets(selectedTickets_action);
    }else if(Person == 'Visitors'){
      status_code = await db.reject_selected_tickets_visitors(selectedTickets_visitors_action);
    }
    if (status_code == 200) {
      await init();
      final snackBar = get_snack_bar("Ticket Rejected", Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = get_snack_bar("Failed to reject the ticket\n", Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<List<ResultObj>> get_pending_tickets_for_guard() async {
    return await databaseInterface.get_pending_tickets_for_guard(widget.location, widget.enter_exit);
  }

  Future<List<ResultObj4>> get_pending_tickets_for_visitors() async {
    return await databaseInterface.get_pending_tickets_for_visitors(widget.enter_exit);
  }

  List<String> segregrateTicketEntries(List<String> allTickets) {
    List<String> ans = [];

    entryNumToEmailMap = new Map();
    emailToEntryNumMap = new Map();

    allTickets.forEach((element) {
      var list = element.split("\n");
      var entry_number = list[0].split(",")[0];
      ans.add(list[0]);
      if(Person == "Students"){
        var email = list[1];
        entryNumToEmailMap[entry_number] = email;
        emailToEntryNumMap[email] = entry_number;
      }
    });

    return ans;
  }

  Future init() async {
    // ignore: unused_local_variable
    var tickets_local;

    if(Person == 'Students'){
      tickets_local = await get_pending_tickets_for_guard();
    }
    else{
      tickets_local = await get_pending_tickets_for_visitors();
    }
     
    var list_of_persons_local;

    if(Person == 'Students'){
      list_of_persons_local = await databaseInterface.get_list_of_entry_numbers("guards");
    }
    else{
      list_of_persons_local = await databaseInterface.get_list_of_visitors();
    }

    setState(() {
      if(Person == 'Students'){
        tickets = tickets_local;        
        selectedTickets = [];
        selectedTickets_action = [];
      }
      else{
        tickets_visitors = tickets_local;
        selectedTickets_visitors = [];
        selectedTickets_visitors_action = [];
      }
      
      list_of_persons = segregrateTicketEntries(list_of_persons_local);
    });
  }

  void apply_filters() {

    if(Person =="Students"){
      List<ResultObj> tickets_local = tickets;
      if (ticket_type_filter_applied) {
        print("Ticket Type Filtered Applied");
        if ((isSelected[0] && isSelected[1]) == false) {
          print("Not Both true");
          if (isSelected[0]) {
            print("First True");
            List<ResultObj> tickets_local_1 = [];
            for (int i = 0; i < tickets_local.length; i++) {
              print("Ticket Type: " + tickets[i].ticket_type);
              if (tickets[i].ticket_type == 'enter') {
                tickets_local_1.add(tickets[i]);
              }
            }
            tickets_local = tickets_local_1;
          } else {
            List<ResultObj> tickets_local_1 = [];
            for (int i = 0; i < tickets_local.length; i++) {
              if (tickets[i].ticket_type == 'exit') {
                tickets_local_1.add(tickets[i]);
              }
            }
            tickets_local = tickets_local_1;
          }
        }
      }
      if (date_filter_applied) {
        List<ResultObj> tickets_local_1 = [];
        for (int i = 0; i < tickets_local.length; i++) {
          var ticket_date = tickets_local[i].date_time.split("T")[0];
          print("date time of ticket " + tickets_local[i].date_time.toString());
          var start_match = ticket_date.compareTo(chosen_start_date);
          var end_match = ticket_date.compareTo(chosen_end_date);
          if (start_match >= 0 && end_match <= 0) {
            tickets_local_1.add(tickets[i]);
          }
        }
        tickets_local = tickets_local_1;
      }
      if (chosen_entry_number != "None") {
        // TODO Uncomment this code after committing the map
        List<ResultObj> tickets_local_1 = [];
        for (int i = 0; i < tickets_local.length; i++) {
          if (emailToEntryNumMap[tickets[i].email] == chosen_entry_number) {
            tickets_local_1.add(tickets[i]);
          }
        }
        tickets_local = tickets_local_1;
      }
      setState(() {
        tickets = tickets_local;
        selectedTickets = [];
      });
    }
    else if(Person == 'Visitors'){
      List<ResultObj4> tickets_local = tickets_visitors;
      if (date_filter_applied) {
        List<ResultObj4> tickets_local_1 = [];
        for (int i = 0; i < tickets_local.length; i++) {
          var ticket_date = tickets_local[i].date_time_of_ticket_raised.split("T")[0];
          var start_match = ticket_date.compareTo(chosen_start_date);
          var end_match = ticket_date.compareTo(chosen_end_date);
          if (start_match >= 0 && end_match <= 0) {
            tickets_local_1.add(tickets_visitors[i]);
          }
        }
        tickets_local = tickets_local_1;
      }
      if (chosen_mobile_number != "None") {
        List<ResultObj4> tickets_local_1 = [];
        for (int i = 0; i < tickets_local.length; i++) {
          if (tickets_visitors[i].mobile_no == chosen_mobile_number && tickets_visitors[i].visitor_name == chosen_name) {
            tickets_local_1.add(tickets_visitors[i]);
          }
        }
        tickets_local = tickets_local_1;
      }

      setState(() {
        tickets_visitors = tickets_local;
        selectedTickets_visitors = [];
      });
    }
  }

  void filterTicketsByEntryNumber(String entry_number) {
    List<ResultObj> new_tickets = [];
    entry_number = entry_number.split(",")[0];
    var email = entryNumToEmailMap[entry_number];

    // print("Entry number of student is: " + entry_number);
    // print("Email of student is: " + email);
    this.tickets.forEach((ResultObj element) {
      if (element.email == email) {
        new_tickets.add(element);
      }
    });

    setState(() {
      this.tickets = new_tickets;
      selectedTickets = [];
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
              SizedBox(
                height: 5,
              ),
              if (widget.enter_exit == "enter")
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width - 140),
                        child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.supervised_user_circle, // Add Visitor Button
                              color: Colors.white,
                              size: 18.0,
                            ),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VisitorForm(location: "Main Gate")));
                            },
                            label: Text("Add Visitors"),
                        ),
                    ),
                  ],
                ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/security_guards.jpg',
                      height: 150,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Container(
                              // Accept Button at the top
                              padding: EdgeInsets.all(5),
                              child: IconButton(
                                onPressed: () async {
                                  await accept_selected_tickets();
                                },
                                icon: Icon(
                                  Icons.check_circle_outlined,
                                  color: Colors.green,
                                  size: 50.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Container(
                              // Reject Button at the top
                              padding: EdgeInsets.all(5),
                              child: IconButton(
                                onPressed: () async {
                                  await reject_selected_tickets();
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 50.0,
                                ),
                              ),
                              //decoration: Decoration(),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              child: IconButton(
                                onPressed: () async {
                                  init();
                                },
                                icon: Icon(
                                  Icons.refresh, // Refresh Button
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 300,
                        )
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
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
                        if (value != null) {
                          setState(() {
                            _character = value;
                            Person = value.name;
                            init();
                          });
                        }
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
                        if (value != null) {
                          setState(() {
                            _character = value;
                            Person = value.name;
                            init();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.filter_list, // Filter Button
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
                              chosen_start_date = x!;
                              chosen_end_date = y!;
                              isSelected = z;
                              this.date_filter_applied = date_filter_applied;
                              this.ticket_type_filter_applied = ticket_type_filter_applied;
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  dropdown(context, list_of_persons, (String? s) {
                        if (s != null) {
                          var detail_list = s.split(",");
                          // this.chosen_entry_number = this.chosen_entry_number.split(",")[0];
                          if(Person == 'Students'){
                            chosen_entry_number = detail_list[0];
                            chosen_name = detail_list[1];
                          }
                          else{
                            chosen_mobile_number = detail_list[0];
                            chosen_name = detail_list[1];
                          }
                        }
                      },
                      "Enter Name",
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      border_radius: 100,
                      container_color: Colors.indigo
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search, // Search Button
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: () {
                      apply_filters();
                    },
                  ),
                  SizedBox(
                    width: 300,
                  ),
                ],
              ),

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
              // buildDataTable()
              // Text("No entries available in the ticket table"),
              // Testing()
              ScrollableWidget(child: buildDataTable()),
              // Expanded(child: ScrollableWidget(child: buildDataTable())),
              // buildSubmit(),
            ],
          ),
        ),
      );

  Widget buildDataTable() {
    var columns;
    if(Person == 'Students'){
      columns = [
        'Name',
        'Action',
        'Time',
      ];
    }else if(Person == 'Visitors'){
      columns = [
        'Visitor',
        'Car Number',
        'Purpose',
        'Action',
      ];
    }    

    if(Person == 'Students'){
      return DataTable(
        onSelectAll: (isSelectedAll) {
          setState(() => selectedTickets = isSelectedAll! ? tickets : []);
          // Utils.showSnackBar(context, 'All Selected: $isSelectedAll');
        },
        border: TableBorder.all(width: 1, color: Colors.white),
        headingRowColor: MaterialStateProperty.all(Colors.orangeAccent),
        columns: getColumns(columns),
        rows: getRows(tickets),
        dataRowHeight: 100,
      );
    }else{
      return DataTable(
        onSelectAll: (isSelectedAll) {
          setState(() => selectedTickets_visitors = isSelectedAll! ? tickets_visitors : []);
          // Utils.showSnackBar(context, 'All Selected: $isSelectedAll');
        },
        border: TableBorder.all(width: 1, color: Colors.white),
        headingRowColor: MaterialStateProperty.all(Colors.orangeAccent),
        columns: getColumns(columns),
        rows: getRows2(tickets_visitors),
        dataRowHeight: 100,
      );
    }    
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
      row_list.add(
          DataRow(
            color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
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
            selected: selectedTickets.contains(ticket),
            onSelectChanged: (isSelected) => setState(() {
              final isAdding = isSelected != null && isSelected;
              isAdding ? selectedTickets.add(ticket) : selectedTickets.remove(ticket);
              print(selectedTickets);
            }),
            cells: [
              // DataCell(Text((index + 1).toString())),
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
              DataCell(
                Column(
                  children: [
                    IconButton(
                      // Action Button Tick
                      onPressed: () async {
                        selectedTickets_action.add(ticket);
                        await accept_action_tickets();
                      },
                      icon: Icon(
                        Icons.check_circle_outlined,
                        color: Colors.green,
                        size: 24.0,
                      ),
                    ),
                    IconButton(
                      // Action Button Cross
                      onPressed: () async {
                        selectedTickets_action.add(ticket);
                        await reject_action_tickets();
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Text("    " +
                    ((ticket.date_time.split("T").last)
                            .split(".")[0]
                            .split(":")
                            .sublist(0, 2))
                        .join(":") +
                    "\n" +
                    ticket.date_time.split("T")[0]),
              ),
              // DataCell(Text(ticket.ticket_type.toString())),
              // DataCell(Text(ticket.authority_status.toString())),
            ],
      ));
    }
    // print("row_list");
    // print(row_list);
    return row_list;
  }

  List<DataRow> getRows2(List<ResultObj4> tickets) {
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
        selected: selectedTickets_visitors.contains(ticket),
        onSelectChanged: (isSelected) => setState(() {
          final isAdding = isSelected != null && isSelected;

          isAdding
              ? selectedTickets_visitors.add(ticket)
              : selectedTickets_visitors.remove(ticket);
        }),
        // columns = ['Visitor','Car Number','Purpose']

        cells: [
          DataCell(
            Row(
              children: [
                if (ticket.authority_status.toString() != 'NA')
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          AuthorityMessage(
                            ticket.authority_name + 
                            ", " + 
                            ticket.authority_designation + 
                            "\n" + 
                            ticket.authority_status + 
                            "\n" + 
                            ticket.authority_message + 
                            "\n\n", 
                            context);
                        },
                        icon: Icon(
                          Icons.message_outlined,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                      if (ticket.authority_status.contains("Approved"))
                        Icon(
                          Icons.check, // Blue Tick
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
                // TextButton(
                //   onPressed: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => ProfilePage(
                //           email: ticket.email.toString(),
                //           isEditable: false,
                //         ),
                //       ),
                //     );
                //   },
                //   child: Text(
                //     ticket.student_name.toString(),
                //     style: TextStyle(color: Colors.lightBlueAccent),
                //   ),
                // ),
                Text(
                  ticket.visitor_name + "\n" + ticket.mobile_no,
                  // style: TextStyle(color: Colors.lightBlueAccent),
                ),
              ],
            ),
          ),
          DataCell(
            Text(ticket.car_number),
          ),
          DataCell(
            Text(ticket.purpose),
          ),
          DataCell(
            Column(
              children: [
                IconButton(
                  // Action Button Tick for Visitors
                  onPressed: () async {
                    selectedTickets_visitors_action.add(ticket);
                    await accept_action_tickets();
                  },
                  icon: Icon(
                    Icons.check_circle_outlined, 
                    color: Colors.green,
                    size: 24.0,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    selectedTickets_visitors_action.add(ticket);
                    await reject_action_tickets();
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 24.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ));
    }
    // print("row_list");
    // print(row_list);
    return row_list;
  }
}
