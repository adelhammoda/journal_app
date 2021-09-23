import 'package:flutter/material.dart';
import 'package:journal_app/bloc/setting_bloc_provider.dart';
import 'package:responsive_s/responsive_s.dart';

PreferredSizeWidget buildAppBar(
    {required BuildContext context,
    required Responsive responsive,
     void Function()? onPressed,
    required String title}) {
  return AppBar(
    bottomOpacity: 0.0,
    shadowColor: null,
    toolbarOpacity: 1.0,
    actions: onPressed==null?null:<Widget>[
      IconButton(
        icon: Icon(
          Icons.exit_to_app,
          color: SettingProvider.of(context).setting.iconColor,
        ),
        onPressed: onPressed,
      ),
    ],
    bottom: PreferredSize(
      child: Container(),
      preferredSize: Size.fromHeight(responsive.setHeight(3)),
    ),
    flexibleSpace: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: SettingProvider.of(context).setting.gradient.reversed.toList(),
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      width: 60,
    ),
    elevation: 0.0,
    title: Text(title),
  );
}
