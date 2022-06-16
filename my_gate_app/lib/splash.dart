import 'package:flutter/material.dart';

import 'auth/authscreen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AuthScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/splash.png',
                height: 150,
              ),
          ],
        ),
      ),
    );
    return Scaffold(
      body: Container(
        color: Colors.black,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash.jpg"),
            // fit: BoxFit.cover,
          ),
        ),
        // child: Text(
        //   "My Gate",
        //   style: TextStyle(
        //     // fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ) /* add child content here */,
      ),
    );
    // return Scaffold(
    //   body: Center(
    //     child: Container(
    //       child: Text(
    //         'My Gate',
    //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //       ),
    //     ),
    //   ),
    // );
  }
}
