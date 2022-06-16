
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_gate_app/screens/admin/statistics/button_widget.dart';

class DateRangePickerWidget extends StatefulWidget {
  @override
  _DateRangePickerWidgetState createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  late DateTimeRange dateRange;

  String getFrom() {
    if (dateRange == null) {
      return 'From';
    } else {
      return DateFormat('MM/dd/yyyy').format(dateRange.start);
    }
  }

  String getUntil() {
    if (dateRange == null) {
      return 'Until';
    } else {
      return DateFormat('MM/dd/yyyy').format(dateRange.end);
    }
  }

  @override
  Widget build(BuildContext context) => HeaderWidget(
    title: 'Date Range',
    child: Row(
      children: [
        Expanded(
          child: ButtonWidget(
            text: getFrom(),
            onClicked: () => pickDateRange(context),
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.arrow_forward, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(
          child: ButtonWidget(
            text: getUntil(),
            onClicked: () => pickDateRange(context),
          ),
        ),
      ],
    ),
  );

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }
}


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//
// // void main() {
// //   return runApp(MyApp());
// // }
//
// /// My app class to display the date range picker
// class MyApp extends StatefulWidget {
//   @override
//   MyAppState createState() => MyAppState();
// }
//
// /// State for MyApp
// class MyAppState extends State<MyApp> {
//   String _selectedDate = '';
//   String _dateCount = '';
//   String _range = '';
//   String _rangeCount = '';
//
//   /// The method for [DateRangePickerSelectionChanged] callback, which will be
//   /// called whenever a selection changed on the date picker widget.
//   void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//     /// The argument value will return the changed date as [DateTime] when the
//     /// widget [SfDateRangeSelectionMode] set as single.
//     ///
//     /// The argument value will return the changed dates as [List<DateTime>]
//     /// when the widget [SfDateRangeSelectionMode] set as multiple.
//     ///
//     /// The argument value will return the changed range as [PickerDateRange]
//     /// when the widget [SfDateRangeSelectionMode] set as range.
//     ///
//     /// The argument value will return the changed ranges as
//     /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
//     /// multi range.
//     setState(() {
//       if (args.value is PickerDateRange) {
//         _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
//             // ignore: lines_longer_than_80_chars
//             ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
//       } else if (args.value is DateTime) {
//         _selectedDate = args.value.toString();
//       } else if (args.value is List<DateTime>) {
//         _dateCount = args.value.length.toString();
//       } else {
//         _rangeCount = args.value.length.toString();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Positioned(
//           left: 0,
//           right: 0,
//           top: 0,
//           height: 80,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text('Selected date: $_selectedDate'),
//               Text('Selected date count: $_dateCount'),
//               Text('Selected range: $_range'),
//               Text('Selected ranges count: $_rangeCount')
//             ],
//           ),
//         ),
//         Positioned(
//           left: 0,
//           top: 80,
//           right: 0,
//           bottom: 0,
//           child: SfDateRangePicker(
//             onSelectionChanged: _onSelectionChanged,
//             selectionMode: DateRangePickerSelectionMode.range,
//             initialSelectedRange: PickerDateRange(
//                 DateTime.now().subtract(const Duration(days: 4)),
//                 DateTime.now().add(const Duration(days: 3))),
//           ),
//         )
//       ],
//     );
//   }
// }
//
// // import 'package:flutter/material.dart';
// // import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
// //
// // Widget get_date_picker(context){
// //   return MaterialButton(
// //       color: Colors.deepOrangeAccent,
// //       onPressed: () async {
// //         final List<DateTime> picked = await DateRagePicker.showDatePicker(
// //             context: context,
// //             initialFirstDate: new DateTime.now(),
// //             initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
// //             firstDate: new DateTime(2015),
// //             lastDate: new DateTime(2030)
// //         );
// //         if (picked != null && picked.length == 2) {
// //           print(picked);
// //         }
// //       },
// //       child: new Text("Pick date range")
// //   );
// // }
