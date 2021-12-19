import 'package:flutter/material.dart';

class MyConstant {
  // Genernal
  static String appName = 'POT App';
  static String domain = 'https://949f-49-231-193-61.ngrok.io';
  // Route
  static String routeLogin = '/login';
  static String routeUser = '/salerService';
  static String routeSaler = '/userService';
  static String routeChooseAccount = '/chooseAccount';
  //////////////// Create Account /////////////////////////
  static String routeCreateUser = '/createUser';
  static String routeCreateSaler = '/createSaler';
  /////////////////////////////////////////////////////////

  // image
  static String imageLogo = 'images/logoApp.png';
  static String imageavatar = 'images/avatar.png';

  // Color
  static Color primary = Color(0xffC08960);
  static Color dark = Color(0xff8d5c35);
  static Color light = Color(0xfff5b98e);

  // Style
  TextStyle h1Style() => TextStyle(
        fontSize: 24,
        color: dark,
        fontWeight: FontWeight.bold,
      );

  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.w700,
      );

  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.normal,
      );

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );
}
