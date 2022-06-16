// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/admin/statistics/statistics_bar.dart';
import 'package:my_gate_app/screens/admin/statistics/statistics_line.dart';
import 'package:my_gate_app/screens/admin/statistics/statistics_pie.dart';

import '../manage_locations/add_locations.dart';

class StatisticsTabs extends StatefulWidget {
  const StatisticsTabs({Key? key}): super(key: key);

  @override
  State<StatisticsTabs> createState() => _StatisticsTabsTabsState();
}

class _StatisticsTabsTabsState extends State<StatisticsTabs>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  List<ResultObj> tickets = [];

  // The initState and dispose state are required for adding the tabs
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: Text("View Statistics"),
        centerTitle: true,
        bottom: TabBar(
          controller: controller,
          tabs: [
            Tab(icon: Icon(Icons.pie_chart_outline_outlined)),
            Tab(icon: Icon(Icons.bar_chart)),
            // Tab(icon: Icon(Icons.stacked_line_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          StatisticsPie(),
          StatisticsBar(),
          // StatisticsLine(),
        ],
      ),
    ),
  );
}
