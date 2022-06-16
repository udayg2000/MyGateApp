// // ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, non_constant_identifier_names
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:my_gate_app/auth/authscreen.dart';
// import 'package:my_gate_app/database/database_interface.dart';
// import 'package:my_gate_app/get_email.dart';
// import 'package:my_gate_app/screens/profile2/profile_page.dart';
// import 'package:my_gate_app/screens/student/raise_ticket_for_guard_or_authorities.dart';
// import 'package:my_gate_app/screens/profile2/model/menu_item.dart';
// import 'package:my_gate_app/screens/profile2/utils/menu_items.dart';
// import 'package:my_gate_app/screens/student/student_guard_side/student_tabs.dart';
// // This file calls StudentTicketTable
//
// class HomeStudent extends StatefulWidget {
//   const HomeStudent({Key? key}) : super(key: key);
//
//   @override
//   _HomeStudentState createState() => _HomeStudentState();
// }
//
// class _HomeStudentState extends State<HomeStudent> {
//   List<String> entries = [];
//   List<bool> pre_approvals = [];
//   List<Color?> inkColors = [
//     Colors.lightGreenAccent[200],
//     Colors.cyanAccent[100],
//     Colors.orangeAccent[100],
//     Colors.red[300],
//   ];
//
//   // List<String> entries = databaseInterface.getLoctions();
//   String welcome_message = "Welcome";
//
//   // Map<String, String> location_images_paths = databaseInterface.getLocationImagesPaths();
//   final List<String> location_images_paths =
//       databaseInterface.getLocationImagesPaths();
//   //final List<int> colorCodes = <int>[600, 500, 100,600, 500, 100,600, 500, 100,600, 500, 100,600, 500, 100,600, 500, 100,600, 500, 100,];
//
//   Future<void> get_welcome_message() async {
//     String welcome_message_local =
//         await databaseInterface.get_welcome_message(LoggedInDetails.getEmail());
//     // print("welcome_message_local: " + welcome_message_local);
//     setState(() {
//       welcome_message = welcome_message_local;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     get_welcome_message();
//     databaseInterface.getLoctionsAndPreApprovals().then((result) {
//       setState(() {
//         entries = result.locations;
//         pre_approvals = result.preApprovals;
//       });
//     });
//   }
//
//   Widget show_image(int index) {
//     if (index < 6) {
//       return Image.asset(location_images_paths[index]);
//     }
//     return Image.asset('assets/images/library.png');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   backgroundColor: Colors.pink,
//       //   // flexibleSpace: Container(
//       //   //   decoration: BoxDecoration(
//       //   //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
//       //   //       gradient: LinearGradient(
//       //   //           colors: [Colors.red,Colors.pink],
//       //   //           begin: Alignment.bottomCenter,
//       //   //           end: Alignment.topCenter
//       //   //       )
//       //   //   ),
//       //   // ),
//       //   title: Column(
//       //     children: [
//       //       Text(
//       //         'Student Home',
//       //         style: TextStyle(
//       //           color: Colors.grey[10],
//       //           fontWeight: FontWeight.bold,
//       //           fontStyle: FontStyle.italic,
//       //           fontFamily: 'Open Sans',
//       //           fontSize: 20,
//       //           // fontSize: 15,
//       //           // fontFamily: 'Raleway',
//       //         ),
//       //       ),
//       //       Text(
//       //         '${welcome_message}',
//       //         style: TextStyle(
//       //             color: Colors.grey[10],
//       //             fontWeight: FontWeight.w900,
//       //             fontStyle: FontStyle.italic,
//       //             fontFamily: 'Open Sans',
//       //             fontSize: 15
//       //             // fontSize: 15,
//       //             // fontFamily: 'Raleway',
//       //             ),
//       //       ),
//       //     ],
//       //   ),
//       //   // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
//       //   actions: [
//       //     PopupMenuButton<MenuItem>(
//       //       onSelected: (item) => onSelected(context, item),
//       //       itemBuilder: (context) => [
//       //         ...MenuItems.itemsFirst.map(buildItem).toList(),
//       //         PopupMenuDivider(),
//       //         ...MenuItems.itemsSecond.map(buildItem).toList(),
//       //       ],
//       //     ),
//       //   ],
//       // ),
//       body: Container(
//         child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: []),
//       // body: Container(
//       //   decoration: BoxDecoration(
//       //     gradient: LinearGradient(
//       //         begin: Alignment.topCenter,
//       //         end: Alignment.bottomCenter,
//       //         colors: [Colors.white, Colors.purple]),
//       //   ),
//       //   // color: Colors.bla,
//       //   child: GridView.builder(
//       //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       //       crossAxisCount:
//       //           MediaQuery.of(context).orientation == Orientation.landscape
//       //               ? 3
//       //               : 2,
//       //       //crossAxisCount: 3,
//       //       crossAxisSpacing: 8,
//       //       mainAxisSpacing: 8,
//       //       childAspectRatio: (1.2 / 1),
//       //       // childAspectRatio: 3 / 2,
//       //       // crossAxisSpacing: 100,
//       //       // mainAxisSpacing: 100,
//       //       // crossAxisCount: 2,
//       //     ),
//       //     //primary: false,
//       //     //padding: const EdgeInsets.all(20),
//       //     //crossAxisSpacing: 10,
//       //     //mainAxisSpacing: 2,
//
//       //     itemCount: entries.length,
//       //     itemBuilder: (BuildContext context, int index) {
//       //       return InkWell(
//       //         onTap: () {
//       //           // print("Email fetched from our own function: " + LoggedInDetails.getEmail());
//       //           if (pre_approvals[index] == true) {
//       //             Navigator.push(
//       //                 context,
//       //                 MaterialPageRoute(
//       //                   // builder: (context) => StudentTicketTable(
//       //                   //   location: entries[index],
//       //                   // ),
//       //                   builder: (context) => RaiseTicketForGuardOrAuthorities(
//       //                     location: entries[index],
//       //                     // TODO: fetch pre_approval_required from backend
//       //                     pre_approval_required: pre_approvals[index],
//       //                   ),
//       //                   // builder: (context) => EnterLocation(
//       //                   //       location: entries[index],
//       //                   //     )
//       //                 ));
//       //           } else {
//       //             Navigator.push(
//       //                 context,
//       //                 MaterialPageRoute(
//       //                     builder: (context) => StudentTabs(
//       //                           location: entries[index],
//       //                           pre_approval_required: pre_approvals[index],
//       //                         )));
//       //           }
//       //         },
//       //         child: Container(
//       //           height: 60,
//       //           width: 40,
//       //           //margin: EdgeInsets.only(bottom: 20),
//       //           margin: EdgeInsets.all(20),
//       //           decoration: BoxDecoration(
//       //             color: inkColors[index % inkColors.length],
//       //             borderRadius: BorderRadius.only(
//       //                 topLeft: Radius.circular(10),
//       //                 topRight: Radius.circular(10),
//       //                 bottomLeft: Radius.circular(10),
//       //                 bottomRight: Radius.circular(10)),
//       //             boxShadow: [
//       //               BoxShadow(
//       //                 // color: inkColors[index % inkColors.length].withOpacity(0.5),
//       //                 color: Colors.grey.withOpacity(0.6),
//       //                 spreadRadius: 5,
//       //                 blurRadius: 7,
//       //                 offset: Offset(0, 3), // changes position of shadow
//       //               ),
//       //             ],
//       //           ),
//       //           // decoration: BoxDecoration(
//       //           //   shape: BoxShape.rectangle,
//       //           //   color: Colors.blue[100 * (index % 3 + 1)],
//       //           //   borderRadius: BorderRadius.circular(20),
//       //           // ),
//       //           //color: Colors.amber[colorCodes[index]],
//       //           child: Column(
//       //             children: [
//       //               FittedBox(
//       //                 child: Container(
//       //                   margin: EdgeInsets.all(20),
//       //                   height: 50,
//       //                   // child: Image.asset(location_images_paths[index]),
//       //                   child: show_image(index),
//       //                 ),
//       //                 fit: BoxFit.fill,
//       //               ),
//       //               Center(
//       //                   child: Text(
//       //                 '${entries[index]}',
//       //                 style: GoogleFonts.roboto(
//       //                   fontSize: 15,
//       //                   fontWeight: FontWeight.bold,
//       //                   color: Colors.blue,
//       //                 ),
//       //               )),
//       //             ],
//       //           ),
//       //         ),
//       //       );
//       //     },
//       //     // separatorBuilder: (BuildContext context, int index) =>
//       //     //     const Divider(),
//       //   ),
//       // ),
//     );
//   }
//
//   // Function for Popup Menu Items
//   PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
//         value: item,
//         child: Row(
//           children: [
//             Icon(item.icon, size: 20),
//             const SizedBox(width: 12),
//             Text(item.text),
//           ],
//         ),
//       );
//
//   void onSelected(BuildContext context, MenuItem item) {
//     switch (item) {
//       case MenuItems.itemProfile:
//         Navigator.of(context).push(
//           // MaterialPageRoute(builder: (context) => ProfileController()),
//           MaterialPageRoute(
//               builder: (context) => ProfilePage(
//                   email: LoggedInDetails.getEmail(), isEditable: true)),
//         );
//         break;
//       case MenuItems.itemLogOut:
//         LoggedInDetails.setEmail("");
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => AuthScreen()),
//         );
//         break;
//     }
//   }
// }
