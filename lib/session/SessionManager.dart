
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SessionManager {
  static SharedPreferences? prefs;
  static Future init() async => prefs = await SharedPreferences.getInstance();
  String user_name = "";
  String user_id = "";
  String user_phone = "";
  String last_login = "";
  String ip = "";
  bool IsLoggedIn = true;
  bool isAppDarkThem = false;

  Future<void> saveUserData(Map userData) async {
    Map studentData = userData;

    user_id = studentData['id'].toString() ?? '';
    user_name = studentData['username'].toString() ?? '';
    user_phone = studentData['phone'] ?? '';
    last_login = studentData['last_login'] ?? '';
    ip = studentData['ip'] ?? '';

    if (kDebugMode) {
      print("abc ${userData.toString()}");
    }
    prefs?.setString('id', user_id);
    prefs?.setString('username', user_name);
    prefs?.setString('phone', user_phone);
    prefs?.setString('last_login', last_login);
    prefs?.setString('ip', ip);
    prefs?.setBool('IsLoggedIn', IsLoggedIn);

    if (kDebugMode) {
      print("def ${userData.toString()}");
    }
  }


  static String? getUserName() => prefs!.getString("username") ?? 'Buddy';
  static String? getUserPhone() => prefs!.getString("phone") ?? '0000000000';
  static String? getUserId() => prefs!.getString("id") ?? '';
  static String? getLastLogin() => prefs!.getString("last_login") ?? '';
  static String? getIpAdd() => prefs!.getString("ip") ?? '';
  static bool? isLogin() => prefs?.getBool("IsLoggedIn") ?? false;

  Future<void> logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Navigator.pushAndRemoveUntil<dynamic>(context, MaterialPageRoute<dynamic>(builder: (BuildContext context) => const LoginScreen(),), (route) => false,);
  }

  Future<void> changeAppTheme(bool isDarkThem) async {
    prefs?.setBool('isAppDarkThem', isDarkThem);
  }
  static bool? isAppDarkTheme() => prefs?.getBool("isAppDarkThem");
}