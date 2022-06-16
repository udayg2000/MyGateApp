// // ignore_for_file: non_constant_identifier_names

// import 'package:flutter/material.dart';
// import 'package:my_gate_app/database/database_interface.dart';
// import 'package:my_gate_app/get_email.dart';
// import 'package:my_gate_app/screens/student/student_authorities_side/generate_preapproval_ticket.dart';

// class StreamStudentAuthorityStatus extends StatefulWidget {
//   const StreamStudentAuthorityStatus({Key? key, required this.location})
//       : super(key: key);
//   final String location;

//   @override
//   State<StreamStudentAuthorityStatus> createState() =>
//       _StreamStudentAuthorityStatusState();
// }

// class _StreamStudentAuthorityStatusState
//     extends State<StreamStudentAuthorityStatus> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: databaseInterface.get_student_status(
//           LoggedInDetails.getEmail(), widget.location),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.waiting:
//             return const Center(child: CircularProgressIndicator());
//           default:
//             if (snapshot.hasError) {
//               return const Text("Error",
//                   style: TextStyle(fontSize: 24, color: Colors.red));
//             } else {
//               String in_or_out = snapshot.data.toString();

//               // print("Stream Location class returns value of in_or_out " + in_or_out);
//               return GeneratePreApprovalTicket(
//                 location: widget.location,
//                 in_or_out: in_or_out,
//               );
//             }
//         }
//       },
//     );
//   }
// }
