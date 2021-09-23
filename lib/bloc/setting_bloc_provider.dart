import 'package:flutter/material.dart';
import 'package:journal_app/models/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingState extends StatefulWidget {
  final Widget child;

  const SettingState({Key? key, required this.child}) : super(key: key);

  @override
  _SettingStateState createState() => _SettingStateState();
}

class _SettingStateState extends State<SettingState> {
 late Setting setting ;
final Future<SharedPreferences> _sharedPreferences=SharedPreferences.getInstance();


 updateName(String newName){
   final tempSetting=Setting.copyWith(setting);
   tempSetting.updateName(newName);
   setState(() {
     setting=Setting.copyWith(tempSetting);
   });
 }
 updatePhotoPath(String path){
   final tempSetting=Setting.copyWith(setting);
   tempSetting.updatePhotoPath(path);
   setState(() {
     setting=Setting.copyWith(tempSetting);
   });
 }

  swatchTheme() {
    final tempSetting=Setting.copyWith(setting);
    tempSetting.isLight?tempSetting.swatchToDark():tempSetting.swatchToLight();
    setState(() {
        setting=Setting.copyWith(tempSetting);
    });
    _sharedPreferences.then((shared) {
      shared.setBool('theme', setting.isLight);
    });
  }
@override
  void initState() {
   setting=Setting();
    super.initState();
  }
  @override
  Widget build(BuildContext context) =>
      SettingProvider(child: widget.child,setting:this.setting, settingState: this);
}

class SettingProvider extends InheritedWidget {
  final _SettingStateState settingState;
final Setting  setting;

 const SettingProvider({Key? key, required Widget child, required this.setting,required this.settingState})
      : super(child: child, key: key);

  static _SettingStateState of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<SettingProvider>()!
        .settingState);
  }

  @override
  bool updateShouldNotify(SettingProvider oldWidget) {
    // print('${oldWidget.setting != this.setting}');
    return oldWidget.setting != this.setting;
  }

}
