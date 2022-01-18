import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/bodys/shop_manage_seller.dart';
import 'package:flutter_application_1/bodys/show_order_seller.dart';
import 'package:flutter_application_1/bodys/show_product_seller.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_progress.dart';
import 'package:flutter_application_1/widgets/show_signout.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalerService extends StatefulWidget {
  const SalerService({Key? key}) : super(key: key);

  @override
  _SalerServiceState createState() => _SalerServiceState();
}

class _SalerServiceState extends State<SalerService> {
  List<Widget> widgets = [];

  int indexWidget = 0;
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUserModel();
  }

  Future<Null> findUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    print('## id Login ID ==>> $id');
    String apiGetUserWhereId =
        '${MyConstant.domain}/Project/StoreRMUTL/API/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetUserWhereId).then((value) {
      print('## value ===>> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          widgets.add(ShowOrder());
          widgets.add(Shopmanage(userModel: userModel!));
          widgets.add(ShowProduct());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, MyConstant.routeShowCart),
              icon: Icon(Icons.shopping_cart_outlined))
        ],
      ),
      drawer: widgets.length == 0
          ? SizedBox()
          : Drawer(
              child: Stack(
                children: [
                  ShowSignOut(),
                  Column(
                    children: [
                      buildHead(),
                      menuShowOrder(),
                      menuShopManage(),
                      menuShowProduct(),
                    ],
                  ),
                ],
              ),
            ),
      body: widgets.length == 0 ? ShowProgress() : widgets[indexWidget],
    );
  }

  UserAccountsDrawerHeader buildHead() {
    return UserAccountsDrawerHeader(
        otherAccountsPictures: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.face_outlined),
            iconSize: 36,
            color: MyConstant.light,
            tooltip: 'Edit Shop',
          ),
        ],
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [MyConstant.light, MyConstant.dark],
            center: Alignment(-0.8, -0.2),
            radius: 1,
          ),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(
              '${MyConstant.domain}/Project/StoreRMUTL/API${userModel!.avater}'),
        ),
        accountName: Text(userModel == null ? 'Name ?' : userModel!.name),
        accountEmail: Text(userModel == null ? 'Type ?' : userModel!.type));
  }

  ListTile menuShowOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1_outlined),
      title: ShowTitle(title: 'เมนูอาหาร', textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(
          title: 'แสดงรายละเอียดของ Order ที่สั่ง',
          textStyle: MyConstant().h3Style()),
    );
  }

  ListTile menuShopManage() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_2_outlined),
      title:
          ShowTitle(title: 'รายละเอียดร้าน', textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(
          title: 'แสดงรายละเอียดของร้านให้ลูกค้าเห็น',
          textStyle: MyConstant().h3Style()),
    );
  }

  ListTile menuShowProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_3_outlined),
      title: ShowTitle(title: 'อาหาร', textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(
          title: 'แสดงรายละเอียดของอาหารที่เราขาย',
          textStyle: MyConstant().h3Style()),
    );
  }
}
