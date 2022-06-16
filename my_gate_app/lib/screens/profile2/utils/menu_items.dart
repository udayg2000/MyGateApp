import 'package:flutter/material.dart';
import 'package:my_gate_app/screens/profile2/model/menu_item.dart';

class MenuItems{

  static const List<MenuItem> itemsFirst = [
    itemProfile,
  ];
  
  static const List<MenuItem> itemsSecond = [
    itemLogOut,
  ];

  static const itemProfile = MenuItem(
    text: 'Profile',
    icon: Icons.account_circle,
  );
  
  static const itemLogOut = MenuItem(
    text: 'Log Out',
    icon: Icons.logout,
  );
  
}