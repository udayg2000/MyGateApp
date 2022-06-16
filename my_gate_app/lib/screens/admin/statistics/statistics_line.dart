// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unnecessary_this, avoid_print

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/admin/statistics/line_chart.dart';
import 'package:my_gate_app/screens/admin/utils/dropdown.dart';
import 'package:my_gate_app/screens/admin/utils/submit_button.dart';
import 'package:my_gate_app/screens/admin/utils/textbox.dart';

import 'bar_chart.dart';

class StatisticsLine extends StatefulWidget {
  const StatisticsLine({Key? key}) : super(key: key);

  @override
  _StatisticsLineState createState() => _StatisticsLineState();
}

class _StatisticsLineState extends State<StatisticsLine> {
  String chosen_location = "None";
  String chosen_filter = "None";

  final List<String> locations = databaseInterface.getLoctions();
  final location_name_form_key = GlobalKey<FormState>();

  final List<String> filters = <String>[
    'Gender',
    'Year',
    'Department',
    'Program',
  ];
  final filter_form_key = GlobalKey<FormState>();

  List<LinearSales> data = [];
  // Add None value to the list parent_locations

  Future<void> generate_piechart() async {
    // List<StatisticsResultObj> res =  await databaseInterface.get_statistics_data_by_location(this.chosen_location, this.chosen_filter);
    // List<LinearSales> new_data = [];
    // int index=0;
    // for (StatisticsResultObj each_object in res){
    //   new_data.add(new LinearSales(each_object.category, each_object.count));
    //   index++;
    // }
    // setState(() {
    //   data=new_data;
    // });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Statistics",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                  fontSize: 30),
            ),
            SizedBox(
              height: 10,
            ),
            dropdown(
              context,
              this.locations,
                  (String? s) {
                if (s != null) {
                  // print("inside funciton:" + this.chosen_parent_location);
                  this.chosen_location = s;
                  // print(this.chosen_parent_location);
                }
              },
              "Location",
              Icon(
                Icons.corporate_fare,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            dropdown(
              context,
              this.filters,
                  (String? s) {
                if (s != null) {
                  this.chosen_filter = s;
                }
              },
              "Filter",
              Icon(
                Icons.filter_alt_outlined,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SubmitButton(
              submit_function: () async {
                generate_piechart();
              },
              button_text: "Get",
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SimpleLineChart.withSampleData(this.data),
            ),
          ],
        ),
      ),
    );
  }
}
