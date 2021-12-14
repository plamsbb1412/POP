import 'package:flutter/material.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_image.dart';
import 'package:flutter_application_1/widgets/show_title.dart';

class ChooseAccount extends StatefulWidget {
  const ChooseAccount({Key? key}) : super(key: key);

  @override
  _ChooseAccountState createState() => _ChooseAccountState();
}

class _ChooseAccountState extends State<ChooseAccount> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('เลือกบัญชีผู้ใช้'),
        backgroundColor: MyConstant.primary,
      ),
      body: ListView(
        children: [
          buildImage(size),
          buildAppName(),
          buildTildTitle('คนขาย'),
          buildCreateSaler(size),
          buildTildTitle('ผู้ซื้อ'),
          buildCreateUser(size),
        ],
      ),
    );
  }

  ShowTitle buildTildTitle(String title) {
    return ShowTitle(
      title: title,
      textStyle: MyConstant().h2Style(),
    );
  }

  Row buildAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: MyConstant.appName,
          textStyle: MyConstant().h1Style(),
        ),
      ],
    );
  }

  Row buildCreateSaler(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size * 0.6,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () =>
                Navigator.pushNamed(context, MyConstant.routeCreateSaler),
            child: Text('Saler'),
          ),
        ),
      ],
    );
  }

  Row buildCreateUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          width: size * 0.6,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () =>
                Navigator.pushNamed(context, MyConstant.routeCreateUser),
            child: Text('User'),
          ),
        ),
      ],
    );
  }

  Row buildImage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: ShowImage(path: MyConstant.imageLogo),
        ),
      ],
    );
  }
}
