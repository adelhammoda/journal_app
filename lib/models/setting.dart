import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting {
  Color appBarColor = Colors.lightGreen;
  Color buttonsColor = Colors.lightGreen.shade300;
  Color iconColor = Colors.lightGreen.shade800;
  Color backgroundColor = Colors.lightGreen.shade50;
  Color buttonBackgroundColor=Colors.white;
  MaterialColor? primarySwatch;
  Color canvasColor = Colors.lightGreen.shade50;
  Color textColor = Colors.lightGreen;
  List<Color> gradient = [
    Colors.lightGreen.shade50,
    Colors.lightGreen,
  ];
  bool isLight = true;
  String name = 'User';
  String? userPhotoPath;
  Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  Setting() {
    bool isLight;
    _sharedPreferences.then((sharedPref) {
      isLight = sharedPref.getBool('theme') ?? true;
      isLight ? swatchToLight() : swatchToDark();
      name=sharedPref.getString('userName')??'User';
      userPhotoPath=sharedPref.getString('photoPath');
    });
  }
  updatePhotoPath(String path){
    userPhotoPath=path;
    _sharedPreferences.then((sharedPref) {
      sharedPref.setString('photoPath', userPhotoPath!);
    });
  }
  updateName(String newName){
      String temp=newName.characters.first.toUpperCase();
     name= newName.replaceRange(0, 1, temp);
      _sharedPreferences.then((sharedPref) {
      sharedPref.setString('userName', name);
      });
  }

  swatchToLight() {
    isLight = true;
     buttonBackgroundColor=Colors.white;
    backgroundColor = Colors.lightGreen.shade50;
    appBarColor = Colors.lightGreen;
    textColor = Colors.lightGreen;
    buttonsColor = Colors.lightGreen;
    iconColor = Colors.lightGreen.shade800;
    primarySwatch = createMaterialColor(Colors.lightGreen);
    canvasColor = Colors.lightGreen.shade50;
    gradient = [
      Colors.lightGreen.shade50,
      Colors.lightGreen,
    ];
  }

  swatchToDark() {
    isLight = false;
    buttonBackgroundColor= Color(0xff5b699e);
    backgroundColor = Color(0xFF232946);
    appBarColor = Color(0xFFb8c1ec);
    textColor = Color(0xffb8c1ec);
    iconColor = Color(0xFFeebbc3);
    buttonsColor = Color(0xFFeebbc3);
    primarySwatch = createMaterialColor(Color(0xFF232946));
    canvasColor = Color(0xFF232946);
    gradient = [
      Color(0xFF232946),
      Color(0xff5b699e),
    ];
  }

  Setting.copyWith(Setting setting) {
    isLight = setting.isLight;
    name=setting.name;
    userPhotoPath=setting.userPhotoPath;
    appBarColor = setting.appBarColor;
    canvasColor = setting.canvasColor;
    buttonsColor = setting.buttonsColor;
    primarySwatch = setting.primarySwatch;
    gradient = setting.gradient;
    textColor = setting.textColor;
    iconColor = setting.iconColor;
    backgroundColor=setting.backgroundColor;
    buttonBackgroundColor=setting.buttonBackgroundColor;
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
