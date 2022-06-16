/// Donut chart example. This is a simple pie chart with a hole in the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DonutPieChart extends StatelessWidget {
  final List<charts.Series<LinearSales, String>> seriesList;
  final bool? animate;

  DonutPieChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  /// 
  factory DonutPieChart.withSampleData(var data) {
    return new DonutPieChart(
      _createSampleData(data),
      // Disable animations for image tests.
      animate: true,
      // animationDuration: Duration(seconds: 2),
    );
  }

  // factory DonutPieChart.withMYData(var data) {
  //   return new DonutPieChart(
  //     _createSampleData(),
  //     // Disable animations for image tests.
  //     animate: true,
  //     // animationDuration: Duration(seconds: 2),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart<String>(
      seriesList,
      animate: animate,
      animationDuration: Duration(seconds: 2),
      behaviors: [
        new charts.DatumLegend(
          outsideJustification: charts.OutsideJustification.endDrawArea,
          horizontalFirst: false,
          desiredMaxRows: 2,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          entryTextStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.purple.shadeDefault,
              fontFamily: 'Georgia',
              fontSize: 20),
        )
      ],
      // Configure the width of the pie slices to 60px. The remaining space in
      // the chart will be left as a hole in the center.
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 100,
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.inside,
            insideLabelStyleSpec: charts.TextStyleSpec(
              color: charts.Color.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, String>> _createSampleData(var data) {
    // final data = [
    //   new LinearSales("Category 1", 45, Colors.pink),
    //   new LinearSales("Category 2", 20, Colors.green),
    //   new LinearSales("Category 3", 20, Colors.red),
    //   new LinearSales("Category 4", 15, Colors.blue),
    // ];

    return [
      new charts.Series<LinearSales, String>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.sector_name,
        measureFn: (LinearSales sales, _) => sales.sales,
        colorFn: (LinearSales sales, _) =>
            charts.ColorUtil.fromDartColor(sales.colorval),
        labelAccessorFn: (LinearSales sales, _) => '${sales.sales}',
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final String sector_name;
  final int sales;
  final Color colorval;

  LinearSales(this.sector_name, this.sales, this.colorval);
}

// /// Donut chart example. This is a simple pie chart with a hole in the middle.
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:flutter/material.dart';
//
// class DonutPieChart extends StatelessWidget {
//   final List<charts.Series> seriesList;
//   final bool? animate;
//
//   DonutPieChart(this.seriesList, {required this.animate});
//
//   /// Creates a [PieChart] with sample data and no transition.
//   factory DonutPieChart.withSampleData() {
//     return new DonutPieChart(
//       _createSampleData(),
//       // Disable animations for image tests.
//       animate: false,
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return charts.PieChart<String>(seriesList,
//         animate: animate,
//         // Configure the width of the pie slices to 60px. The remaining space in
//         // the chart will be left as a hole in the center.
//         defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60));
//   }
//
//   /// Create one series with sample hard coded data.
//   static List<charts.Series<LinearSales, int>> _createSampleData() {
//     final data = [
//       new LinearSales(0, 100),
//       new LinearSales(1, 75),
//       new LinearSales(2, 25),
//       new LinearSales(3, 5),
//     ];
//
//     return [
//       new charts.Series<LinearSales, int>(
//         id: 'Sales',
//         domainFn: (LinearSales sales, _) => sales.year,
//         measureFn: (LinearSales sales, _) => sales.sales,
//         data: data,
//       )
//     ];
//   }
// }
//
// /// Sample linear data type.
// class LinearSales {
//   final int year;
//   final int sales;
//
//   LinearSales(this.year, this.sales);
// }
