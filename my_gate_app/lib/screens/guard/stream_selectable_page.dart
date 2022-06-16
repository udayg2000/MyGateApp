// import 'package:flutter/material.dart';

// import 'package:my_gate_app/database/database_interface.dart';
// import 'package:my_gate_app/database/database_objects.dart';
// import 'package:my_gate_app/get_email.dart';
// import 'package:my_gate_app/screens/guard/pending_guard_ticket_table.dart';

// class StreamSelectablePage extends StatefulWidget {
//   const StreamSelectablePage({ Key? key, required this.location}) : super(key: key);
//   final String location;

//   @override
//   State<StreamSelectablePage> createState() => _StreamSelectablePageState();
// }

// class _StreamSelectablePageState extends State<StreamSelectablePage> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: databaseInterface.get_pending_tickets_for_guard_stream(widget.location),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.waiting:
//             return const Center(child: CircularProgressIndicator());
//           default:
//             if (snapshot.hasError) {
//               return const Text("Error", style: TextStyle(fontSize:24, color:Colors.red));
//             } else {
//               // String in_or_out = snapshot.data.toString();
//               List<ResultObj> tickets = [];
//               if(snapshot.hasData) {
//                 tickets = snapshot.data as List<ResultObj>;
//               }
//               return SelectablePage(location: widget.location,tickets: tickets);
//             }
//         }
//       },
//     );
//   }
// }