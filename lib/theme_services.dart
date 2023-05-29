import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeService {
  final myStorage = GetStorage();
  final checker = 'isDarkMode';

  ThemeMode get theme => myTheme() ? ThemeMode.dark : ThemeMode.light;

  bool myTheme() => myStorage.read(checker) ?? false;

  saveTheme(bool isDarkMode) => myStorage.write(checker, isDarkMode);

  void switchTheme() {
    Get.changeThemeMode(myTheme() ? ThemeMode.light : ThemeMode.dark);
    saveTheme(!myTheme());
  }
}
