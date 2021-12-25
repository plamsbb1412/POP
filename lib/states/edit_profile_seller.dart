import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileStore extends StatefulWidget {
  const EditProfileStore({Key? key}) : super(key: key);

  @override
  _EditProfileStoreState createState() => _EditProfileStoreState();
}

class _EditProfileStoreState extends State<EditProfileStore> {
  UserModel? userModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController nameStoreController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user = preferences.getString('user')!;
    print('Usersoter ===>>> $user');

    String apiGetUser =
        '${MyConstant.domain}/Project/StoreRMUTL/AIP/getUserWhereUser.php?isAdd=true&username=$user';
    await Dio().get(apiGetUser).then((value) {
      print('value from API ==>> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          nameController.text = userModel!.name;
          firstNameController.text = userModel!.firstName;
          lastNameController.text = userModel!.lastName;
          nameStoreController.text = userModel!.name_store;
          detailsController.text = userModel!.details;
          emailController.text = userModel!.email;
          phoneController.text = userModel!.phone;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile Store'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => ListView(
            padding: EdgeInsets.all(16),
            children: [
              buildTitle('รูปโปรไฟล์  :'),
              buildTitle('ข้อมูลทั่วไป :'),
              buildName(constraints),
              buildfirstName(constraints),
              buildlastName(constraints),
              buildDetails(constraints),
              buildemail(constraints),
              buildPhone(constraints),
            ],
          ),
        ));
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'ชื่อ :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildfirstName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: firstNameController,
            decoration: InputDecoration(
              labelText: 'ชื่อจริง :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildlastName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: lastNameController,
            decoration: InputDecoration(
              labelText: 'นามสกุล :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildNameStore(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: nameStoreController,
            decoration: InputDecoration(
              labelText: 'ชื่อร้าน :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildDetails(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            maxLines: 3,
            controller: detailsController,
            decoration: InputDecoration(
              labelText: 'รายละเอียดร้าน :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildemail(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'เบอร์โทร :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Padding buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTitle(title: title, textStyle: MyConstant().h2Style()),
    );
  }
}
