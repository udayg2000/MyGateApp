// void _showAlert(BuildContext context) {
//   showGeneralDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierLabel:
//       MaterialLocalizations.of(context).modalBarrierDismissLabel,
//   transitionDuration: const Duration(milliseconds: 200),
//   pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
//   return Material(
//   type: MaterialType.transparency,
//   child: WillPopScope(
//   onWillPop: () async => false,
//   child: Container(
//   width: MediaQuery.of(context).size.width — 40,
//   height: MediaQuery.of(context).size.height / 9,
//   padding: const EdgeInsets.all(5),
//   child: Container()),
//   ),
//   );