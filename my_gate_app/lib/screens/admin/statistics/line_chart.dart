/// Example of a simple line chart.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series<LinearSales, int>> seriesList;
  final bool? animate;

  SimpleLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory SimpleLineChart.withSampleData(var data) {
    return new SimpleLineChart(
      _createSampleData(data),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList, animate: animate);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData(var data) {
    // final data = [
    //   new LinearSales(0, 5),
    //   new LinearSales(1, 25),
    //   new LinearSales(2, 100),
    //   new LinearSales(3, 75),
    //   new LinearSales(4, 75),
    //   new LinearSales(5, 75),
    //   new LinearSales(6, 75),
    //   new LinearSales(7, 75),
    //   new LinearSales(8, 75),
    //   new LinearSales(9, 75),
    //   new LinearSales(10, 75),
    //   new LinearSales(11, 75),
    //   new LinearSales(12, 75),
    //   new LinearSales(13, 75),
    //   new LinearSales(14, 75),
    //   new LinearSales(15, 75),


    // ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
