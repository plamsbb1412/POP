import 'package:flutter/material.dart';

class MyConstant {
  // Genernal
  static String appName = 'ไข่น้อย';
  static String domain = 'https://57d1-171-4-218-68.ngrok.io';
  static String urlPrompay = 'https://promptpay.io/0876586332.png';
  static String publicKey = 'pkey_test_5okvg05okkpuye2qehc';
  // Route
  static String routeLogin = '/login';
  static String routeUserService = '/userService';
  static String routeSalerService = '/salerService';
  static String routeChooseAccount = '/chooseAccount';
  //////////////// Create Account /////////////////////////
  static String routeCreateUser = '/createUser';
  static String routeCreateSaler = '/createSaler';
  /////////////////////////////////////////////////////////
  static String routeAddProduct = '/addProduct';
  static String routeEditProfileStore = '/editProfileStore';
  static String routeShowCart = '/showCart';
  static String routeAddwallet = '/addWallet';
  static String routeConfrimAddwallet = '/confrimaddWallet';

  // image
  static String imageLogo = 'images/logo1.png';
  static String imageavatar = 'images/avatar.png';
  static String imageAddProduct = 'images/imageAddProduct.png';

  // Color
  static Color primary = Color(0xff3a5157);
  static Color dark = Color(0xff12292e);
  static Color light = Color(0xff657d84);
  static Map<int, Color> mapMaterialColor = {
    50: Color.fromRGBO(58, 81, 87, 0.1),
    100: Color.fromRGBO(58, 81, 87, 0.2),
    200: Color.fromRGBO(58, 81, 87, 0.3),
    300: Color.fromRGBO(58, 81, 87, 0.4),
    400: Color.fromRGBO(58, 81, 87, 0.5),
    500: Color.fromRGBO(58, 81, 87, 0.6),
    600: Color.fromRGBO(58, 81, 87, 0.7),
    700: Color.fromRGBO(58, 81, 87, 0.8),
    800: Color.fromRGBO(58, 81, 87, 0.9),
    900: Color.fromRGBO(58, 81, 87, 1.0),
  };

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
  TextStyle h2whistStyle() => TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      );
  TextStyle h2RedStyle() => TextStyle(
        fontSize: 18,
        color: Colors.red.shade700,
        fontWeight: FontWeight.w700,
      );
  TextStyle h2BlueStyle() => TextStyle(
        fontSize: 18,
        color: Colors.blue.shade800,
        fontWeight: FontWeight.w700,
      );

  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.normal,
      );

  TextStyle h3whisStyle() => TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      );

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  //Background
  BoxDecoration planBackground() => BoxDecoration(
        color: MyConstant.light.withOpacity(0.75),
      );

  BoxDecoration gradintLinearBackground() => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, MyConstant.light, MyConstant.primary],
        ),
      );
}
