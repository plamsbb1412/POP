import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/wallet_model.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_image.dart';
import 'package:flutter_application_1/widgets/show_progress.dart';
import 'package:flutter_application_1/widgets/show_title.dart';

class ShowListWallet extends StatelessWidget {
  const ShowListWallet({
    Key? key,
    required this.walletModels,
  }) : super(key: key);

  final List<WalletModel>? walletModels;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: walletModels!.length,
      itemBuilder: (context, index) => Card(
        color:
            index % 2 == 0 ? MyConstant.light.withOpacity(0.75) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShowTitle(
                title: 'จำนวนเงิน:',
                textStyle: MyConstant().h1Style(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShowTitle(
                    title: walletModels![index].money,
                    textStyle: MyConstant().h2RedStyle(),
                  ),
                  Container(
                    width: 120,
                    height: 150,
                    child: CachedNetworkImage(
                        placeholder: (context, url) => ShowProgress(),
                        errorWidget: (context, url, error) =>
                            ShowImage(path: 'images/bill.png'),
                        imageUrl:
                            '${MyConstant.domain}/Project/StoreRMUTL/API/slip${walletModels![index].pathSlip}'),
                  )
                ],
              ),
              ShowTitle(
                title: 'วันเวลา:',
                textStyle: MyConstant().h1Style(),
              ),
              ShowTitle(
                title: walletModels![index].datePay,
                textStyle: MyConstant().h2BlueStyle(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
