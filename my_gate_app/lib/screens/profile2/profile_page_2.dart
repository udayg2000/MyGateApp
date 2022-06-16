import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/screens/profile2/edit_profile_page.dart';
import 'package:my_gate_app/screens/profile2/model/user.dart';
import 'package:my_gate_app/screens/profile2/utils/user_preferences.dart';
import 'package:my_gate_app/screens/profile2/widget/appbar_widget.dart';
import 'package:my_gate_app/screens/profile2/widget/button_widget.dart';
import 'package:my_gate_app/screens/profile2/widget/profile_widget.dart';
// import 'package:my_gate_app/screens/profile2/edit_profile_page.dart';
// import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:my_gate_app/screens/profile2/widget/textfield_widget.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/profile2/model/user.dart';

class ProfilePage2 extends StatefulWidget {
  final String? email;
  final bool isEditable;
  const ProfilePage2({Key? key, required this.email, required this.isEditable}) : super(key: key);
  @override
  _ProfilePage2State createState() => _ProfilePage2State();
}

class _ProfilePage2State extends State<ProfilePage2> {
  var user = UserPreferences.myUser;

  late String imagePath;

  late final TextEditingController controller_phone;
  late final TextEditingController controller_department;
  late final TextEditingController controller_year_of_entry;
  late final TextEditingController controller_degree;

  var imagePicker;
  var pic;

  Future<void> init() async {
    String? curr_email = widget.email;
    print("Current Email: " + curr_email.toString());
    databaseInterface db = new databaseInterface();
    User result = await db.get_student_by_email(curr_email);
    print("result obj image path" + result.imagePath);
    setState(() {
      user = result;
      controller_phone.text = result.phone;
      controller_department.text = result.department;
      controller_year_of_entry.text = result.year_of_entry;
      controller_degree.text = result.degree;
      imagePath = result.imagePath;
      print("image path inside setstate: " + imagePath);
    });

    setState(() {
      pic = NetworkImage(this.imagePath);
    });
  }

  @override
  void initState() {
    super.initState();
    controller_phone = TextEditingController();
    controller_department = TextEditingController();
    controller_year_of_entry = TextEditingController();
    controller_degree = TextEditingController();

    imagePath = UserPreferences.myUser.imagePath;
    pic = NetworkImage(this.imagePath);
    imagePicker = new ImagePicker();
    // print("image path in image widget: " + this.imagePath);
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: Colors.white,
      // backgroundColor: Colors.black,
      appBar: buildAppBar(context),
      body: ListView(
          
          padding: EdgeInsets.symmetric(horizontal: 32),
          physics: BouncingScrollPhysics(),
          children: [
            ImageWidget(),
            const SizedBox(height: 24),
            buildName(user),
            const SizedBox(height: 24),
            builText(controller_phone, "Phone", false, 1),
            const SizedBox(height: 24),
            builText(controller_department, "Department", false, 1),
            const SizedBox(height: 24),
            builText(controller_degree, "Degree", false, 1),
            const SizedBox(height: 24),
            builText(controller_year_of_entry, "Year of Entry", false, 1),
          ],
        ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(int.parse("0xFF344953")) ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Color(int.parse("0xFF344953")).withOpacity(0.5)),
          )
        ],
      );

  Widget builText(TextEditingController controller, String label,
          final bool enabled, int maxLines) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(int.parse("0xFF344953"))),
          ),
          const SizedBox(height: 8),
          TextField(
            style: TextStyle(color: Color(int.parse("0xFF344953"))),
            enabled: enabled,
            controller: controller,
            
            decoration: InputDecoration(
              // fillColor: Colors.black,
              // filled: true,
              // enabledBorder: OutlineInputBorder(
              //   // borderSide: BorderSide(color: Color(int.parse("0xFF344953")), width: 1.0),
              //   borderSide: BorderSide(color: Colors.black, width: 2.0),
              //   borderRadius: BorderRadius.circular(12),
              // ),

              // focusedBorder: OutlineInputBorder(
              //   // borderSide: BorderSide(color: Color(int.parse("0xFF344953")), width: 1.0),
              //   borderSide: BorderSide(color: Colors.black, width: 2.0),
              //   borderRadius: BorderRadius.circular(12),
              // ),
              
              disabledBorder: OutlineInputBorder(
                // borderSide: BorderSide(color: Color(int.parse("0xFF344953")), width: 1.0),
                borderSide: BorderSide(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(12),
              ),
            
              labelStyle: TextStyle(
                color: Color(int.parse("0xFF344953")),
              ),
            ),


            maxLines: maxLines,
          ),
        ],
      );

  Future<void> pick_image() async {
    print("edit profile page image clicked 2");
    var source = ImageSource.gallery;
    XFile image = await imagePicker.pickImage(source: source);
    var widget_email = widget.email;
    if (widget_email!= null){
      await databaseInterface.send_image(image,
          "/students/change_profile_picture_of_student", widget_email);
    }

    databaseInterface db = new databaseInterface();
    User result = await db.get_student_by_email(widget.email);
    
    var pic_local = await NetworkImage(result.imagePath);
    setState(() {
      pic = pic_local;
    });
  }

  Widget ImageWidget() {
    if(widget.isEditable){
      return EditableProfilePage();
    }
    return ViewProfilePage();
  }

  Widget EditableProfilePage(){
    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Ink.image(
                // image: AssetImage(image),
                // image: NetworkImage(widget.imagePath),
                image: pic,
                fit: BoxFit.cover,
                width: 180,
                height: 180,
                child: InkWell(onTap: () async {
                  pick_image();
                }),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 4,
            // child: buildEditIcon(Theme.of(context).colorScheme.primary),
            child: buildEditIcon(Color(int.parse("0xFF344953"))),
          ),
        ],
      ),
    );
  }

  Widget ViewProfilePage(){
    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: Material(
              color: Colors.transparent,
              // color: Colors.blue,
              child: Ink.image(
                // image: AssetImage(image),
                // image: NetworkImage(widget.imagePath),
                image: pic,
                fit: BoxFit.cover,
                width: 180,
                height: 180,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 4,
            // child: buildEditIcon(Theme.of(context).colorScheme.primary),
            child: buildEditIcon(Color(int.parse("0xFF344953"))),
          ),
        ],
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
