import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_gate_app/screens/admin/utils/file_upload_button.dart';

class UploadInvalidEmail extends StatefulWidget {
  const UploadInvalidEmail({Key? key}) : super(key: key);

  @override
  _UploadInvalidEmailState createState() => _UploadInvalidEmailState();
}

class _UploadInvalidEmailState extends State<UploadInvalidEmail> {
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
            color: Colors.amber,
            child:Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Upload excel file having student emails to be disabled",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 50,
                ),
                FileUploadButton(url_upload_file: "http://127.0.0.1:8000/delete_students_from_file"),
              ],
            )
        )
    );
  }
}
