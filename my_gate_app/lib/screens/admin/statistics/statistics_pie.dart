// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unnecessary_this, avoid_print

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/admin/statistics/donut_chart.dart';
import 'package:my_gate_app/screens/admin/utils/dropdown.dart';
import 'package:my_gate_app/screens/admin/utils/submit_button.dart';
import 'package:my_gate_app/screens/admin/utils/textbox.dart';

class StatisticsPie extends StatefulWidget {
  const StatisticsPie({Key? key}) : super(key: key);

  @override
  _StatisticsPieState createState() => _StatisticsPieState();
}

class _StatisticsPieState extends State<StatisticsPie> {
  String chosen_location = "None";
  String chosen_filter = "None";

  final List<String> locations = databaseInterface.getLoctions();
  final location_name_form_key = GlobalKey<FormState>();
  List<LinearSales> data = [];
  var color_array = [Colors.pink, Colors.green, Colors.red, Colors.blue, Colors.yellow, Colors.purple, Colors.orange, Colors.indigoAccent ,Colors.amber, Colors.deepPurple, Colors.deepOrange];

  final List<String> filters = <String>[
    'Gender',
    'Year',
    'Department',
    'Program',
  ];
  final filter_form_key = GlobalKey<FormState>();

  // Add None value to the list parent_locations

  Future<void> generate_piechart(String location, String filter) async {
    //let's retrieve for gender first
    List<StatisticsResultObj> res =  await databaseInterface.get_statistics_data_by_location(location, filter);
    List<LinearSales> new_data = [];
    int index=0;
    for (StatisticsResultObj each_object in res){
      if(each_object.count!=0){
        new_data.add(new LinearSales(each_object.category, each_object.count, color_array[index]));
      }
      index++;
    }
    setState(() {
      data=new_data;
    });
    // final data = [
    //   new LinearSales("Category 1", 45, Colors.pink),
    //   new LinearSales("Category 2", 20, Colors.green),
    //   new LinearSales("Category 3", 20, Colors.red),
    //   new LinearSales("Category 4", 15, Colors.blue),
    // ];
    
  }

  Widget show_chart(var data){
    if (data.length !=0) {
      return DonutPieChart.withSampleData(data);
    }
    return Text("");
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
                if (this.chosen_location!= "None" && this.chosen_filter!= "None") {
                  generate_piechart(this.chosen_location,this.chosen_filter);
                }
                
              },
              button_text: "Get",
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              // child: DonutPieChart.withSampleData(this.data),
              child: show_chart(this.data),
            ),
          ],
        ),
      ),
    );
  }

  
}
