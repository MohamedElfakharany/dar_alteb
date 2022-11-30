import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    @required String? key,
    @required dynamic value,
  }) async {
    // final prefs = await SharedPreferences.getInstance();
    if (value is String) return sharedPreferences!.setString(key!, value);
    if (value is int) return sharedPreferences!.setInt(key!, value);
    if (value is bool) return sharedPreferences!.setBool(key!, value);
    return sharedPreferences!.setDouble(key!, value);
  }

  static dynamic getData({
    @required String? key,
  }) {
    // final prefs = await SharedPreferences.getInstance();
    return sharedPreferences!.get(key!);
  }

  static Future<bool> removeData({
    @required String? key,
  }) async
  {
    return await sharedPreferences!.remove(key!);
  }
}
