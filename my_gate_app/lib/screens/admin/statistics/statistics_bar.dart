// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unnecessary_this, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/admin/utils/date_picker_button.dart';
import 'package:my_gate_app/screens/admin/utils/dropdown.dart';
import 'package:my_gate_app/screens/admin/utils/submit_button.dart';
import 'package:my_gate_app/screens/utils/custom_snack_bar.dart';
import 'bar_chart.dart';
// import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class StatisticsBar extends StatefulWidget {
  const StatisticsBar({Key? key}) : super(key: key);

  @override
  _StatisticsBarState createState() => _StatisticsBarState();
}

class _StatisticsBarState extends State<StatisticsBar> {
  String chosen_location = "None";
  String chosen_filter = "None";
  String chosen_start_date = "";
  String chosen_end_date = "";
  late DateTime start_date;
  late DateTime end_date;

  final List<String> locations = databaseInterface.getLoctions();
  final location_name_form_key = GlobalKey<FormState>();

  final List<String> time_step = <String>['Hourly', 'Daily', 'Monthly'];
  final filter_form_key = GlobalKey<FormState>();

  List<OrdinalSales> data = [];
  // Add None value to the list parent_locations

  Future<void> generate_barchart() async {
    List<StatisticsResultObj> res= await databaseInterface.get_piechart_statistics_by_location(this.chosen_location, this.chosen_filter, this.chosen_start_date,this.chosen_end_date);
    List<OrdinalSales> new_data = [];
    int index=0;
    for (StatisticsResultObj each_object in res){
      if (each_object.count!=0){
        new_data.add(new OrdinalSales(each_object.category, each_object.count));
      }
      index++;
    }
    setState(() {
      data=new_data;
    });

  }

  Widget show_chart(var data){
    if (data.length !=0) {
      return SimpleBarChart.withSampleData(this.data);
    }
    return Text("");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                this.time_step,
                (String? s) {
                  if (s != null) {
                    this.chosen_filter = s;
                  }
                },
                "Time Step",
                Icon(
                  Icons.filter_alt_outlined,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // get_date_picker(context),
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
                            var chosen_date = DateFormat('yyyy-MM-dd').format(date);
                            this.chosen_start_date = '$chosen_date';
                          });
                          print('confirm $date');
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Text(
                        'Start Date',
                        style: TextStyle(color: Colors.blue),
                      )),
                  Text(
                    this.chosen_start_date,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
                            var chosen_date = DateFormat('yyyy-MM-dd').format(date);
                            this.chosen_end_date = '$chosen_date';
                          });
                          print('confirm $date');
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Text(
                        'End Date',
                        style: TextStyle(color: Colors.blue),
                      )),
                  Text(
                    this.chosen_end_date,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SubmitButton(
                submit_function: () async {
                  
                  if (this.chosen_location!="None" && this.chosen_filter!="None" && this.chosen_start_date!="" && this.chosen_end_date!=""){
                    if (this.chosen_end_date.compareTo(this.chosen_start_date)<0){
                      print("Start date is more than end date");
                      // add a snack bar for this
                      final snackBar = get_snack_bar("Start date is more than end date", Colors.red);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    generate_barchart();
                  }
                },
                button_text: "Get",
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: show_chart(this.data),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
