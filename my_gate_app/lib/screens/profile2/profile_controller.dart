import 'package:animated_theme_switcher/animated_theme_switcher.dart';
// import 'package:theme_provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/profile2/profile_page.dart';
import 'package:my_gate_app/screens/profile2/themes.dart';
import 'package:my_gate_app/screens/profile2/utils/user_preferences.dart';

/* class ProfileController extends StatefulWidget {
  const ProfileController({ Key? key }) : super(key: key);

  @override
  State<ProfileController> createState() => _ProfileControllerState();
}

class _ProfileControllerState extends State<ProfileController> {
  static final String title = 'User Profile';
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;
    return ThemeProvider(
      initTheme: user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
      child: Builder(
        builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          // theme: ThemeProvider.themeOf(context).data,
          // theme: ThemeProvider.themeOf(context).data,
          title: title,
          home: ProfilePage(),
        ),
      ),
    );
  }
} */

class ProfileController extends StatelessWidget {
  static final String title = 'User Profile';

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;

    return ThemeProvider(
      initTheme: user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
      // child: Builder(
        builder: (context,MyThemes) => MaterialApp(
          debugShowCheckedModeBanner: false,
          // theme: ThemeProvider.of(context),
          theme: MyThemes,
          title: title,
          home: ProfilePage(email: LoggedInDetails.getEmail(), isEditable: true),
        ),
      // ),
    );
  }
}
