import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  SharedPreferences? _prefs;

  SharedPrefServices() {
    init();
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  Future<void> saveBoolean(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  Future<void> saveInLocalStorageAsInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  Future<bool> getBoolean(String? key) async {
    return _prefs?.getBool(key!) ?? false;
  }

  Future<bool> isContain(String? key) async {
    return _prefs?.containsKey(key!) ?? false;
  }

  Future<int> getInteger(String? key) async {
    return _prefs?.getInt(key!) ?? 0;
  }

  Future<void> saveInteger(String? key, int value) async {
    await _prefs?.setInt(key!, value);
  }

  Future<void> saveDouble(String? key, double value) async {
    await _prefs?.setDouble(key!, value);
  }

  Future<double> getDouble(String? key) async {
    return _prefs?.getDouble(key!) ?? 0.0;
  }

  Future<String> getString(String? key, {String defaultValue = ""}) async {
    return _prefs?.getString(key!) ?? defaultValue;
  }

  Future<void> removeFromLocalStorage({@required String? key}) async {
    await _prefs?.remove(key!);
  }

  Future<void> clearPrefs() async {
    await _prefs?.clear();
  }
}