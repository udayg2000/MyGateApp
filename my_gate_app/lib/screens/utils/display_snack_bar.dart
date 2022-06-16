import 'package:flutter/material.dart';
import 'package:my_gate_app/screens/utils/custom_snack_bar.dart';

// class SnackBarPage extends StatelessWidget {
//   const SnackBarPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             final snackBar = SnackBar(
//               content: const Text('Yay! A SnackBar!'),
//               action: SnackBarAction(
//                 label: 'Undo',
//                 onPressed: () {
//                   // Some code to undo the change.
//                 },
//               ),
//             );
//
//             // Find the ScaffoldMessenger in the widget tree
//             // and use it to show a SnackBar.
//             ScaffoldMessenger.of(context).showSnackBar(snackBar);
//           },
//           child: const Text('Show SnackBar'),
//         ),
//       ),
//     );
//   }
// }

class SnackBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Raised button
        child: RaisedButton(
          color: Colors.green,
          onPressed: () {
            // when raised button is pressed
            // snackbar will appear from bottom of screen
            final snackBar = get_snack_bar("this is a snackbar", Colors.red);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Text('Display SnackBar'),
        ),
      ),
    );
  }
}
