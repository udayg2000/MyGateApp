import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key, required this.submit_function, required this.button_text}) : super(key: key);
  final void Function() submit_function;
  final String button_text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            //color: Colors.green,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    // ignore: prefer_const_literals_to_create_immutables
                    colors: [
                      Color.fromRGBO(255, 143, 158, 1),
                      Color.fromRGBO(255, 188, 143, 1),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    shape: MaterialStateProperty.all<
                        RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: Colors.blue)))),
                onPressed: () {
                  this.submit_function();
                },
                child: FittedBox(
                  child: Container(
                      margin: EdgeInsets.all(30),
                      height: 100,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text(this.button_text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 50),)
                    //Image.asset("images/enter_button.png"),
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          // Text(
          //   this.enter_message,
          //   style: TextStyle(color: Colors.white),
          // ),
        ],
      ),
    );
  }
}