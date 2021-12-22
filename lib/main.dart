import 'package:flutter/material.dart';
import 'package:flutter_application_1/create_account/create_user.dart';
import 'package:flutter_application_1/states/add_product.dart';
import 'package:flutter_application_1/states/login.dart';
import 'package:flutter_application_1/states/saler_service.dart';
import 'package:flutter_application_1/states/user_service.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext context) => Login(),
  '/salerService': (BuildContext context) => SalerService(),
  '/userService': (BuildContext context) => UserService(),

  //////////////// Create Account /////////////////////////

  '/createUser': (BuildContext context) => CreateUser(),
  /////////////////////////////////////////////////////////

  '/addProduct': (BuildContext context) => AddProduct(),
};

String? initlaRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type');
  // print('### type ===>> $type');
  if (type?.isEmpty ?? true) {
    initlaRoute = MyConstant.routeLogin;
    runApp(MyApp());
  } else {
    switch (type) {
      case 'user':
        initlaRoute = MyConstant.routeUserService;
        runApp(MyApp());
        break;
      case 'store':
        initlaRoute = MyConstant.routeSalerService;
        runApp(MyApp());
        break;
      default:
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor =
        MaterialColor(0xff8d5c35, MyConstant.mapMaterialColor);
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initlaRoute,
      theme: ThemeData(primarySwatch: materialColor),
    );
  }
}
