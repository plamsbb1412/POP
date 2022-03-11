import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/wallet_model.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_list_wallet.dart';
import 'package:flutter_application_1/widgets/show_title.dart';

class Wait extends StatefulWidget {
  final List<WalletModel> walletModels;
  const Wait({Key? key, required this.walletModels}) : super(key: key);
  @override
  _WaitState createState() => _WaitState();
}

class _WaitState extends State<Wait> {
  List<WalletModel>? waitWalletModels;

  @override
  void initState() {
    super.initState();
    waitWalletModels = widget.walletModels;
    print('waitList ==> ${waitWalletModels!.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: waitWalletModels?.isEmpty ?? true
          ? Center(
              child: ShowTitle(
              title: 'No Wait Wallet',
              textStyle: MyConstant().h2RedStyle(),
            ))
          : ShowListWallet(walletModels: waitWalletModels),
    );
  }
}
