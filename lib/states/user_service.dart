import 'package:flutter/material.dart';
import 'package:flutter_application_1/bodys/my_money_user.dart';
import 'package:flutter_application_1/bodys/my_order_user.dart';
import 'package:flutter_application_1/bodys/show_all_shop.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_signout.dart';
import 'package:flutter_application_1/widgets/show_title.dart';

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
                buildHeader,
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

  UserAccountsDrawerHeader get buildHeader =>
      UserAccountsDrawerHeader(accountName: null, accountEmail: null);
}
