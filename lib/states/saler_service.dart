import 'package:flutter/material.dart';
import 'package:flutter_application_1/bodys/shop_manage_seller.dart';
import 'package:flutter_application_1/bodys/show_order_seller.dart';
import 'package:flutter_application_1/bodys/show_product_seller.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_signout.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalerService extends StatefulWidget {
  const SalerService({Key? key}) : super(key: key);

  @override
  _SalerServiceState createState() => _SalerServiceState();
}

class _SalerServiceState extends State<SalerService> {
  List<Widget> widgets = [
    ShowOrder(),
    ShowProduct(),
    Shopmanage(),
  ];

  int indexWidget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            Column(
              children: [
                UserAccountsDrawerHeader(accountName: null, accountEmail: null),
                menuShowOrder(),
                menuShopManage(),
                menuShowProduct(),
              ],
            ),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
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
