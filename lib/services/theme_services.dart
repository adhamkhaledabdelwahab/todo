import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// theme services class used for updating and saving app theme
/// through GetStorage class and GetX concept
class ThemeServices {
  /// GetStorage object initializing
  final GetStorage _box = GetStorage();
  /// storage key to save theme if dark => true , else => false
  final _key = 'isDarkMode';

  /// switch theme method, updating theme with opposite of the current one
  /// if Dark => Light, else => Dark
  /// then save into app storage using GetStorage class by calling saveThemeToBox() method
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    saveThemeToBox(!_loadThemeFromBox());
  }

  /// retrieve saved theme from app storage using GetStorage class
  bool _loadThemeFromBox() => _box.read<bool>(_key) ?? false;

  /// method used to save theme into app storage
  void saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  /// method to get saved theme from app storage
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
}
