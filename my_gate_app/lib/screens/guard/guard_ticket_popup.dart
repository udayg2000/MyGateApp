import 'package:flutter/material.dart';

Widget GuardTicketPopup(){
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    elevation: 16,
    child: Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 20),
          Center(child: Text('Ticket Details')),
          SizedBox(height: 20),
          Text("Location: Main Gate"),
          Text("Student Name: xyz pqr"),
          Text("Date: 17/3/22"),
          Text("Time: 23:36"),
          Text("Entry/Exit: Entry"),
          Text("Pre Approval: NA"),
          Text("Authority: Dr. Verma"),
          Text("Status: Pending"),
          Text("Guard: Mr. qwe"),
        ],
      ),
    ),
  );
}


// class GuardTicketPopup extends StatelessWidget {
//   const GuardTicketPopup({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: ListView(
//           shrinkWrap: true,
//           children: <Widget>[
//             SizedBox(height: 20),
//             Center(child: Text('Leaderboard')),
//             SizedBox(height: 20),
//             Text("Location: Main Gate"),
//             Text("Student Name: xyz pqr"),
//             Text("Date: 17/3/22"),
//             Text("Time: 23:36"),
//             Text("Entry/Exit: Entry"),
//             Text("Pre Approval: NA"),
//             Text("Authority: Dr. Verma"),
//             Text("Status: Pending"),
//             Text("Guard: Mr. qwe"),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Widget _buildRow(String imageAsset, String name, double score) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//     child: Column(
//       children: <Widget>[
//         SizedBox(height: 12),
//         Container(height: 2, color: Colors.redAccent),
//         SizedBox(height: 12),
//         Row(
//           children: <Widget>[
//             CircleAvatar(backgroundImage: AssetImage(imageAsset)),
//             SizedBox(width: 12),
//             Text(name),
//             Spacer(),
//             Container(
//               decoration: BoxDecoration(color: Colors.yellow[900], borderRadius: BorderRadius.circular(20)),
//               padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//               child: Text('$score'),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }