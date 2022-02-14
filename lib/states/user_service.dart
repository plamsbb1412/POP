import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/bodys/my_money_user.dart';
import 'package:flutter_application_1/bodys/my_order_user.dart';
import 'package:flutter_application_1/bodys/show_all_shop.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_image.dart';
import 'package:flutter_application_1/widgets/show_signout.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends StatefulWidget {
  const UserService({Key? key}) : super(key: key);

  @override
  _UserServiceState createState() => _UserServiceState();
}

class _UserServiceState extends State<UserService> {
  List<Widget> widgets = [
    ShowAllShopUser(),
    ShowOrderUser(),
    ShowMoneyUser(),
  ];

  int indexWidget = 0;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    findUserLogin();
  }

  Future<void> findUserLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idUserLogin = preferences.getString('id');

    var urlAPI =
        '${MyConstant.domain}/Project/StoreRMUTL/API/getUserWhereId.php?isAdd=true&id=$idUserLogin';
    await Dio().get(urlAPI).then((value) async {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          print('#### id login ==> ${userModel!.id}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, MyConstant.routeShowCart),
            icon: Icon(Icons.shopping_cart_outlined),
          )
        ],
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildHeader(),
                buildShowShop(),
                buildShowOrder(),
                buildShowMoney(),
              ],
            ),
            ShowSignOut(),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  ListTile buildShowShop() {
    return ListTile(
      leading: Icon(
        Icons.shopping_basket,
        size: 36,
        color: MyConstant.dark,
      ),
      title: ShowTitle(title: 'ร้านค้า', textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(
        title: 'แสดงร้านค้าทั้งหมด',
        textStyle: MyConstant().h3Style(),
      ),
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
    );
  }

  ListTile buildShowMoney() {
    return ListTile(
      leading: Icon(
        Icons.attach_money,
        size: 36,
        color: MyConstant.dark,
      ),
      title: ShowTitle(title: 'กระเป๋าตัง', textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(
        title: 'แสดงเงินในกระเป๋า',
        textStyle: MyConstant().h3Style(),
      ),
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
    );
  }

  ListTile buildShowOrder() {
    return ListTile(
      leading: Icon(
        Icons.list,
        size: 36,
        color: MyConstant.dark,
      ),
      title:
          ShowTitle(title: 'รายการสั่งของ', textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(
        title: 'แสดงรายการสั่งเมนูอาหาร',
        textStyle: MyConstant().h3Style(),
      ),
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
    );
  }

  UserAccountsDrawerHeader buildHeader() => UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 1,
          center: Alignment(-0.8, -0.2),
          colors: [Colors.white, MyConstant.dark],
        ),
      ),
      currentAccountPicture: userModel == null
          ? ShowImage(path: MyConstant.imageavatar)
          : userModel!.avater.isEmpty
              ? ShowImage(path: MyConstant.imageavatar)
              : CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      '${MyConstant.domain}${userModel!.avater}'),
                ),
      accountName: ShowTitle(
        title: userModel == null ? '' : userModel!.name,
        textStyle: MyConstant().h2whistStyle(),
      ),
      accountEmail: null);
}
