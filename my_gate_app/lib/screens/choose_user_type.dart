import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/screens/admin/home_admin.dart';
import 'package:my_gate_app/screens/guard/home_guard.dart';
import 'package:my_gate_app/screens/student/home_student.dart';


class ChooseUser extends StatefulWidget {
  const ChooseUser({Key? key}) : super(key: key);

  @override
  _ChooseUserState createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {
  final List<String> entries = databaseInterface.getUserTypes();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose User Type'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
      ),
      body: Container(
        color: Colors.black38,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 3
                    : 2,
            //crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: (2 / 1),
            // childAspectRatio: 3 / 2,
            // crossAxisSpacing: 100,
            // mainAxisSpacing: 100,
            // crossAxisCount: 2,
          ),
          //primary: false,
          //padding: const EdgeInsets.all(20),
          //crossAxisSpacing: 10,
          //mainAxisSpacing: 2,

          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                if (entries[index].toLowerCase() == 'student') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeStudent()));
                }else if(entries[index].toLowerCase() == 'guard'){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeGuard()));
                      // MaterialPageRoute(builder: (context) => ProfileController()));
                      // MaterialPageRoute(builder: (context) => StudentTicketTable()));
                }else if(entries[index].toLowerCase() == 'admin'){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeAdmin()));
                }
              },
              child: Container(
                height: 50,
                width: 30,
                //margin: EdgeInsets.only(bottom: 20),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.blue[100 * (index % 3 + 1)],
                  borderRadius: BorderRadius.circular(20),
                ),
                //color: Colors.amber[colorCodes[index]],
                child: Center(
                    child: Text(
                  '${entries[index]}',
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
              ),
            );
          },
          // separatorBuilder: (BuildContext context, int index) =>
          //     const Divider(),
        ),
      ),
    );
  }
}
