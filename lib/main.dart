import 'package:flutter/material.dart';
import 'package:flutter_application_1/create_account/choose_account.dart';
import 'package:flutter_application_1/create_account/create_saler.dart';
import 'package:flutter_application_1/create_account/create_user.dart';
import 'package:flutter_application_1/states/login.dart';
import 'package:flutter_application_1/states/saler_service.dart';
import 'package:flutter_application_1/states/user_service.dart';
import 'package:flutter_application_1/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext context) => Login(),
  '/salerService': (BuildContext context) => SalerService(),
  '/userService': (BuildContext context) => UserService(),
  '/chooseAccount': (BuildContext context) => ChooseAccount(),
  //////////////// Create Account /////////////////////////
  '/createSaler': (BuildContext context) => CreateSaler(),
  '/createUser': (BuildContext context) => CreateUser(),
  /////////////////////////////////////////////////////////
};

String? initlaRoute;

void main() {
  initlaRoute = MyConstant.routeLogin;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initlaRoute,
    );
  }
}
