import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/wallet_model.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_list_wallet.dart';
import 'package:flutter_application_1/widgets/show_title.dart';

class Approve extends StatefulWidget {
  final List<WalletModel> walletModels;

  const Approve({Key? key, required this.walletModels}) : super(key: key);
  @override
  _ApproveState createState() => _ApproveState();
}

class _ApproveState extends State<Approve> {
  List<WalletModel>? approveWalletModels;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    approveWalletModels = widget.walletModels;
    print('approve list ==>> ${approveWalletModels!.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: approveWalletModels?.isEmpty ?? true
          ? Center(
              child: ShowTitle(
              title: 'No Money Approve',
              textStyle: MyConstant().h1Style(),
            ))
          : ShowListWallet(
              walletModels: approveWalletModels,
            ),
    );
  }
}
