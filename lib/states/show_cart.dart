import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/sqlite_model.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/wallet_model.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/utility/my_dialog.dart';
import 'package:flutter_application_1/utility/sqliteHelper.dart';
import 'package:flutter_application_1/widgets/show_image.dart';
import 'package:flutter_application_1/widgets/show_no_data.dart';
import 'package:flutter_application_1/widgets/show_progress.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCart extends StatefulWidget {
  const ShowCart({Key? key}) : super(key: key);

  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<SQLiteModel> sqliteModels = [];
  bool load = true;
  UserModel? userModel;
  int? total;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processReadSQLite();
  }

  Future<Null> processReadSQLite() async {
    if (sqliteModels.isNotEmpty) {
      sqliteModels.clear();
    }

    await SQLiterHelper().readSQLite().then((value) {
      print('#### value on pricessReadSQLite ==>>> $value');
      setState(() {
        load = false;
        sqliteModels = value;
        findDetailStore();
        calculateTotal();
      });
    });
  }

  void calculateTotal() async {
    total = 0;
    for (var item in sqliteModels) {
      int sumInt = int.parse(item.sum.trim());
      setState(() {
        total = total! + sumInt;
      });
    }
  }

  Future<void> findDetailStore() async {
    String idStore = sqliteModels[0].idStore;
    print('idstore == $idStore');
    String apiGetUserWhereId =
        '${MyConstant.domain}/Project/StoreRMUTL/API/getUserWhereId.php?isAdd=true&id=$idStore';
    await Dio().get(apiGetUserWhereId).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้า'),
      ),
      body: load
          ? ShowProgress()
          : sqliteModels.isEmpty
              ? ShowNoData(
                  title: 'ยังไม่มีเมนูอาหารในตะกร้า',
                  pathImage: MyConstant.imageLogo,
                )
              : buildContent(),
    );
  }

  Container buildContent() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showSeller(),
          buildHead(),
          listProduct(),
          buildDivider(),
          buildTotal(),
          buildDivider(),
          buttonController(),
        ],
      ),
    );
  }

  Future<void> confirmEmptyCart() async {
    // print('### confirmEmptyCart Work');
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: ListTile(
                leading: ShowImage(path: MyConstant.imageLogo),
                title: ShowTitle(
                    title: 'คุณต้องการจะ delete ?',
                    textStyle: MyConstant().h2BlueStyle()),
                subtitle: ShowTitle(
                    title: 'Product ทั้งหมด ใน ตะกร้า ใช่ไหม ?',
                    textStyle: MyConstant().h3Style()),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await SQLiterHelper().emptySQLite().then((value) {
                      Navigator.pop(context);
                      processReadSQLite();
                    });
                  },
                  child: Text('Delete'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ],
            ));
  }

  Row buttonController() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () async {
            MyDialog().showProgressDialog(context);

            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            String idBuyer = preferences.getString('id')!;

            var path =
                '${MyConstant.domain}/Project/StoreRMUTL/API/getWalletWhereidUser.php?isAdd=true&idUser=$idBuyer';
            await Dio().get(path).then((value) {
              Navigator.pop(context);
              print('#### value == $value');
              if (value.toString() == 'null') {
                print('#### action Alert add Wallet');
                MyDialog(
                  funcAction: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, MyConstant.routeAddwallet);
                  },
                ).actionDialog(context, 'No Wallet', 'Please Add Waller');
              } else {
                print('#12feb check Wallet can Payment');

                int approveWallet = 0;
                for (var item in json.decode(value.data)) {
                  WalletModel walletModel = WalletModel.fromMap(item);
                  if (walletModel.status == 'Approve') {
                    approveWallet =
                        approveWallet + int.parse(walletModel.money.trim());
                  }
                }
                print('#12feb approveWallet ==> $approveWallet');
                if (approveWallet - total! >= 0) {
                  print('#12feb Can Order');
                  MyDialog(funcAction: orderFunc).actionDialog(
                      context,
                      'Confirm Order ?',
                      'Order Total : $total thb \n Please Confirm Order');
                } else {
                  print('#12feb Cannot Order');
                  MyDialog().normalDialog(context, 'Cannot Order ?',
                      'จำนวนเงินที่มี : $approveWallet thb \n ราคา : $total thb \n จำนวนเงิน ไม่พอจ่าย คุณรอให้ Admin ทำการตรวจสอบก่อนหรือ Add Wallet เข้ามา');
                }
              }
            });
          },
          child: Text('Order'),
        ),
        Container(
          margin: EdgeInsets.only(left: 4, right: 8),
          child: ElevatedButton(
            onPressed: () => confirmEmptyCart(),
            child: Text('Empty Cart'),
          ),
        ),
      ],
    );
  }

  Row buildTotal() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShowTitle(
                title: 'ยอดอาหาร:',
                textStyle: MyConstant().h2BlueStyle(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowTitle(
                title: total == null ? '' : '${total.toString()} บาท',
                textStyle: MyConstant().h1Style(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Divider buildDivider() {
    return Divider(
      color: MyConstant.dark,
    );
  }

  ListView listProduct() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ShowTitle(
                title: sqliteModels[index].name,
                textStyle: MyConstant().h3Style(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ShowTitle(
              title: sqliteModels[index].amount,
              textStyle: MyConstant().h3Style(),
            ),
          ),
          Expanded(
            flex: 2,
            child: ShowTitle(
              title: sqliteModels[index].price,
              textStyle: MyConstant().h3Style(),
            ),
          ),
          Expanded(
            flex: 2,
            child: ShowTitle(
              title: sqliteModels[index].sum,
              textStyle: MyConstant().h3Style(),
            ),
          ),
          Expanded(
              flex: 2,
              child: IconButton(
                  onPressed: () async {
                    int idSQLite = sqliteModels[index].id!;
                    await SQLiterHelper()
                        .deleteSQLiteWhereId(idSQLite)
                        .then((value) => processReadSQLite());
                  },
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red.shade700,
                  ))),
        ],
      ),
    );
  }

  Container buildHead() {
    return Container(
      decoration: BoxDecoration(color: MyConstant.light),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: ShowTitle(
                title: 'รายการอาหาร',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            Expanded(
              flex: 2,
              child: ShowTitle(
                title: 'จำนวน',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            Expanded(
              flex: 2,
              child: ShowTitle(
                title: 'ราคา',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            Expanded(
              flex: 2,
              child: ShowTitle(
                title: 'รวม',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }

  Padding showSeller() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ShowTitle(
            title: 'สรุปรายการสั่งอาหาร',
            textStyle: MyConstant().h1Style(),
          ),
          Row(
            children: [
              Expanded(
                  flex: 5,
                  child: ShowTitle(
                      title: 'เลขคิว:', textStyle: MyConstant().h2Style())),
              Expanded(
                  flex: 5,
                  child: ShowTitle(
                      title:
                          userModel == null ? '' : 'ร้าน: ${userModel!.name}',
                      textStyle: MyConstant().h2Style())),
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 5,
                  child: ShowTitle(
                      title: 'วันที่:', textStyle: MyConstant().h2Style())),
              Expanded(
                  flex: 5,
                  child: ShowTitle(
                      title: 'เวลา: ', textStyle: MyConstant().h2Style())),
            ],
          )
        ],
      ),
    );
  }

  Future<void> orderFunc() async {
    Navigator.pop(context);
    print('orderFucn work');
  }
}
