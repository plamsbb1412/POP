import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_progress.dart';
import 'package:flutter_application_1/widgets/show_title.dart';

class Shopmanage extends StatefulWidget {
  final UserModel userModel;
  const Shopmanage({Key? key, required this.userModel}) : super(key: key);

  @override
  _ShopmanageState createState() => _ShopmanageState();
}

class _ShopmanageState extends State<Shopmanage> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(
      builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShowTitle(
                title: 'รูปโปรไฟล์ :', textStyle: MyConstant().h2Style()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: constraints.maxWidth * 0.6,
                child: CachedNetworkImage(
                  imageUrl:
                      '${MyConstant.domain}/Project/StoreRMUTL/AIP${userModel!.avater}',
                  placeholder: (context, url) => ShowProgress(),
                ),
              ),
            ],
          ),
          ShowTitle(title: 'ชื่อคนขาย :', textStyle: MyConstant().h2Style()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ShowTitle(
                    title: userModel!.name, textStyle: MyConstant().h1Style()),
              ),
            ],
          ),
          ShowTitle(title: 'ชื่อร้าน :', textStyle: MyConstant().h2Style()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ShowTitle(
                    title: userModel!.name_store,
                    textStyle: MyConstant().h1Style()),
              ),
            ],
          ),
          ShowTitle(
              title: 'รายละเอียดของร้าน :', textStyle: MyConstant().h2Style()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: constraints.maxWidth * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShowTitle(
                          title: userModel!.details,
                          textStyle: MyConstant().h2Style()),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShowTitle(
                title: 'เบอร์โทร :  ${userModel!.phone}',
                textStyle: MyConstant().h2Style()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShowTitle(
                title: 'รูปร้าน :', textStyle: MyConstant().h2Style()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: constraints.maxWidth * 0.6,
                child: CachedNetworkImage(
                  imageUrl:
                      '${MyConstant.domain}/Project/StoreRMUTL/AIP${userModel!.profile_store}',
                  placeholder: (context, url) => ShowProgress(),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
