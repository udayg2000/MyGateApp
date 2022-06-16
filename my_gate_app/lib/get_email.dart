// import 'package:firebase_auth/firebase_auth.dart';

// String? getLoggedInPersonEmail(){
//   String? currentUserMail = null;
//   var currentUser = FirebaseAuth.instance.currentUser;
//   if (currentUser != null) {
//     if (currentUser.email != null){
//       currentUserMail = currentUser.email.toString();
//     }
//   }
//   return currentUserMail;
// }

class LoggedInDetails{
  static String email = "";

  static String getEmail(){
    return email;
  }

  static void setEmail(String email){
    LoggedInDetails.email = email;
  }

}
