import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
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
            print('### you cilck index ==>> $index ###');
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
        print('###### value =====>>>$value #####');

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
    print('### result = $result');
    return result;
  }

  Future<Null> showalertDialog(
      ProductModel productModel, List<String> images) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.imageLogo),
          title: ShowTitle(
            title: productModel.nameProduct,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: Column(
            children: [
              ShowTitle(
                  title: 'ราคา(ธรรมดา) = ${productModel.price} บาท',
                  textStyle: MyConstant().h3Style()),
              ShowTitle(
                  title: 'ราคา(พิเศษ) = ${productModel.priceSpecial} บาท',
                  textStyle: MyConstant().h3Style()),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
                imageUrl:
                    '${MyConstant.domain}/Project/StoreRMUTL/API${images[0]}'),
            IconButton(onPressed: () {}, icon: Icon(Icons.filter_1))
          ],
        ),
      ),
    );
  }
}
