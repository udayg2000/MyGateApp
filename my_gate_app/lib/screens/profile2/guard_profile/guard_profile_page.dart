import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/screens/profile2/guard_profile/guard_edit_profile_page.dart';
import 'package:my_gate_app/screens/profile2/model/user.dart';
import 'package:my_gate_app/screens/profile2/utils/user_preferences.dart';
import 'package:my_gate_app/screens/profile2/widget/appbar_widget.dart';
import 'package:my_gate_app/screens/profile2/widget/button_widget.dart';
import 'package:my_gate_app/screens/profile2/widget/profile_widget.dart';
import 'package:my_gate_app/screens/profile2/edit_profile_page.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:my_gate_app/screens/profile2/widget/textfield_widget.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/profile2/model/user.dart';


class GuardProfilePage extends StatefulWidget {
  final String? email;
  const GuardProfilePage({Key? key, required this.email}): super(key: key);
  @override
  _GuardProfilePageState createState() => _GuardProfilePageState();
}

class _GuardProfilePageState extends State<GuardProfilePage> {
  var user = UserPreferences.myGuardUser;

  late String imagePath;

  late final TextEditingController controller_location;
  
  var imagePicker;
  var pic;

  Future<void> init() async {
    String? curr_email = widget.email;
    print("Current Email: " + curr_email.toString());
    databaseInterface db = new databaseInterface();
    GuardUser result = await db.get_guard_by_email(curr_email);
    print("result obj image path" + result.imagePath);
    
    setState(() {
      user = result;  
      controller_location.text = user.location;
      imagePath = user.imagePath;
      print("Result Name in Profile Page" + result.name);
    });


    setState(() {
      pic = NetworkImage(this.imagePath);
    });
  }

  @override
  void initState(){
    super.initState();
    // String? curr_email = LoggedInDetails.getEmail();
    String? curr_email = widget.email;
    print("Current Email: " + curr_email.toString());
    controller_location = TextEditingController();

    imagePath = UserPreferences.myGuardUser.imagePath;
    pic = NetworkImage(this.imagePath);
    imagePicker = new ImagePicker();
    
    init();
    print("User Name in Profile Page" + user.name);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          appBar: buildAppBar(context),
          backgroundColor: Colors.white,
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 32),
            physics: BouncingScrollPhysics(),
            children: [
              ImageWidget(),
              const SizedBox(height: 24),
              buildName(user),
              const SizedBox(height: 24),
                builText(controller_location,"Location Allocated", false,1),
                
            ],
          ),
        );
  }

  Widget buildName(GuardUser user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24,color: Color(int.parse("0xFF344953"))),
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
              disabledBorder: OutlineInputBorder(
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
    var source = ImageSource.gallery;
    XFile image = await imagePicker.pickImage(source: source);

    var widget_email = widget.email;
    if (widget_email!= null){
      await databaseInterface.send_image(image,
          "/guards/change_profile_picture_of_guard", widget_email);
    }

    databaseInterface db = new databaseInterface();
    GuardUser result = await db.get_guard_by_email(widget_email);

    var pic_local = await NetworkImage(result.imagePath);
    setState(() {
      pic = pic_local;
    });
  }

  Widget ImageWidget() {
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