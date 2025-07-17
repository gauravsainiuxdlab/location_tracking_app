import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static Future<SharedPreferences> _getSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool> containsKey(String key) async {
    var prefs = await _getSharedPref();
    return prefs.containsKey(key);
  }

  static Future clear() async {
    var prefs = await _getSharedPref();
    await prefs.clear();
  }

  static Future<bool> getBool(String key) async {
    var prefs = await _getSharedPref();
    return prefs.getBool(key) ?? false;
  }

  static Future<double> getDouble(String key) async {
    var prefs = await _getSharedPref();
    return prefs.getDouble(key) ?? -1;
  }

  static Future<int> getInt(String key) async {
    var prefs = await _getSharedPref();
    return prefs.getInt(key) ?? -1;
  }

  static Future<String?> getString(String key) async {
    var prefs = await _getSharedPref();
    return prefs.getString(key);
  }

  static void setBool(String key, dynamic value) async {
    var prefs = await _getSharedPref();
    prefs.setBool(key, value);
  }

  static void setDouble(String key, double value) async {
    var prefs = await _getSharedPref();
    prefs.setDouble(key, value);
  }

  static Future setInt(String key, int value) async {
    var prefs = await _getSharedPref();
    prefs.setInt(key, value);
  }

  static Future setString(String key, String value) async {
    var prefs = await _getSharedPref();
    await prefs.setString(key, value);
  }

  static Future removeKey(String key) async {
    var prefs = await _getSharedPref();
    prefs.remove(key);
  }
}
