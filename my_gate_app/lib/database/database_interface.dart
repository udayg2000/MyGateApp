// import 'dart:_http';

// ignore_for_file: non_constant_identifier_names, avoid_print, unused_local_variable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_gate_app/screens/profile2/utils/user_preferences.dart';
import 'package:my_gate_app/screens/profile2/model/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'database_objects.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class databaseInterface {
  static int REFRESH_RATE = 1;
  static int PORT_NO_static = 8000;

  static String complete_base_url_static =
      "http://127.0.0.1:" + PORT_NO_static.toString();
  
  
  // static String complete_base_url_static =
  //     "http://172.22.15.69:" + PORT_NO_static.toString();

  // static String complete_base_url_static =
  //     "http://172.26.13.125:" + PORT_NO_static.toString();

  // static String complete_base_url_static =
  //     "http://192.168.239.25:" + PORT_NO_static.toString();
  // static String complete_base_url_static =
  //     "http://192.168.56.1:" + PORT_NO_static.toString();

  // static String complete_base_url_static =
  //     "http://10.0.2.2:" + PORT_NO_static.toString();

  // static String complete_base_url_static = "https://mygateapp.herokuapp.com";

  databaseInterface() {}

  static Future<String> get_welcome_message(String email) async {
    var uri = complete_base_url_static + "/get_welcome_message";

    var url = Uri.parse(uri);
    try {
      var response = await http.post(url, body: {'email': email});
      var data = json.decode(response.body);
      String welcome_message = data['welcome_message'];
      return welcome_message;
    } catch (e) {
      print("Exception in get_welcome_message: " + e.toString());
      return "Welcome";
    }
  }

  static List<String> getLoctions() {
    // TODO: get this list from the backend
    final List<String> entries = <String>[
      'Main Gate',
      'Mess',
      'Library',
      'Hostel',
      'CS Lab',
      'CS Department'
    ];
    return entries;
  }

  static Future<List<String>> getLoctions2() async {
    List<String> blank_list = [];
    List<String> output = [];
    var url = complete_base_url_static + "/locations/get_all_locations";
    try {
      var response = await http.post(Uri.parse(url));
      print("********************************** response.body");
      print(response.body);

      var data = json.decode(response.body);
      for (var location in data['output']) {
        String location_name = location['location_name'];
        bool pre_approval = location['pre_approval'];
        output.add(location_name);
      }
      // print(locations);
      if (response.statusCode == 200) {
        return output;
      } else {
        return blank_list;
      }
    } catch (e) {
      print("Exception while getting locations");
      print(e.toString());
      return blank_list;
    }
  }

  static Future<LocationsAndPreApprovalsObjects>
      getLoctionsAndPreApprovals() async {
    LocationsAndPreApprovalsObjects blank_object =
        LocationsAndPreApprovalsObjects([], []);
    LocationsAndPreApprovalsObjects res =
        LocationsAndPreApprovalsObjects([], []);

    var url = complete_base_url_static + "/locations/get_all_locations";
    try {
      var response = await http.post(Uri.parse(url));
      print("********************************** response.body");
      print(response.body);

      var data = json.decode(response.body);
      for (var location in data['output']) {
        String location_name = location['location_name'];
        bool pre_approval = location['pre_approval'];
        res.locations.add(location_name);
        res.preApprovals.add(pre_approval);
      }
      // print(locations);
      if (response.statusCode == 200) {
        return res;
      } else {
        return blank_object;
      }
    } catch (e) {
      print("Exception while getting locations");
      print(e.toString());
      return blank_object;
    }
  }

  static Future<List<String>> get_all_guard_emails() async {
    List<String> blank_list = [];
    List<String> output = [];
    var url = complete_base_url_static + "/guards/get_all_guard_emails";
    try {
      var response = await http.post(Uri.parse(url));
      print("********************************** response.body");
      print(response.body);

      var data = json.decode(response.body);
      for (var guard_email in data['output']) {
        String _email = guard_email['email'];
        output.add(_email);
      }
      // print(locations);
      if (response.statusCode == 200) {
        return output;
      } else {
        return blank_list;
      }
    } catch (e) {
      print("Exception while getting Guards Email List");
      print(e.toString());
      return blank_list;
    }
  }

  static List<String> getGuardNames() {
    // TODO: get this list from the backend
    final List<String> entries = <String>[
      'Guard 1',
      'Guard 2',
      'Guard 3',
    ];
    return entries;
  }

  static List<String> getGuardLocations() {
    // TODO: get this list from the backend
    final List<String> entries = <String>[
      'Guard 1 Email',
      'Guard 2 Email',
      'Guard 3 Email',
      'abc@gmail.com',
    ];
    return entries;
  }

  static List<String> getLocationImagesPaths() {
    final List<String> entries = [
      'assets/images/gate.png',
      'assets/images/computer.png',
      'assets/images/mess.jpg',
      'assets/images/library2.jpg',
      'assets/images/hostel.png',
      'assets/images/lab.png',
    ];
    return entries;
  }

  static List<String> getUserTypes() {
    final List<String> entries = <String>['Student', 'Guard', 'Admin'];
    return entries;
  }

  static Future<LoginResultObj> login_user(
      String email, String password) async {
    var url = complete_base_url_static + "/login_user";
    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
        },
      );
      // 2019csb1107@iitrpr.ac.in
      // IIT_Ropar
      print("response body");
      print(response.body.toString());
      var data = json.decode(response.body);
      String person_type = data['person_type'];
      String message = data['message'];

      LoginResultObj res = new LoginResultObj(person_type, message);
      return res;
    } catch (e) {
      LoginResultObj res = new LoginResultObj("NA", "Internal Server Error");
      return res;
    }
  }

  static Future<List<String>> get_authorities_list() async {
    var url = complete_base_url_static + "/authorities/get_authorities_list";
    try {
      var response = await http.post(Uri.parse(url));
      var data = json.decode(response.body) as List;
      List<String> res = [];
      for (var i = 0; i < data.length; i++) {
        String obj = data[i]['authority_name'] +
            ", " +
            data[i]['authority_designation'] +
            "\n" +
            data[i]['email'];
        res.add(obj);
      }
      return res;
    } catch (e) {
      List<String> res = [];
      return res;
    }
  }

  // Called by the guard to get the list of entry numbers
  static Future<List<String>> get_list_of_entry_numbers(String route) async {
    var url = complete_base_url_static + "/"+route +"/get_list_of_entry_numbers";
    try {
      var response = await http.post(Uri.parse(url));
      var data = json.decode(response.body) as List;
      List<String> res = [];
      for (var i = 0; i < data.length; i++) {
        String obj = data[i]['entry_no'] + ", " + data[i]['st_name'] +"\n" + data[i]['email'];
        res.add(obj);
      }
      return res;
    } catch (e) {
      List<String> res = [];
      return res;
    }
  }

  static Future<List<String>> get_list_of_visitors() async {
    var url = complete_base_url_static + "/visitors/get_list_of_visitors";
    try {
      var response = await http.post(Uri.parse(url));
      var data = json.decode(response.body) as List;
      List<String> res = [];
      for (var i = 0; i < data.length; i++) {
        String obj = data[i]['mobile_no'] + ", " + data[i]['visitor_name'] +"\n";
        res.add(obj);
      }
      return res;
    } catch (e) {
      List<String> res = [];
      return res;
    }
  }

  static Future<List<String>> get_authority_tickets_with_status_accepted(
      String email, String location, String ticket_type) async {
    var url = complete_base_url_static +
        "/authorities/get_authority_tickets_with_status_accepted";
    try {
      var response = await http.post(Uri.parse(url), body: {
        "email": email,
        "location": location,
        "ticket_type": ticket_type,
      });
      var data = json.decode(response.body) as List;
      List<String> res = [];
      for (var i = 0; i < data.length; i++) {
        String obj = data[i]['authority_name'] +
            ", " +
            data[i]['authority_designation'] +
            "\n" +
            "authority_message: " +
            data[i]['authority_message'] +
            "\n" +
            "student_message:" +
            data[i]['student_message'] +
            "\n" +
            data[i]['ref_id'];
        res.add(obj);
      }
      print("res");
      print(res);

      return res;
    } catch (e) {
      // print(e.toString());
      List<String> res = [];
      return res;
    }
  }

  static Future<String> forgot_password(
      String email, int op, int entered_otp) async {
    var url = complete_base_url_static + "/forgot_password";
    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'op': op.toString(),
          'entered_otp': entered_otp.toString(),
        },
      );
      // respone.body.toString();
      var data = json.decode(response.body);
      String message = data['message'];
      return message;
    } catch (e) {
      print(e);
      return "Exception in forgot password";
    }
  }

  static Future<String> reset_password(String email, String password) async {
    var uri = complete_base_url_static + "/reset_password";
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'email': email,
          'password': password,
        },
      );
      var data = json.decode(response.body);
      String message = data['message'];
      return message;
    } catch (e) {
      print(e);
      return "Password RESET Failed";
    }
  }

  Future<int> insert_in_guard_ticket_table(
      String email,
      String location,
      String date_time,
      String ticket_type,
      String choosen_authority_ticket) async {
    var uri = complete_base_url_static + "/guards/insert_in_guard_ticket_table";
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'email': email,
          'location': location,
          'date_time': date_time,
          'ticket_type': ticket_type,
          'choosen_authority_ticket': choosen_authority_ticket,
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response.statusCode.toInt();
    } catch (e) {
      print("post request error");
      print(e.toString());
      return 500;
      // return Future.error(e);
    }
  }

  static Future<int> insert_in_authorities_ticket_table(
      String chosen_authority,
      String ticket_type,
      String student_message,
      String email,
      String date_time,
      String location) async {
    var uri = complete_base_url_static +
        "/authorities/insert_in_authorities_ticket_table";
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'chosen_authority': chosen_authority,
          'ticket_type': ticket_type,
          'student_message': student_message,
          'email': email,
          'date_time': date_time,
          'location': location,
        },
      );
      if (response.statusCode.toInt() == 200) {
        print("Ticket inserted into authorities ticket table");
      } else {
        print("Failed to insert ticket into authorities ticket table");
      }
      return response.statusCode.toInt();
      // return response.statusCode.toInt();
    } catch (e) {
      print(
          "Failed to insert ticket into authorities ticket table, exception: " +
              e.toString());
      return 500;
    }
  }

  // TODO: Add data type of variable student_list
  void change_ticket_status(student_list) async {
    print("Change Ticket Status on DB called");
    var uri = complete_base_url_static + "/students/approve_selected_tickets";
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {"data": student_list},
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print("post request error");
      print(e.toString());
      // return Future.error(e);
    }
  }

  // This fetches guard tickets
  static Stream<List<ResultObj>> get_tickets_for_student(
          String email, String location) =>
      Stream.periodic(Duration(seconds: REFRESH_RATE))
          .asyncMap((_) => get_tickets_for_student_util(email, location));

  // This fetches guard tickets
  static Future<List<ResultObj>> get_tickets_for_student_util(
      String email, String location) async {
    var uri = complete_base_url_static + "/students/get_tickets_for_student";
    try {
      var response = await http
          .post(Uri.parse(uri), body: {'email': email, 'location': location});
      List<ResultObj> tickets_list = (json.decode(response.body) as List)
          .map((i) => ResultObj.fromJson1(i))
          .toList();

      if (response.statusCode == 200) {
        return tickets_list;
      } else {
        print("Server Error");
        List<ResultObj> tickets_list = [];
        return tickets_list;
      }
    } catch (e) {
      List<ResultObj> tickets_list = [];
      return tickets_list;
    }
  }

  static Stream<List<ResultObj>> get_authority_tickets_for_student(
          String email, String location) =>
      Stream.periodic(Duration(seconds: REFRESH_RATE)).asyncMap(
          (_) => get_authority_tickets_for_student_util(email, location));

  static Future<List<ResultObj>> get_authority_tickets_for_student_util(
      String email, String location) async {
    var uri = complete_base_url_static +
        "/students/get_authority_tickets_for_students";
    try {
      var response = await http
          .post(Uri.parse(uri), body: {'email': email, 'location': location});
      List<ResultObj> tickets_list = (json.decode(response.body) as List)
          .map((i) => ResultObj.fromJson1(i))
          .toList();

      if (response.statusCode == 200) {
        return tickets_list;
      } else {
        print("Server Error");
        List<ResultObj> tickets_list = [];
        return tickets_list;
      }
    } catch (e) {
      List<ResultObj> tickets_list = [];
      return tickets_list;
    }
  }

  static Stream<List<ResultObj>> get_pending_tickets_for_guard_stream(
          String location) =>
      Stream.periodic(Duration(seconds: REFRESH_RATE))
          .asyncMap((_) => get_pending_tickets_for_guard_stream_util(location));

  static Future<List<ResultObj>> get_pending_tickets_for_guard_stream_util(
      String location) async {
    var uri =
        complete_base_url_static + "/guards/get_pending_tickets_for_guard";
    try {
      var response =
          await http.post(Uri.parse(uri), body: {'location': location});
      // print("response.body");
      // print(response.body);
      List<ResultObj> pending_tickets_list =
          (json.decode(response.body) as List)
              .map((i) => ResultObj.fromJson1(i))
              .toList();

      if (response.statusCode == 200) {
        return pending_tickets_list;
      } else {
        print("Server Error in get_pending_tickets_for_guard_stream_util");
        List<ResultObj> pending_tickets_list = [];
        return pending_tickets_list;
      }
    } catch (e) {
      print("Exception while getting pending tickets for guard stream util");
      print(e.toString());
      List<ResultObj> pending_tickets_list = [];
      return pending_tickets_list;
    }
  }

  static Future<List<ResultObj>> get_pending_tickets_for_guard(
      String location, String enter_exit) async {
    var uri =
        complete_base_url_static + "/guards/get_pending_tickets_for_guard";
    try {
      var response =
          await http.post(Uri.parse(uri), body: {'location': location, 'enter_exit':enter_exit});
      // print("response.body");
      // print(response.body);
      List<ResultObj> pending_tickets_list =
          (json.decode(response.body) as List)
              .map((i) => ResultObj.fromJson1(i))
              .toList();

      if (response.statusCode == 200) {
        return pending_tickets_list;
      } else {
        print("Server Error in get_pending_tickets_for_guard");
        List<ResultObj> pending_tickets_list = [];
        return pending_tickets_list;
      }
    } catch (e) {
      print("Exception while getting pending tickets for guard" + e.toString());
      List<ResultObj> pending_tickets_list = [];
      return pending_tickets_list;
    }
  }

  // To get visitor tickets on the guard side
  static Future<List<ResultObj4>> get_pending_tickets_for_visitors(
      String enter_exit) async {
    var uri =
        complete_base_url_static + "/visitors/get_pending_tickets_for_visitors";
    try {
      var response =
          await http.post(Uri.parse(uri), body: {'enter_exit': enter_exit});

      List<ResultObj4> pending_tickets_list =
          (json.decode(response.body) as List)
              .map((i) => ResultObj4.fromJson2(i))
              .toList();
          
      if (response.statusCode == 200) {
        return pending_tickets_list;
      } else {
        print("Server Error in get_pending_tickets_for_visitors");
        List<ResultObj4> pending_tickets_list = [];
        return pending_tickets_list;
      }
    } catch (e) {
      print("Exception in get_pending_tickets_for_visitors: " + e.toString());
      List<ResultObj4> pending_tickets_list = [];
      return pending_tickets_list;
    }
  }

  // To get pending visitor tickets on the authority side
  static Future<List<ResultObj4>> get_pending_visitor_tickets_for_authorities(
      String authority_email) async {
    var uri =
        complete_base_url_static + "/visitors/get_pending_visitor_tickets_for_authorities";
    try {
      var response =
          await http.post(Uri.parse(uri), body: {'authority_email': authority_email});
      List<ResultObj4> pending_tickets_list =
          (json.decode(response.body) as List)
              .map((i) => ResultObj4.fromJson2(i))
              .toList();
          
      if (response.statusCode == 200) {
        return pending_tickets_list;
      } else {
        print("Server Error in get_pending_visitor_tickets_for_authorities");
        List<ResultObj4> pending_tickets_list = [];
        return pending_tickets_list;
      }
    } catch (e) {
      print("Exception in get_pending_visitor_tickets_for_authorities: " + e.toString());
      List<ResultObj4> pending_tickets_list = [];
      return pending_tickets_list;
    }
  }

  // To get past visitor tickets on the authority side
  static Future<List<ResultObj4>> get_past_visitor_tickets_for_authorities(
      String authority_email) async {
    var uri =
        complete_base_url_static + "/visitors/get_past_visitor_tickets_for_authorities";
    try {
      var response =
          await http.post(Uri.parse(uri), body: {'authority_email': authority_email});
      List<ResultObj4> pending_tickets_list =
          (json.decode(response.body) as List)
              .map((i) => ResultObj4.fromJson2(i))
              .toList();
          
      if (response.statusCode == 200) {
        return pending_tickets_list;
      } else {
        print("Server Error in get_past_visitor_tickets_for_authorities");
        List<ResultObj4> pending_tickets_list = [];
        return pending_tickets_list;
      }
    } catch (e) {
      print("Exception in get_past_visitor_tickets_for_authorities: " + e.toString());
      List<ResultObj4> pending_tickets_list = [];
      return pending_tickets_list;
    }
  }

  static Future<List<ResultObj2>> get_pending_tickets_for_authorities(
      String authority_email) async {
    var uri = complete_base_url_static +
        "/authorities/get_pending_tickets_for_authorities";
    try {
      var response = await http
          .post(Uri.parse(uri), body: {'authority_email': authority_email});
      // print("response.body");
      // print(response.body);
      List<ResultObj2> pending_tickets_list =
          (json.decode(response.body) as List)
              .map((i) => ResultObj2.fromJson1(i))
              .toList();

      if (response.statusCode == 200) {
        return pending_tickets_list;
      } else {
        print("Server Error in get_pending_tickets_for_authorities");
        List<ResultObj2> pending_tickets_list = []; // return empty list
        return pending_tickets_list;
      }
    } catch (e) {
      print("Exception while get_pending_tickets_for_authorities");
      print("The exception is " + e.toString());
      List<ResultObj2> pending_tickets_list = []; // return empty list
      return pending_tickets_list;
    }
  }

  static Stream<List<ResultObj>> get_tickets_for_guard_stream(String location, String is_approved, String enter_exit) =>
      Stream.periodic(Duration(seconds: REFRESH_RATE)).asyncMap((_) => get_tickets_for_guard_stream_util(location, is_approved, enter_exit));

  static Future<List<ResultObj>> get_tickets_for_guard_stream_util(String location, String is_approved, String enter_exit) async {
    var uri = complete_base_url_static + "/guards/get_tickets_for_guard";
    try {
      var response = await http.post(
                                  Uri.parse(uri),
                                  body: {'location': location, 
                                          'is_approved': is_approved, 
                                          'enter_exit': enter_exit
                                        }
                            );

      List<ResultObj> tickets_list = (json.decode(response.body) as List)
          .map((i) => ResultObj.fromJson1(i))
          .toList();

      if (response.statusCode == 200) {
        return tickets_list;
      } else {
        print("Server Error in get_tickets_for_guard_stream_util");
        List<ResultObj> tickets_list = [];
        return tickets_list;
      }
    } catch (e) {
      print("Exception while get_tickets_for_guard_stream_util");
      print(e.toString());
      List<ResultObj> tickets_list = [];
      return tickets_list;
    }
  }

  static Stream<List<ResultObj2>> get_tickets_for_authorities_stream(
          String authority_email, String is_approved) =>
      Stream.periodic(Duration(seconds: REFRESH_RATE)).asyncMap((_) =>
          get_tickets_for_authorities_stream_util(
              authority_email, is_approved));

  static Future<List<ResultObj2>> get_tickets_for_authorities_stream_util(
      String authority_email, String is_approved) async {
    var uri =
        complete_base_url_static + "/authorities/get_tickets_for_authorities";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        'authority_email': authority_email,
        'is_approved': is_approved
      });

      List<ResultObj2> tickets_list = (json.decode(response.body) as List)
          .map((i) => ResultObj2.fromJson1(i))
          .toList();

      if (response.statusCode == 200) {
        return tickets_list;
      } else {
        print("Server Error in get_tickets_for_authorities_stream_util");
        List<ResultObj2> tickets_list = [];
        return tickets_list;
      }
    } catch (e) {
      // print("Exception while get_tickets_for_authorities_stream_util: " + e.toString());
      List<ResultObj2> tickets_list = [];
      return tickets_list;
    }
  }

  static Future<List<ResultObj>> get_tickets_for_guard(
      String location, String is_approved) async {
    var uri = complete_base_url_static + "/guards/get_tickets_for_guard";
    try {
      var response = await http.post(Uri.parse(uri),
          body: {'location': location, 'is_approved': is_approved});
      // print("response.body");
      // print(response.body);
      List<ResultObj> tickets_list = (json.decode(response.body) as List)
          .map((i) => ResultObj.fromJson1(i))
          .toList();

      if (response.statusCode == 200) {
        return tickets_list;
      } else {
        print("Server Error in get_tickets_for_guard");
        List<ResultObj> tickets_list = [];
        return tickets_list;
      }
    } catch (e) {
      print("Exception while getting tickets for guard");
      print(e.toString());
      List<ResultObj> tickets_list = [];
      return tickets_list;
    }
  }

  static Future<List<ReadTableObject>> get_data_for_admin(
      String table_name) async {
    var uri = complete_base_url_static;
    if (table_name == 'Student') {
      uri = uri + "/students/get_all_students";
    } else if (table_name == 'Guard') {
      uri = uri + "/guards/get_all_guards";
    } else if (table_name == 'Admins') {
      uri = uri + "/admins/get_all_admins";
    } else if (table_name == 'Locations') {
      uri = uri + "/locations/view_all_locations";
    } else if (table_name == 'Hostels') {
      uri = uri + "/hostels/get_all_hostels";
    } else if (table_name == 'Authorities') {
      uri = uri + "/authorities/get_all_authorites";
    } else if (table_name == 'Departments') {
      uri = uri + "/departments/get_all_departments";
    } else if (table_name == 'Programs') {
      uri = uri + "/programs/get_all_programs";
    }
    try {
      var response = await http.post(Uri.parse(uri));
      List<ReadTableObject> tickets_list =
          (json.decode(response.body)['output'] as List)
              .map((i) => ReadTableObject.fromJson1(i))
              .toList();

      if (response.statusCode == 200) {
        return tickets_list;
      } else {
        print("Server Error in get_data_for_admin_tables_stream_util");
        List<ReadTableObject> tickets_list = [];
        return tickets_list;
      }
    } catch (e) {
      print("Exception while get_data_for_admin_tables_stream_util");
      print(e.toString());
      List<ReadTableObject> tickets_list = [];
      return tickets_list;
    }
  }

  static Stream<List<ReadTableObject>> get_data_for_admin_tables_stream(
          String table_name) =>
      Stream.periodic(Duration(seconds: REFRESH_RATE))
          .asyncMap((_) => get_data_for_admin_tables_stream_util(table_name));

  static Future<List<ReadTableObject>> get_data_for_admin_tables_stream_util(
      String table_name) async {
    var uri = complete_base_url_static;
    if (table_name == 'Student') {
      uri = uri + "/students/get_all_students";
    } else if (table_name == 'Guard') {
      uri = uri + "/guards/get_all_guards";
    } else if (table_name == 'Admins') {
      uri = uri + "/admins/get_all_admins";
    } else if (table_name == 'Locations') {
      uri = uri + "/locations/view_all_locations";
    } else if (table_name == 'Hostels') {
      uri = uri + "/hostels/get_all_hostels";
    } else if (table_name == 'Authorities') {
      uri = uri + "/authorities/get_all_authorites";
    } else if (table_name == 'Departments') {
      uri = uri + "/departments/get_all_departments";
    } else if (table_name == 'Programs') {
      uri = uri + "/programs/get_all_programs";
    }
    try {
      var response = await http.post(Uri.parse(uri));
      List<ReadTableObject> tickets_list =
          (json.decode(response.body)['output'] as List)
              .map((i) => ReadTableObject.fromJson1(i))
              .toList();

      if (response.statusCode == 200) {
        return tickets_list;
      } else {
        print("Server Error in get_data_for_admin_tables_stream_util");
        List<ReadTableObject> tickets_list = [];
        return tickets_list;
      }
    } catch (e) {
      print("Exception while get_data_for_admin_tables_stream_util");
      print(e.toString());
      List<ReadTableObject> tickets_list = [];
      return tickets_list;
    }
  }

  static Future<List<ResultObj2>> get_tickets_for_authorities(
      String authority_email, String is_approved) async {
    var uri =
        complete_base_url_static + "/authorities/get_tickets_for_authorities";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        'authority_email': authority_email,
        'is_approved': is_approved
      });

      List<ResultObj2> tickets_list = (json.decode(response.body) as List)
          .map((i) => ResultObj2.fromJson1(i))
          .toList();

      if (response.statusCode == 200) {
        return tickets_list;
      } else {
        print("Server Error in get_tickets_for_guard");
        List<ResultObj2> tickets_list = [];
        return tickets_list;
      }
    } catch (e) {
      // print("Exception in get_tickets_for_authorities: " + e.toString());
      List<ResultObj2> tickets_list = [];
      return tickets_list;
    }
  }

  static Stream<ResultObj3> get_student_status(String email, String location) =>
      Stream.periodic(Duration(seconds: REFRESH_RATE))
          .asyncMap((_) => get_student_status_util(email, location));

  static Future<ResultObj3> get_student_status_util(
      String email, String location) async {
    var uri = complete_base_url_static + "/students/get_student_status";
    ResultObj3 invalid = ResultObj3.constructor1("Invalid Status", "", "");
    try {
      var response = await http
          .post(Uri.parse(uri), body: {'email': email, 'location': location});
      // List<ResultObj> tickets_list = (json.decode(response.body) as List)
      // .map((i) => ResultObj.fromJson1(i))
      // .toList();
      Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      ResultObj3 res = ResultObj3.fromJson1(data);
      if (response.statusCode == 200) {
        return res;
      } else {
        return invalid;
      }
    } catch (e) {
      return invalid;
    }
  }

  Future<int> accept_selected_tickets(List<ResultObj> selectedTickets) async {
    var uri = complete_base_url_static + "/guards/accept_selected_tickets";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    // print("json encoded");
    // print(json.encode(data));
    // String json = jsonEncode(selectedTickets.map((i) => ResultObj.toJson1()).toList()).toString();
    // print(jsonEncode(selectedTickets.map((i) => i.toJson()).toList()));
    // Map<String, String> data = {
    //   "selectedTickets": json,
    // };
    try {
      // var response = await http.post(url, body: jsonEncode(data), headers: headers);
      var response = await http.post(Uri.parse(uri),
          body: jsonEncode(selectedTickets.map((i) => i.toJson1()).toList()),
          headers: headers);
      // var response = await http.post(url, body: data);
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      int status_code = response.statusCode.toInt();

      return status_code;
    } catch (e) {
      print("Request to accepted selected tickets failed .. ");
      print(e.toString());
      // return Future.error(e);
      return 500;
    }
  }

  Future<int> accept_selected_tickets_visitors(List<ResultObj4> selectedTickets_visitors) async {
    var uri = complete_base_url_static + "/visitors/accept_selected_tickets_visitors";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      var response = await http.post(Uri.parse(uri),
          body: jsonEncode(selectedTickets_visitors.map((i) => i.toJson1()).toList()),
          headers: headers);
      int status_code = response.statusCode.toInt();
      return status_code;
    } catch (e) {
      print("Request to accepted selected tickets for visitors failed .. ");
      print(e.toString());
      return 500;
    }
  }

  Future<int> accept_selected_tickets_authorities(
      List<ResultObj2> selectedTickets) async {
    var uri = complete_base_url_static +
        "/authorities/accept_selected_tickets_authorities";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    // print("json encoded");
    // print(json.encode(data));
    // String json = jsonEncode(selectedTickets.map((i) => ResultObj.toJson1()).toList()).toString();
    // print(jsonEncode(selectedTickets.map((i) => i.toJson()).toList()));
    // Map<String, String> data = {
    //   "selectedTickets": json,
    // };
    try {
      // var response = await http.post(url, body: jsonEncode(data), headers: headers);
      var response = await http.post(Uri.parse(uri),
          body: jsonEncode(selectedTickets.map((i) => i.toJson1()).toList()),
          headers: headers);
      // var response = await http.post(url, body: data);
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      int status_code = response.statusCode.toInt();

      return status_code;
    } catch (e) {
      print("Request to accepted selected tickets by authorities failed .. ");
      print("The exception is: " + e.toString());
      return 500;
    }
  }

  Future<int> reject_selected_tickets(List<ResultObj> selectedTickets) async {
    var uri = complete_base_url_static + "/guards/reject_selected_tickets";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    // print("json encoded");
    // print(json.encode(data));
    // String json = jsonEncode(selectedTickets.map((i) => i.toJson1()).toList()).toString();
    // print(jsonEncode(selectedTickets.map((i) => i.toJson()).toList()));
    // Map<String, String> data = {
    //   "selectedTickets": json,
    // };
    try {
      // var response = await http.post(url, body: jsonEncode(data), headers: headers);
      var response = await http.post(Uri.parse(uri),
          body: jsonEncode(selectedTickets.map((i) => i.toJson1()).toList()),
          headers: headers);
      // var response = await http.post(url, body: data);
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      int status_code = response.statusCode.toInt();
      return status_code;
    } catch (e) {
      print("Request to reject selected tickets failed .. ");
      print(e.toString());
      // return Future.error(e);
      return 500;
    }
  }

  Future<int> reject_selected_tickets_visitors(List<ResultObj4> selectedTickets) async {
    var uri = complete_base_url_static + "/visitors/reject_selected_tickets_visitors";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      var response = await http.post(Uri.parse(uri),
          body: jsonEncode(selectedTickets.map((i) => i.toJson1()).toList()),
          headers: headers);
      int status_code = response.statusCode.toInt();
      return status_code;
    } catch (e) {
      print("Request to reject selected tickets for visitors failed .. ");
      print(e.toString());
      return 500;
    }
  }

  Future<int> reject_selected_tickets_authorities(
      List<ResultObj2> selectedTickets) async {
    var uri = complete_base_url_static +
        "/authorities/reject_selected_tickets_authorities";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      var response = await http.post(Uri.parse(uri),
          body: jsonEncode(selectedTickets.map((i) => i.toJson1()).toList()),
          headers: headers);

      int status_code = response.statusCode.toInt();

      return status_code;
    } catch (e) {
      print("reject_selected_tickets_authorities raised exception: " +
          e.toString());
      return 500;
    }
  }

  Future<User> get_student_by_email(String? email_) async {
    var uri = complete_base_url_static + "/students/get_student_by_email";
    try {
      var response = await http.post(Uri.parse(uri), body: {"email": email_});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      var data = json.decode(response.body);
      String img_base_url = complete_base_url_static;
      User user = User(
        // imagePath : data["profile_img"],
        imagePath: img_base_url + data['profile_img'],
        name: data["name"],
        email: data["email"],
        phone: data['mobile_no'],
        degree: data['degree'],
        department: data['department'],
        year_of_entry: data['year_of_entry'],
        isDarkMode: true,
      );
      return user;
    } catch (e) {
      print("post request error");
      print(e.toString());
      User user = UserPreferences.myUser;
      return user;
    }
  }

  static Future<String> get_parent_location_name(String location) async {
    var uri = complete_base_url_static + "/locations/get_parent_location_name";
    try {
      var response =
          await http.post(Uri.parse(uri), body: {"location": location});

      var data = json.decode(response.body);

      return data['parent_location'];
    } catch (e) {
      return "";
    }
  }

  Future<GuardUser> get_guard_by_email(String? email_) async {
    var uri = complete_base_url_static + "/guards/get_guard_by_email";
    try {
      var response = await http.post(Uri.parse(uri), body: {"email": email_});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      var data = json.decode(response.body);
      String img_base_url = complete_base_url_static;
      GuardUser user = GuardUser(
        // imagePath : data["profile_img"],
        imagePath: img_base_url + data['profile_img'],
        name: data["name"],
        email: data["email"],
        location: data['location'],
        isDarkMode: true,
      );
      return user;
    } catch (e) {
      print("post request error");
      print(e.toString());
      GuardUser user = UserPreferences.myGuardUser;
      return user;
    }
  }

  Future<AdminUser> get_admin_by_email(String? email_) async {
    var uri = complete_base_url_static + "/admins/get_admin_by_email";
    try {
      var response = await http.post(Uri.parse(uri), body: {"email": email_});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      var data = json.decode(response.body);
      String img_base_url = complete_base_url_static;
      AdminUser user = AdminUser(
        // imagePath : data["profile_img"],
        imagePath: img_base_url + data['profile_img'],
        name: data["name"],
        email: data["email"],
        isDarkMode: true,
      );
      return user;
    } catch (e) {
      print("post request error");
      print(e.toString());
      AdminUser user = UserPreferences.myAdminUser;
      return user;
    }
  }

  Future<AuthorityUser> get_authority_by_email(String? email_) async {
    var uri = complete_base_url_static + "/authorities/get_authority_by_email";
    try {
      var response = await http.post(Uri.parse(uri), body: {"email": email_});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      var data = json.decode(response.body);
      String img_base_url = complete_base_url_static;
      AuthorityUser user = AuthorityUser(
        // imagePath : data["profile_img"],
        imagePath: img_base_url + data['profile_img'],
        name: data["name"],
        email: data["email"],
        designation: data['designation'],
        isDarkMode: true,
      );
      return user;
    } catch (e) {
      print("post request error");
      print(e.toString());
      AuthorityUser user = UserPreferences.myAuthorityUser;
      return user;
    }
  }

  static Future<String> add_new_location(
      String new_location_name,
      String chosen_parent_location,
      String chosen_pre_approval_needed,
      String automatic_exit_required) async {
    var uri = complete_base_url_static + "/locations/add_new_location";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        'new_location_name': new_location_name,
        'chosen_parent_location': chosen_parent_location,
        'chosen_pre_approval_needed': chosen_pre_approval_needed,
        'automatic_exit_required': automatic_exit_required
      });
      if (response.statusCode == 200) {
        return "New location added successfully";
      } else {
        return "Failed to add new location";
      }
    } catch (e) {
      return "Failed to add new location";
    }
  }

  static Future<String> modify_locations(
      String chosen_modify_location,
      String chosen_parent_location,
      String chosen_pre_approval_needed,
      String automatic_exit_required) async {
    var uri = complete_base_url_static + "/locations/modify_locations";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        'chosen_modify_location': chosen_modify_location,
        'chosen_parent_location': chosen_parent_location,
        'chosen_pre_approval_needed': chosen_pre_approval_needed,
        'automatic_exit_required': automatic_exit_required
      });
      if (response.statusCode == 200) {
        return "Location updated successfully";
      } else {
        return response.body.toString();
      }
    } catch (e) {
      return "Failed to update location data";
    }
  }

  static Future<String> delete_location(String chosen_delete_location) async {
    var uri = complete_base_url_static + "/locations/delete_location";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        'chosen_delete_location': chosen_delete_location,
      });
      if (response.statusCode == 200) {
        return "Location deleted successfully";
      } else {
        return response.body.toString();
      }
    } catch (e) {
      return "Failed to delete location";
    }
  }

  Future<void> send_file(Uint8List? chosen_file, String route) async {
    var uri = complete_base_url_static + route;
    var url = Uri.parse(uri);
    if (chosen_file != null) {
      List<int> _iterable_data = chosen_file;

      try {
        var request = new http.MultipartRequest("POST", url);
        request.files.add(http.MultipartFile.fromBytes('file', _iterable_data,
            contentType: new MediaType('application', 'octet-stream'),
            filename: 'file.csv'));

        request.send().then((response) {
          print(response.statusCode);
        });
      } catch (e) {
        print("post request error");
        print(e.toString());
        // return Future.error(e);
      }
    }
  }

  static Future<void> send_image(
      XFile chosen_file, String route, String email) async {
    print("inside send image function");
    String uri = complete_base_url_static + route;
    print("url is: " + uri);
    print("Error occured 1");
    var url = Uri.parse(uri);
    print("Error occured 2");
    if (chosen_file != null) {
      print("Error occured 3");
      File img_file = File(chosen_file.path);
      print("Error occured 4");
      List<int> _iterable_data = await chosen_file.readAsBytes();
      print("Error occured 5");

      try {
        print("Error occured 6");
        var request = new http.MultipartRequest("POST", url);
        request.fields['email'] = email;
        print("Error occured 7");
        request.files.add(http.MultipartFile.fromBytes('image', _iterable_data,
            contentType: new MediaType('image', 'jpg'),
            filename: 'image_file.jpg'));

        print("Error occured 8");
        var response = await request.send();
        print(response.statusCode);
        print("Error occured 9");
      } catch (e) {
        print("post request error");
        print(e.toString());
        // return Future.error(e);
      }
    }
  }

  static Future<String> add_guard(
      String name, String email, String location) async {
    String uri = complete_base_url_static + "/forms/add_guard_form";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        'name': name,
        'email': email,
        'location_name': location,
      });
      return response.body.toString();
    } catch (e) {
      return "Failed to add guard";
    }
  }

  static Future<String> add_admin_form(String name, String email) async {
    String uri = complete_base_url_static + "/forms/add_admin_form";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        'name': name,
        'email': email,
      });
      return response.body.toString();
    } catch (e) {
      print("Exception in add_admin_form: " + e.toString());
      return "Failed to add admin";
    }
  }

  static Future<String> modify_guard(String email, String location) async {
    String uri = complete_base_url_static + "/forms/modify_guard_form";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        'email': email,
        'location_name': location,
      });
      return response.body.toString();
    } catch (e) {
      return "Failed to add guard";
    }
  }

  static Future<String> delete_guard(String email) async {
    String uri = complete_base_url_static + "/forms/delete_guard_form";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        'email': email,
      });
      return response.body.toString();
    } catch (e) {
      return "Failed to add guard";
    }
  }

  static Future<List<StatisticsResultObj>> get_statistics_data_by_location(
      String location, String filter) async {
    var uri = complete_base_url_static +
        "/statistics/get_statistics_data_by_location";
    try {
      var response = await http
          .post(Uri.parse(uri), body: {"location": location, "filter": filter});
      // print("*********************************** response body");
      // print(response.body);
      var data = json.decode(response.body);
      // print("************************ data");
      // print(data);
      List<StatisticsResultObj> res = [];
      for (var each_data_object in data['output']) {
        StatisticsResultObj statisticsResultObj = StatisticsResultObj(
            each_data_object['category'], each_data_object['count']);
        res.add(statisticsResultObj);
      }
      return res;
    } catch (e) {
      List<StatisticsResultObj> res = [];
      print(e);
      return res;
    }
  }

  static Future<List<StatisticsResultObj>> get_piechart_statistics_by_location(
      String location,
      String filter,
      String start_date,
      String end_date) async {
    var uri = complete_base_url_static +
        "/statistics/get_piechart_statistics_by_location";

    try {
      var response = await http.post(Uri.parse(uri), body: {
        "location": location,
        "filter": filter,
        "start_date": start_date,
        "end_date": end_date
      });
      // print("*********************************** response body");
      // print(response.body);
      var data = json.decode(response.body);
      // print("************************ data");
      // print(data);
      List<StatisticsResultObj> res = [];
      for (var each_data_object in data['output']) {
        StatisticsResultObj statisticsResultObj = StatisticsResultObj(
            each_data_object['category'], each_data_object['count']);
        res.add(statisticsResultObj);
      }
      return res;
    } catch (e) {
      List<StatisticsResultObj> res = [];
      print(e);
      return res;
    }
  }

  // This is used to raise a ticket for the first time using the addVisitors button
  static Future<int> insert_in_visitors_ticket_table(
    String visitor_name,
    String mobile_no,
    // String current_status,
    String car_number,
    String authority_name,
    String authority_email,
    String authority_designation,
    String purpose,
    // String authority_status,
    // String authority_message,
    // String date_time_of_ticket_raised,
    // String date_time_authority,
    // String date_time_guard,
    // String date_time_of_exit,
    // String guard_status, 
    String ticket_type,
    String duration_of_stay,
  ) async {
    var uri = complete_base_url_static + "/visitors/insert_in_visitors_ticket_table";
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'visitor_name': visitor_name,
          'mobile_no': mobile_no,
          'car_number': car_number,
          'authority_name': authority_name,
          'authority_email': authority_email,
          'authority_designation': authority_designation,
          'purpose': purpose,
          'ticket_type': ticket_type,
          'duration_of_stay': duration_of_stay,
        },
      );
      var data = json.decode(response.body);
      var data_map = data["output"] as Map<String, dynamic>;
      bool status = data_map['status'];
      String message = data_map['message'];
      print("Message: " + message);
      // return status;
      return response.statusCode.toInt();
    } catch (e) {
      print("Exception in insert_in_visitors_ticket_table: " + e.toString());
      // return false;
      return 500;
    }
  }

  // This is used to update the authority status of a visitor ticket
  static Future<int> insert_in_visitors_ticket_table_2(
    String authority_status,
    ResultObj4 ticket_visitor,
  ) async {
    var uri = complete_base_url_static + "/visitors/insert_in_visitors_ticket_table_2";
    try {
      String visitor_ticket_id = ticket_visitor.visitor_ticket_id.toString();
      String authority_message = ticket_visitor.authority_message;
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'authority_status': authority_status,
          'visitor_ticket_id': visitor_ticket_id,
          'authority_message': authority_message,
        },
      );
      var data = json.decode(response.body);
      var data_map = data["output"] as Map<String, dynamic>;
      bool status = data_map['status'];
      String message = data_map['message'];
      print("Message: " + message);
      // return status;
      return response.statusCode.toInt();
    } catch (e) {
      print("Exception in insert_in_visitors_ticket_table: " + e.toString());
      // return false;
      return 500;
    }
  }

  static Future<List<String>> get_student_status_for_all_locations(String email) async {
    var uri = complete_base_url_static + "/students/get_status_for_all_locations";
    List<String> output = [];
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'email': email,
        },
      );
      if(response.statusCode== 200){
        var data = json.decode(response.body);

        for (var k in data.keys){
          var v = data[k];
          if (v =='out'){
            data[k]='Out';
          }
          else if(v == 'in'){
            data[k]='In';
          }
          else if(v == 'pending_entry'){
            data[k]='Pending Entry';
          }
          else if(v == 'pending_exit'){
            data[k]='Pending Exit';
          }
        }

        data.forEach((k, v) => output.add(v));
      }
      else{
        print("Error occured while fetching the data from backend");
      }
      return output;
    } catch (e) {
      print("Exception in insert_in_visitors_ticket_table: " + e.toString());
      return output;
      // return false;
      // return 500;
    }
  }

}
