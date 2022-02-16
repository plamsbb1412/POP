import 'package:flutter/material.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Bank extends StatefulWidget {
  const Bank({Key? key}) : super(key: key);

  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildTitle(),
          buildKbank(),
        ],
      ),
    );
  }

  Widget buildKbank() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      height: 150,
      child: Center(
        child: Card(
          color: Colors.green.shade100,
          child: ListTile(
            leading: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('images/kbank.svg'),
              ),
            ),
            title: ShowTitle(
              title: 'ธนาคากสิกร ',
              textStyle: MyConstant().h2Style(),
            ),
            subtitle: ShowTitle(
              title: 'ชื่อบัญชี เฉลิมชัย วรรณพันธ์ เลขบัญชี 029-1-15696-7',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTitle(
          title: 'การโอนเงินเข้า บัญชีธนาคาร',
          textStyle: MyConstant().h1Style()),
    );
  }
}
