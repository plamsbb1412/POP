import 'package:flutter/material.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_signout.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends StatefulWidget {
  const UserService({Key? key}) : super(key: key);

  @override
  _UserServiceState createState() => _UserServiceState();
}

class _UserServiceState extends State<UserService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('user'),
      ),
      drawer: Drawer(
        child: ShowSignOut(),
      ),
    );
  }
}
