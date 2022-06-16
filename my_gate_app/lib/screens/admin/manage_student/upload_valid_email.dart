// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_gate_app/screens/admin/utils/file_upload_button.dart';

class UploadValidEmail extends StatefulWidget {
  const UploadValidEmail({Key? key}) : super(key: key);

  @override
  _UploadValidEmailState createState() => _UploadValidEmailState();
}

class _UploadValidEmailState extends State<UploadValidEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Manage Student'),
        //   actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
        // ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.lightGreenAccent,
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Upload excel file having valid student emails",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 50,
                ),
                FileUploadButton(url_upload_file: "http://127.0.0.1:8000/add_students_from_file"),
              ],
            )));
  }
}
