// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/guard/utils/search_dropdown.dart';
import 'package:my_gate_app/screens/profile2/visitor_profile/visitor_profile_page.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/get_email.dart';


class PastAuthorityVisitorTicketTable extends StatefulWidget {
  const PastAuthorityVisitorTicketTable({ Key? key }) : super(key: key);

  @override
  State<PastAuthorityVisitorTicketTable> createState() => _PastAuthorityVisitorTicketTableState();
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


class _PastAuthorityVisitorTicketTableState extends State<PastAuthorityVisitorTicketTable> {

  List<ResultObj4> tickets_visitors = [];
  List<String> list_of_persons = [];
  
  String chosen_visitor_name = "None";
  String chosen_visitor_mobile_no = "None";

  List<Color?> inkColors = [
    Colors.orangeAccent[100],
    getColorFromHex('f5a6ff'),
    getColorFromHex('f7f554'),
    getColorFromHex('34ebc0'),
    Colors.lightGreenAccent[200],
    getColorFromHex('62de72'),
  ];

  void apply_filters() {
    List<ResultObj4> tickets_local = tickets_visitors;
    if (chosen_visitor_mobile_no != "None" && chosen_visitor_name != "None" ) {
      List<ResultObj4> tickets_local_1 = [];
      for (int i = 0; i < tickets_local.length; i++) {
        if (tickets_visitors[i].mobile_no == chosen_visitor_mobile_no && tickets_visitors[i].visitor_name == chosen_visitor_name) {
          tickets_local_1.add(tickets_visitors[i]);
        }
      }
      tickets_local = tickets_local_1;
    }

    setState(() {
      tickets_visitors = tickets_local;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<List<ResultObj4>> get_past_visitor_tickets_for_authorities() async {
    return await databaseInterface.get_past_visitor_tickets_for_authorities(LoggedInDetails.getEmail());
  }

  List<String> segregrateTickettickets_visitors(List<String> allTickets) {
    List<String> ans = [];

    allTickets.forEach((element) {
      var list = element.split("\n");
      ans.add(list[0]);
    });

    return ans;
  }

  Future init() async {
    // ignore: unused_local_variable
    var tickets_local = await get_past_visitor_tickets_for_authorities();
    
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [Colors.white, Colors.white]),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),            
            dropdown(
              context,
              list_of_persons,
              (String? s) {
                if (s != null) {
                  var detail_list = s.split(",");
                  chosen_visitor_mobile_no = detail_list[0];
                  chosen_visitor_name = detail_list[1];
                  apply_filters();
                }
              },
              "Visitor Name",
              Icon(
                Icons.search,
                color: Colors.black,
              ),
              border_radius: 100,
              container_color: Colors.white,
              text_color: Colors.black,
            ),
            Expanded(
              // Logic for Tiles that will be displayed
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  // childAspectRatio: (1.2 / 1),
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
                                isEditable: false,
                              )));
                    },
                    child: Container(
                      height: 10,
                      width: 40,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: inkColors[0 % inkColors.length],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          FittedBox(
                            child: Container(
                              margin: EdgeInsets.all(20),
                              height: 50,
                            ),
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
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
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Icon(
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
          ],
        ),
      ),
    );
  
  }
}