import 'package:flutter/material.dart';
import 'package:login_fudosan/screens/homescreen.dart';
import 'package:login_fudosan/screens/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  SharedPreferences instance;

  authHandle() async {
    instance = await SharedPreferences.getInstance();
    if (instance.getString('token') == null) {
      return LoginScreen();
    } else {
      return HomeScreeen();
    }
  }
}
