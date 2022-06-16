// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/student/student_guard_side/student_status.dart';

class StreamStudentStatus extends StatefulWidget {
  const StreamStudentStatus({
    Key? key,
    required this.location,
    required this.pre_approval_required,
  }) : super(key: key);
  final String location;
  final bool pre_approval_required;

  @override
  State<StreamStudentStatus> createState() => _StreamStudentStatusState();
}

class _StreamStudentStatusState extends State<StreamStudentStatus> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseInterface.get_student_status(LoggedInDetails.getEmail(), widget.location),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return const Text("Error",
                  style: TextStyle(fontSize: 24, color: Colors.red));
            } else {
              ResultObj3 data = snapshot.data as ResultObj3;
              String in_or_out = data.in_or_out;
              String inside_parent_location = data.inside_parent_location;
              String exited_all_children = data.exited_all_children;
              // print("in_or_out: " + in_or_out);
              // print("inside_parent_location: " + inside_parent_location);
              // print("exited_all_children: " + exited_all_children);

              return StudentStatus(
                location: widget.location,
                in_or_out: in_or_out,
                inside_parent_location: inside_parent_location,
                exited_all_children: exited_all_children,
                pre_approval_required: widget.pre_approval_required,
              );
            }
        }
      },
    );
  }
}
