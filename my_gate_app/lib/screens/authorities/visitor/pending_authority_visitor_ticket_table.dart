// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/profile2/visitor_profile/visitor_profile_page.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/get_email.dart';

class PendingAuthorityVisitorTicketTable extends StatefulWidget {
  const PendingAuthorityVisitorTicketTable({ Key? key }) : super(key: key);

  @override
  State<PendingAuthorityVisitorTicketTable> createState() => _PendingAuthorityVisitorTicketTableState();
}

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    return Color(int.parse("0x$hexColor"));
  }
  return Colors.cyanAccent[100] as Color;
}

class _PendingAuthorityVisitorTicketTableState extends State<PendingAuthorityVisitorTicketTable> {
  List<ResultObj4> tickets_visitors = [];
  List<String> list_of_persons = [];

  List<Color?> inkColors = [
    Colors.orangeAccent[100],
    getColorFromHex('f5a6ff'),
    getColorFromHex('f7f554'),
    getColorFromHex('34ebc0'),
    Colors.lightGreenAccent[200],
    getColorFromHex('62de72'),   
  ];

  Future<List<ResultObj4>> get_pending_visitor_tickets_for_authorities() async {
    return await databaseInterface.get_pending_visitor_tickets_for_authorities(LoggedInDetails.getEmail());
  }

  List<String> segregrateTickettickets_visitors(List<String> allTickets) {
    List<String> ans = [];

    allTickets.forEach((element) {
      var list = element.split("\n");
      ans.add(list[0]);
    });

    return ans;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    // ignore: unused_local_variable
    var tickets_local = await get_pending_visitor_tickets_for_authorities();
    
    var list_of_persons_local = await databaseInterface.get_list_of_visitors();
  
    setState(() {
      tickets_visitors = tickets_local;
      list_of_persons = segregrateTickettickets_visitors(list_of_persons_local);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white]),
        ),
        // color: Colors.bla,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.5 / 1,
          ),
          itemCount: tickets_visitors.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VisitorProfilePage(
                                visitorObject: tickets_visitors[index],
                                isEditable: true,
                              )));
              },
              child: Container(
                height: 10,
                width: 40,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: inkColors[0 % inkColors.length],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    FittedBox(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        height: 20,
                      ),
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${tickets_visitors[index].visitor_name}',
                              style: GoogleFonts.roboto(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_right,
                      color: Colors.lightBlue,
                      size: 50.0,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  
  }
}