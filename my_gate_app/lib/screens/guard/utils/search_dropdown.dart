import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

Widget dropdown(
    BuildContext context,
    List<String> parent_locations,
    void Function(String?)? onChangedFunction,
    String label,
    Icon icon,
    {double border_radius : 5,
      Color container_color: Colors.white,
      Color text_color: Colors.white,
    }
    ) {
  return Container(
    width: MediaQuery.of(context).size.width / 2,
    color: container_color,
    child: Theme(
      data: ThemeData(
        textTheme: TextTheme(subtitle1: TextStyle(color: Colors.black)),
      ),
      child: DropdownSearch<String>(
        popupBackgroundColor: Colors.white,
        mode: Mode.MENU,
        showSearchBox: true,
        dropdownSearchDecoration: InputDecoration(
            labelStyle: TextStyle(color: text_color),
            floatingLabelStyle: TextStyle(color: Colors.white),
            prefixStyle: TextStyle(color: Colors.white),
            fillColor: Colors.deepOrange,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(border_radius)),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(border_radius)),
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            prefixIcon: icon),
        showAsSuffixIcons: true,
        showClearButton: true,
        showSelectedItems: true,
        items: parent_locations,
        // items: [
        //   "Brazil",
        //   "Italia (Disabled)",
        //   "Tunisia",
        //   "Canada"
        // ],
        label: label,
        // popupItemDisabled: (String s) => s.startsWith('I'),
        onChanged: onChangedFunction,
        // selectedItem: "Brazil"
      ),
    ),
  );
}
