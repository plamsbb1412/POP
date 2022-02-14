import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/models/sqlite_model.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/utility/my_dialog.dart';
import 'package:flutter_application_1/utility/sqliteHelper.dart';
import 'package:flutter_application_1/widgets/show_image.dart';
import 'package:flutter_application_1/widgets/show_progress.dart';
import 'package:flutter_application_1/widgets/show_title.dart';

class ShowProductBuyer extends StatefulWidget {
  final UserModel userModel;
  const ShowProductBuyer({Key? key, required this.userModel}) : super(key: key);

  @override
  _ShowProductBuyerState createState() => _ShowProductBuyerState();
}

class _ShowProductBuyerState extends State<ShowProductBuyer> {
  UserModel? userModel;
  bool load = true;
  bool? haveProduct;
  List<ProductModel> productModels = [];
  List<List<String>> listImages = [];
  int indexImage = 0;
  int amountInt = 1;
  String? pick;
  String? currentIdStore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    readAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel!.name_store),
      ),
      body: load
          ? ShowProgress()
          : haveProduct!
              ? listProduct()
              : ShowTitle(
                  title: 'ไม่มีเมนูอาหร', textStyle: MyConstant().h1Style()),
    );
  }

  LayoutBuilder listProduct() {
    return LayoutBuilder(
      builder: (context, constraints) => ListView.builder(
        itemCount: productModels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            //  print('### you cilck index ==>> $index ###');
            showalertDialog(
              productModels[index],
              listImages[index],
            );
          },
          child: Card(
            child: Row(
              children: [
                Container(
                  width: constraints.maxWidth * 0.5 - 8,
                  height: constraints.maxHeight * 0.3,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: findUrlImage(productModels[index].image),
                    placeholder: (context, url) => ShowProgress(),
                    errorWidget: (context, url, error) =>
                        ShowImage(path: MyConstant.imageLogo),
                  ),
                ),
                Container(
                  width: constraints.maxWidth * 0.5,
                  height: constraints.maxHeight * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowTitle(
                            title: productModels[index].nameProduct,
                            textStyle: MyConstant().h2Style()),
                        ShowTitle(
                            title: 'ราคา = ${productModels[index].price} บาท',
                            textStyle: MyConstant().h2Style()),
                        ShowTitle(
                            title:
                                'ราคา(พิเศษ) = ${productModels[index].priceSpecial} บาท',
                            textStyle: MyConstant().h2Style()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> readAPI() async {
    String urlAPI =
        '${MyConstant.domain}/Project/StoreRMUTL/API/getProductWhereIDShop.php?isAdd=true&idStore=${userModel!.id}';
    await Dio().get(urlAPI).then(
      (value) {
        // print('###### value =====>>>$value #####');

        if (value.toString() == 'null') {
          setState(() {
            haveProduct = false;
            load = false;
          });
        } else {
          for (var item in json.decode(value.data)) {
            ProductModel model = ProductModel.fromMap(item);

            String string = model.image;
            string = string.substring(1, string.length - 1);
            List<String> strings = string.split(',');
            int i = 0;
            for (var item in strings) {
              strings[i] = item.trim();
              i++;
            }
            listImages.add(strings);

            setState(() {
              haveProduct = true;
              load = false;
              productModels.add(model);
            });
          }
        }
      },
    );
  }

  String findUrlImage(String arrayImage) {
    String string = arrayImage.substring(1, arrayImage.length - 1);
    List<String> strings = string.split(',');
    int index = 0;
    for (var item in strings) {
      strings[index] = item.trim();
      index++;
    }
    String result = '${MyConstant.domain}/Project/StoreRMUTL/API${strings[0]}';
    // print('### result = $result');
    return result;
  }

  Future<Null> showalertDialog(
      ProductModel productModel, List<String> images) async {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: ListTile(
                  leading: ShowImage(path: MyConstant.imageLogo),
                  title: ShowTitle(
                    title: productModel.nameProduct,
                    textStyle: MyConstant().h2Style(),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: 220.0,
                        height: 160.0,
                        child: CachedNetworkImage(
                          imageUrl:
                              '${MyConstant.domain}/Project/StoreRMUTL/API${images[indexImage]}',
                          placeholder: (context, url) => ShowProgress(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 0;
                                  });
                                },
                                icon: Icon(Icons.filter_1)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 1;
                                  });
                                },
                                icon: Icon(Icons.filter_2)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 2;
                                  });
                                },
                                icon: Icon(Icons.filter_3)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 3;
                                  });
                                },
                                icon: Icon(Icons.filter_4)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RadioListTile(
                            title: ShowTitle(
                                title:
                                    'ราคา(ธรรมดา) = ${productModel.price} บาท',
                                textStyle: MyConstant().h3Style()),
                            value: productModel.price,
                            groupValue: pick,
                            onChanged: (value) {
                              setState(() {
                                pick = value as String?;
                              });
                            },
                          ),
                          RadioListTile(
                            title: ShowTitle(
                                title:
                                    'ราคา(พิเศษ) = ${productModel.priceSpecial} บาท',
                                textStyle: MyConstant().h3Style()),
                            value: productModel.priceSpecial,
                            groupValue: pick,
                            onChanged: (value) {
                              setState(() {
                                pick = value as String?;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (amountInt != 1) {
                                  setState(() {
                                    amountInt--;
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: MyConstant.dark,
                              )),
                          ShowTitle(
                              title: amountInt.toString(),
                              textStyle: MyConstant().h1Style()),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  amountInt++;
                                });
                              },
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: MyConstant.dark,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          String idStore = userModel!.id;
                          String idProduct = productModel.id;
                          String name = productModel.nameProduct;
                          String price = productModel.price;
                          String priceSpecial = productModel.priceSpecial;
                          String amount = amountInt.toString();
                          int sumInt = int.parse(pick!) * amountInt;
                          String sum = sumInt.toString();

                          print(
                              '### IDStore = $idStore , IDProduct = $idProduct  , name = $name  price = $price priceSpecial = $priceSpecial amount = $amount sum = $sum');

                          if ((currentIdStore == idStore) ||
                              (currentIdStore == null)) {
                            SQLiteModel sqLiteModel = SQLiteModel(
                                idStore: idStore,
                                idProduct: idProduct,
                                name: name,
                                price: price,
                                priceSpecial: priceSpecial,
                                amount: amount,
                                sum: sum);
                            await SQLiterHelper()
                                .insertValueToSQLite(sqLiteModel)
                                .then((value) {
                              amountInt = 1;
                              Navigator.pop(context);
                            });
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            MyDialog().normalDialog(context, 'ร้านผิด ?',
                                'กรุณาเลือกสินค้าที่ ร้านเดิม ให้เสร็จก่อน เลือกร้านอื่น คะ');
                          }
                        },
                        child: Text(
                          'Add Cart',
                          style: MyConstant().h2BlueStyle(),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: MyConstant().h2RedStyle(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }
}
