import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/utility/my_dialog.dart';
import 'package:flutter_application_1/widgets/show_image.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfimeAddWallet extends StatefulWidget {
  const ConfimeAddWallet({Key? key}) : super(key: key);

  @override
  _ConfimeAddWalletState createState() => _ConfimeAddWalletState();
}

class _ConfimeAddWalletState extends State<ConfimeAddWallet> {
  String? dateTimeStr;
  File? file;
  var formKey = GlobalKey<FormState>();

  String? idUser;
  TextEditingController moneyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    findCurrentTime();
    findIdBuyer();
  }

  Future<void> findIdBuyer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idUser = preferences.getString('id');
  }

  void findCurrentTime() {
    DateTime dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    setState(() {
      dateTimeStr = dateFormat.format(dateTime);
    });
    print('dateTimeStr = $dateTimeStr');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Add Wallet'),
        leading: IconButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, MyConstant.routeUserService, (route) => false),
          icon: Platform.isIOS
              ? Icon(Icons.arrow_back_ios)
              : Icon(Icons.arrow_back),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    newHeader(),
                    newDateTimePay(),
                    builtTitle('ยอดเงินที่ต้องการโอน :'),
                    newMoney(),
                    builtTitle('รูปสลิปหลักฐานการโอน :'),
                    newImage(),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  newButtonConfirm(),
                ],
              ),
            ],
          ),
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

  Row newMoney() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          child: TextFormField(
            controller: moneyController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณาใส่จำนวนเงิน ?';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              label: ShowTitle(title: 'Money :'),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Container newButtonConfirm() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (file == null) {
              MyDialog().normalDialog(context, 'ยังไม่มีรูปภาพ',
                  'กรุณา ถ่ายภาพ หรือ ใข้ภาพจาก คลังภาพ');
            } else {
              processUploadAndInsertData();
            }
          }
        },
        child: Text('Confirm Add Wallet'),
      ),
    );
  }

  Future<void> processUploadAndInsertData() async {
    // upload Image to Server
    String apiSaveSlip =
        '${MyConstant.domain}/Project/StoreRMUTL/API/saveslip.php';
    String nameSlip = 'slip${Random().nextInt(1000000)}.jpg';

    MyDialog().showProgressDialog(context);

    try {
      Map<String, dynamic> map = {};
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameSlip);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveSlip, data: data).then((value) async {
        print('value --> $value');
        Navigator.pop(context);

        // insert value to mySQL
        var pathSlip = '/$nameSlip';
        var status = 'WaitConfirm';
        var urlAPIinsert =
            '${MyConstant.domain}/Project/StoreRMUTL/API/insertWallet.php?isAdd=true&idUser=$idUser&datePay=$dateTimeStr&money=${moneyController.text.trim()}&pathSlip=$pathSlip&status=$status';
        await Dio().get(urlAPIinsert).then(
              (value) => MyDialog(funcAction: success).actionDialog(
                context,
                'Confirm Success',
                'Comfirm Add Money to Wallet Success',
              ),
            );
      });
    } catch (e) {}
  }

  void success() {
    Navigator.pushNamedAndRemoveUntil(
        context, MyConstant.routeUserService, (route) => false);
    print('Success Work');
  }

  Future<void> processTakePhoto(ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row newImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => processTakePhoto(ImageSource.camera),
          icon: Icon(Icons.add_a_photo),
        ),
        Container(
          width: 200,
          height: 200,
          child: file == null
              ? ShowImage(path: 'images/bill.png')
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => processTakePhoto(ImageSource.gallery),
          icon: Icon(Icons.add_photo_alternate),
        ),
      ],
    );
  }

  Padding newDateTimePay() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ShowTitle(
          title: dateTimeStr == null ? 'dd/MM/yy HH:mm' : dateTimeStr!,
          textStyle: MyConstant().h2BlueStyle(),
        ),
      ),
    );
  }

  Padding newHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ShowTitle(
          title: 'วันที่จ่ายและเวลา',
          textStyle: MyConstant().h1Style(),
        ),
      ),
    );
  }
}
