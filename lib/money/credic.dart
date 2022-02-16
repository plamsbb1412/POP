import 'package:flutter/material.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_title.dart';

class Credic extends StatefulWidget {
  const Credic({Key? key}) : super(key: key);

  @override
  _CredicState createState() => _CredicState();
}

class _CredicState extends State<Credic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          builtTitle('Name Surname'),
          buildNameSurName(),
          builtTitle('ID Card'),
          formIDCard(),
        ],
      ),
    );
  }

  Container buildNameSurName() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          buildSizebox(30),
          formName(),
          buildSizebox(15),
          formSurName(),
          buildSizebox(30),
        ],
      ),
    );
  }

  SizedBox buildSizebox(double width) {
    return SizedBox(
      width: width,
    );
  }

  Widget formIDCard() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'xxxx-xxxx-xxxx-xxxx',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }

  Widget formName() {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          label: ShowTitle(title: 'Name :'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget formSurName() {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          label: ShowTitle(title: 'SurName :'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget builtTitle(String title) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ShowTitle(
          title: title,
          textStyle: MyConstant().h2BlueStyle(),
        ),
      );
}
