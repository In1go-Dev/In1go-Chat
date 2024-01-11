import 'package:flutter/material.dart';

class MainPageAppBar extends AppBar {

  final String initials;
  final String titleName;

  MainPageAppBar({super.key, required this.initials, required this.titleName}):super(
    automaticallyImplyLeading: false,
    centerTitle: true,
    elevation: 0,
    leadingWidth: 60,
    toolbarHeight: 60,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    title: Text(titleName, style: const TextStyle(fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)
  );
}