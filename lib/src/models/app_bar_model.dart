import 'package:flutter/material.dart';

class AppBarModel {
  final bool? centerTitle;
  final Widget? title;
  final Color? backgroundColor;
  final List<Widget>? actions;

  AppBarModel(
      {this.centerTitle, this.title, this.backgroundColor, this.actions});
}
