// ignore_for_file: non_constant_identifier_names, await_only_futures, avoid_print

import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_interface.dart';
import 'package:my_gate_app/get_email.dart';
import 'package:my_gate_app/screens/profile2/widget/image_from_gallery_ex.dart';
import 'package:path/path.dart';
import 'package:my_gate_app/screens/profile2/model/user.dart';
import 'package:my_gate_app/screens/profile2/utils/user_preferences.dart';
import 'package:my_gate_app/screens/profile2/widget/appbar_widget.dart';
import 'package:my_gate_app/screens/profile2/widget/button_widget.dart';
import 'package:my_gate_app/screens/profile2/widget/profile_widget.dart';
import 'package:my_gate_app/screens/profile2/widget/textfield_widget.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String? email;
  const EditProfilePage({Key? key, required this.email}) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user = UserPreferences.myUser;

  var _image;
  var imagePicker;
  late String imagePath;

  late final TextEditingController controller_name;
  late final TextEditingController controller_email;
  late final TextEditingController controller_phone;
  late final TextEditingController controller_department;
  late final TextEditingController controller_year_of_entry;
  late final TextEditingController controller_degree;

  @override
  void initState() {
    super.initState();
    String? curr_email = widget.email;
    print("Current Email: " + curr_email.toString());
    controller_name = TextEditingController();
    controller_email = TextEditingController();
    controller_phone = TextEditingController();
    controller_department = TextEditingController();
    controller_year_of_entry = TextEditingController();
    controller_degree = TextEditingController();
    imagePicker = new ImagePicker();
    databaseInterface db = new databaseInterface();
    db.get_student_by_email(curr_email).then((User result) {
      setState(() {
        user = result;
        controller_name.text = user.name;
        controller_email.text = user.email;
        controller_phone.text = user.phone;
        controller_department.text = user.department;
        controller_year_of_entry.text = user.year_of_entry;
        controller_degree.text = user.degree;
        imagePath = user.imagePath;
        print("Result Name in Edit Profile Page" + result.name);
        print("Image path: " + user.imagePath);
      });
    });
    print("User Name in Edit Profile Page" + user.name);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: buildAppBar(context),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          physics: BouncingScrollPhysics(),
          children: [
            // ProfileWidget(
            //   imagePath: user.imagePath,
            //   isEdit: true,
            //   onClicked: () async {
            //       print("edit profile page image clicked");
            //        var source = ImageSource.gallery;
            //       XFile image = await imagePicker.pickImage(
            //           source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
            //       setState(() {
            //         _image = File(image.path);
            //       });
            //   },
            // ),

            // ProfileImage(context),
            ////////////////
            ImageWidget(imagePath: imagePath),

            // ////////////

            const SizedBox(height: 24),
            builText(controller_name, "Name", false, 1),

            const SizedBox(height: 24),
            builText(controller_email, "Email", false, 1),

            const SizedBox(height: 24),
            builText(controller_phone, "Phone", true, 1),

            const SizedBox(height: 24),
            builText(controller_department, "Department", false, 1),

            const SizedBox(height: 24),
            builText(controller_degree, "Degree", false, 1),

            const SizedBox(height: 24),
            builText(controller_year_of_entry, "Year of Entry", false, 1),
          ],
        ),
      );

  Widget builText(TextEditingController controller, String label,
          final bool enabled, int maxLines) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            enabled: enabled,
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: maxLines,
          ),
        ],
      );

  Widget ProfileImage(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(this.user.imagePath);
    // final image =imagePath;
    // final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          // image: AssetImage(image),
          image: image,
          fit: BoxFit.cover,
          width: 180,
          height: 180,
          child: InkWell(onTap: () async {
            print("edit profile page image clicked");
            var source = ImageSource.gallery;
            // XFile image = await imagePicker.pickImage(
            //     source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
            XFile image = await imagePicker.pickImage(source: source);
            await databaseInterface.send_image(
                image,
                "/students/change_profile_of_student",
                LoggedInDetails.getEmail());
            print("Image path:" + image.path);
            setState(() {
              _image = File(image.path);
            });
          }),
        ),
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

class ImageWidget extends StatefulWidget {
  String imagePath;
  ImageWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  var imagePicker;
  var pic;

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
    // test_function(widget.imagePath);
    print("image path in image widget: " + widget.imagePath);
    setState(() {
      pic = NetworkImage(widget.imagePath);
    });
  }

  Future<void> new_function() async {
    print("edit profile page image clicked 2");
    var source = ImageSource.gallery;
    // XFile image = await imagePicker.pickImage(
    //     source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
    XFile image = await imagePicker.pickImage(source: source);
    await databaseInterface.send_image(image,
        "/students/change_profile_of_student", LoggedInDetails.getEmail());
    print("Image path after picking the image:" + image.path);
    // setState((){
    //   _image = File(image.path);
    // });

    databaseInterface db = new databaseInterface();
    // await db
    //     .get_student_by_email(LoggedInDetails.getEmail())
    //     .then((User result) {
    //   setState(() {
    //     widget.imagePath = result.imagePath;
    //     print("Image path updated");
    //     pic = NetworkImage(widget.imagePath);
    //   });
    User result = await db.get_student_by_email(LoggedInDetails.getEmail());
    print("Updated path before call to test_function: " + result.imagePath);

    print("inside test_function, the value of image_path_:" + result.imagePath);
    var pic_local = await NetworkImage(result.imagePath);
    setState(() {
      pic = pic_local;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  new_function();
                }),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(Theme.of(context).colorScheme.primary),
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
