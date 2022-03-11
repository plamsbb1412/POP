import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/bodys/approve.dart';
import 'package:flutter_application_1/bodys/wair.dart';
import 'package:flutter_application_1/bodys/wallet.dart';
import 'package:flutter_application_1/models/wallet_model.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_no_data.dart';
import 'package:flutter_application_1/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowMoneyUser extends StatefulWidget {
  const ShowMoneyUser({Key? key}) : super(key: key);

  @override
  _ShowMoneyUserState createState() => _ShowMoneyUserState();
}

class _ShowMoneyUserState extends State<ShowMoneyUser> {
  int indexWidget = 0;
  var widgets = <Widget>[];

  var titles = <String>[
    'Wallet',
    'Approve',
    'Wait',
  ];

  var iconDatas = <IconData>[
    Icons.money,
    Icons.fact_check,
    Icons.hourglass_bottom,
  ];

  var bottonNavigationBarItems = <BottomNavigationBarItem>[];

  int approvedWallet = 0, waitApproveWallet = 0;
  bool load = true;
  bool? haveWallet;

  // List<WalletModel> approveWalletModels = [];
  var approveWalletModels = <WalletModel>[];
  var waitWallerModels = <WalletModel>[];

  @override
  void initState() {
    super.initState();
    readAllWallet();
    setUpBottonBar();
  }

  Future<void> readAllWallet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idUser = preferences.getString('id');
    print('idUser ==> $idUser');

    var path =
        '${MyConstant.domain}/Project/StoreRMUTL/API/getWalletWhereidUser.php?isAdd=true&idUser=$idUser';
    await Dio().get(path).then((value) {
      print('### value getWalletWhrerIdBuyer ==>> $value');

      if (value.toString() != 'null') {
        for (var item in json.decode(value.data)) {
          WalletModel model = WalletModel.fromMap(item);
          switch (model.status) {
            case 'Succeed':
              approvedWallet = approvedWallet + int.parse(model.money);
              approveWalletModels.add(model);
              break;
            case 'WaitConfirm':
              waitApproveWallet = waitApproveWallet + int.parse(model.money);
              waitWallerModels.add(model);
              break;
            default:
          }
        }

        print(
            'approveWallet ===> $approvedWallet , waitApproveWallet = $waitApproveWallet');
        widgets.add(Wallet(
          approveWallet: approvedWallet,
          waitApproveWallet: waitApproveWallet,
        ));
        widgets.add(Approve(
          walletModels: approveWalletModels,
        ));
        widgets.add(Wait(
          walletModels: waitWallerModels,
        ));

        setState(() {
          load = false;
          haveWallet = true;
        });
      } else {
        print('### no Wallet Status');

        setState(() {
          load = false;
          haveWallet = false;
        });
      }
    });
  }

  void setUpBottonBar() {
    int index = 0;
    for (var title in titles) {
      bottonNavigationBarItems.add(
        BottomNavigationBarItem(
          label: title,
          icon: Icon(
            iconDatas[index],
          ),
        ),
      );
      index++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveWallet!
              ? widgets[indexWidget]
              : ShowNoData(title: 'No Wallet', pathImage: 'images/logoApp.png'),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: MyConstant.light,
        selectedItemColor: MyConstant.dark,
        onTap: (value) {
          setState(() {
            indexWidget = value;
          });
        },
        currentIndex: indexWidget,
        items: bottonNavigationBarItems,
      ),
    );
  }
}
