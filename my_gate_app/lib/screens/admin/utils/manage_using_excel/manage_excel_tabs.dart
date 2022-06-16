// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:my_gate_app/database/database_objects.dart';
import 'package:my_gate_app/screens/admin/utils/manage_using_excel/upload_excel.dart';
import 'package:my_gate_app/screens/admin/utils/view_data_tables/stream_data_table.dart';

class ManageExcelTabs extends StatefulWidget {
  const ManageExcelTabs({
    Key? key,
    required this.appbar_title,
    required this.add_url,
    required this.modify_url,
    required this.delete_url,
    required this.entity,
    required this.data_entity,
    required this.column_names,
  }) : super(key: key);
  final String appbar_title;
  final String add_url;
  final String modify_url;
  final String delete_url;
  final String entity;
  final String data_entity;
  final List<String> column_names;

  @override
  State<ManageExcelTabs> createState() => _ManageExcelTabsState();
}

class _ManageExcelTabsState extends State<ManageExcelTabs>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  List<ResultObj> tickets = [];

  // The initState and dispose state are required for adding the tabs
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.appbar_title),
            centerTitle: true,
            bottom: TabBar(
              controller: controller,
              tabs: [
                Tab(text: 'Add', icon: Icon(Icons.add)),
                Tab(text: 'Modify', icon: Icon(Icons.edit)),
                Tab(text: 'Delete', icon: Icon(Icons.delete)),
                Tab(text: 'View', icon: Icon(Icons.remove_red_eye)),
              ],
            ),
          ),
          body: TabBarView(
            controller: controller,
            children: [
              UploadExcel(
                upload_page_message: 'Upload ${widget.entity} data to add',
                upload_url: widget.add_url,
                upload_page_color: Colors.lightGreenAccent,
              ),
              UploadExcel(
                upload_page_message: 'Upload ${widget.entity} data to modify',
                upload_url: widget.modify_url,
                upload_page_color: Colors.yellow,
              ),
              UploadExcel(
                upload_page_message: 'Upload ${widget.entity} data to delete',
                upload_url: widget.delete_url,
                upload_page_color: Colors.amber,
              ),
              StreamAdminDataTable(
                data_entity: widget.data_entity,
                column_names: widget.column_names,
              )
            ],
          ),
        ),
      );
}
