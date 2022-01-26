import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/states/show_product_buyer.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_progress.dart';
import 'package:flutter_application_1/widgets/show_title.dart';

class ShowAllShopUser extends StatefulWidget {
  const ShowAllShopUser({Key? key}) : super(key: key);

  @override
  _ShowAllShopUserState createState() => _ShowAllShopUserState();
}

class _ShowAllShopUserState extends State<ShowAllShopUser> {
  bool load = true;
  List<UserModel> userModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readApiAllShop();
  }

  Future<Null> readApiAllShop() async {
    String urlAPI =
        '${MyConstant.domain}/Project/StoreRMUTL/API/getUserWhereStore.php';
    await Dio().get(urlAPI).then((value) {
      setState(() {
        load = false;
      });

      // print('value == >>> $value');
      var result = json.decode(value.data);
      //  print('result ==>> $result');
      for (var item in result) {
        //   print('item ==>> $item');
        UserModel model = UserModel.fromMap(item);
        //   print('name = ${model.name}');

        setState(() {
          userModels.add(model);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : GridView.builder(
              itemCount: userModels.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 260),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  //print('You Click');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowProductBuyer(
                          userModel: userModels[index],
                        ),
                      ));
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        child: CachedNetworkImage(
                            placeholder: (context, url) => ShowProgress(),
                            fit: BoxFit.contain,
                            imageUrl:
                                '${MyConstant.domain}${userModels[index].profile_store}'),
                      ),
                      ShowTitle(
                          title: cutWord(userModels[index].name_store),
                          textStyle: MyConstant().h1Style()),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  String cutWord(String name_store) {
    String result = name_store;
    if (result.length > 14) {
      result = result.substring(0, 10);
      result = '$result ...';
    }

    return result;
  }
}
