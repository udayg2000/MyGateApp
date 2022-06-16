// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_gate_app/screens/admin/utils/dropdown.dart';

class FilterPage extends StatefulWidget {
  FilterPage({
    Key? key,
    required this.chosen_start_date,
    required this.chosen_end_date,
    required this.isSelected,
    required this.onSavedFunction,
  }) : super(key: key);
  String chosen_start_date = "None";
  String chosen_end_date = "None";
  List<bool> isSelected;
  void Function(String?, String?, List<bool>, bool, bool)? onSavedFunction;
   

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<String> ticket_types = ["Entry", "Exit", "Entry & Exit"];
  late String chosen_ticket_type = "";
  bool date_filter_applied = false;
  bool ticket_type_filter_applied = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            "Filter Page",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.lightGreenAccent,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                          // crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                          children: [
                            Checkbox(
                              side: MaterialStateBorderSide.resolveWith(
                                    (states) => BorderSide(width: 1.0, color: Colors.black),
                              ),
                              checkColor: Colors.black,
                              activeColor: Colors.red,
                              value: this.date_filter_applied,
                              onChanged: (bool? value) {
                                if(value != null) {
                                  setState(() {
                                    this.date_filter_applied = value;
                                  });
                                }
                              },
                            ),
                            Text(
                              "Apply Date filter",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "Choose Start Date\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                DatePicker.showDatePicker(
                                  context,
                                  showTitleActions: true,
                                  minTime: DateTime(DateTime.now().year - 1,
                                      DateTime.now().month, DateTime.now().day),
                                  maxTime: DateTime(DateTime.now().year,
                                      DateTime.now().month, DateTime.now().day),
                                  onChanged: (date) {
                                    print('change $date');
                                  },
                                  onConfirm: (date) {
                                    setState(() {
                                      var chosen_date =
                                          DateFormat('yyyy-MM-dd').format(date);
                                      widget.chosen_start_date = '$chosen_date';
                                    });
                                    print('confirm $date');
                                  },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en,
                                );
                              },
                              child: Text(
                                'Start Date',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            Text(
                              widget.chosen_start_date,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Choose End Date\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(DateTime.now().year - 1,
                                      DateTime.now().month, DateTime.now().day),
                                  maxTime: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day), onChanged: (date) {
                                print('change $date');
                              }, onConfirm: (date) {
                                setState(() {
                                  var chosen_date =
                                      DateFormat('yyyy-MM-dd').format(date);
                                  widget.chosen_end_date = '$chosen_date';
                                });
                                print('confirm $date');
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Text(
                              'End Date',
                              style: TextStyle(color: Colors.blue),
                            )),
                        Text(
                          widget.chosen_end_date,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                  // crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                  children: [
                    Checkbox(
                      side: MaterialStateBorderSide.resolveWith(
                            (states) => BorderSide(width: 1.0, color: Colors.black),
                      ),
                      checkColor: Colors.black,
                      activeColor: Colors.red,
                      value: this.ticket_type_filter_applied,
                      onChanged: (bool? value) {
                        if(value != null) {
                          setState(() {
                            this.ticket_type_filter_applied = value;
                          });
                        }
                      },
                    ),
                    Text(
                      "Apply Ticket Type (Entry/Exit) filter",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                dropdown(
                  context,
                  this.ticket_types,
                  (String? s) {
                    if (s != null) {
                      this.chosen_ticket_type = s;
                    }
                  },
                  "Ticket Type",
                  Icon(
                    Icons.sticky_note_2,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.save_alt_sharp,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      primary: Colors.red),
                  onPressed: () {
                    if (this.chosen_ticket_type == "Entry") {
                      widget.isSelected[0] = true;
                      widget.isSelected[1] = false;
                    }
                    if (this.chosen_ticket_type == "Exit") {
                      widget.isSelected[0] = false;
                      widget.isSelected[1] = true;
                    }
                    if (this.chosen_ticket_type == "Entry & Exit") {
                      widget.isSelected[0] = true;
                      widget.isSelected[1] = true;
                    }

                    widget.onSavedFunction!(
                      widget.chosen_start_date,
                      widget.chosen_end_date,
                      widget.isSelected,
                      date_filter_applied,
                      ticket_type_filter_applied,
                    );

                    Navigator.pop(context);
                  },
                  label: Text(
                    'Apply',
                    // style: GoogleFonts.roboto(),
                  ),
                ),
                //decoration: Decoration(),
              ],
            ),
          ),
        ));
  }
}
