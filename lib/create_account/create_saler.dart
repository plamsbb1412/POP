import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/utility/my_dialog.dart';
import 'package:flutter_application_1/widgets/show_image.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:image_picker/image_picker.dart';

class CreateSaler extends StatefulWidget {
  const CreateSaler({Key? key}) : super(key: key);

  @override
  _CreateSalerState createState() => _CreateSalerState();
}

class _CreateSalerState extends State<CreateSaler> {
  String? sex;
  String avatar = '';
  String profile = '';
  File? file;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController namestoreController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (sex == null) {
                    print('Non Sex Type User');
                    MyDialog().normalDialog(
                        context, 'ยังไม่ได้เลือกเพส', 'กรุณาเลือก เพส ของคุณ');
                  } else {
                    print('Process Sex Type User');
                    uploadPictureAndInsertData();
                  }
                }
              },
              icon: Icon(Icons.cloud_upload))
        ],
        title: Text('สมัครข้อมูลของผู้ซื้อ'),
        backgroundColor: MyConstant.primary,
      ),
      body: Form(
        key: formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTildTitle('username และ password  '),
                buildUser(size),
                buildPassword(size),
                buildTildTitle('ข้อมูลทั่วไป '),
                buildFirstName(size),
                buildLastName(size),
                buildName(size),
                buildNameStore(size),
                buildEmail(size),
                buildPhone(size),
                buildTildTitle('เพส  '),
                buildRadioMan(size),
                buildRadiofemale(size),
                buildTildTitle('รูปภาพ'),
                buildSubTitle('รูปภาพโปรไฟล์'),
                buildAvater(size),
                buildTildTitle('รูปภาพ'),
                buildSubTitle('รูปภาพหน้าร้าน'),
                buildProfile(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> uploadPictureAndInsertData() async {
    String typeUser = 'store';
    String username = usernameController.text;
    String password = passwordController.text;
    String firstname = firstnameController.text;
    String lastname = lastnameController.text;
    String name = nameController.text;
    String namestore = namestoreController.text;
    String email = emailController.text;
    String phone = phoneController.text;

    print(
        'sex==$sex, type = $typeUser , username ==$username , password == $password , firtname == $firstname , lastname == $lastname , name == $name , name_store == $namestore ,email == $email ,phone == $phone');

    String path =
        '${MyConstant.domain}/Project/StoreRMUTL/AIP/getUserWhereUser.php?isAdd=true&username=$username';
    await Dio().get(path).then((value) async {
      print('value ===>>>> $value');
      if (value.toString() == 'null') {
        print('## สมัครได้นะ ##');
        if (file == null) {
          // no avata
          processInsertMySQL(
            name: name,
            firstname: firstname,
            lastname: lastname,
            namestore: namestore,
            email: email,
            phone: phone,
            username: username,
            password: password,
          );
        } else {
          // have avata
          String apiSaveAvtar =
              '${MyConstant.domain}/Project/StoreRMUTL/AIP/saveAvatarStore.php';

          String apiSaveProfile =
              '${MyConstant.domain}/Project/StoreRMUTL/AIP/saveProfileStore.php';

          int i = Random().nextInt(100000);
          String nameAvatar = 'avatarStore$i.jpg';
          String nameProfile = 'avatarProfile$i.jpg';
          Map<String, dynamic> map = Map();
          map['file'] =
              await MultipartFile.fromFile(file!.path, filename: nameAvatar);
          MultipartFile.fromFile(file!.path, filename: nameProfile);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveAvtar, data: data).then((value) {
            avatar = '/Project/StoreRMUTL/avatarstore/$nameAvatar';
          
            processInsertMySQL();
          });
        }
      } else {
        MyDialog().normalDialog(context, 'username นี้มีคนผู่ใช้แล้ว',
            'กรุณาเปลี่ยน username ใหม่ด้วย');
      }
    });
  }

  Future<Null> processInsertMySQL({
    String? name,
    String? firstname,
    String? lastname,
    String? namestore,
    String? email,
    String? phone,
    String typeUser = 'store',
    String? username,
    String? password,
  }) async {
    print('processMySQL work $avatar');
    print('processMySQL work $profile');
    String apiInserUset =
        '${MyConstant.domain}/Project/StoreRMUTL/AIP/insertStore.php?isAdd=true&name=$name&firstName=$firstname&lastName=$lastname&name_store=$namestore&email=$email&phone=$phone&sex=$sex&type=$typeUser&username=$username&password=$password&avater=$avatar&profile_store=$profile';
    await Dio().get(apiInserUset).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(context, 'ไม่สามารถสมัครได้',
            'ไม่สามาสมัครสมาชิกได้โปรลองใหม่อีกครั้ง');
      }
    });
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxHeight: 800,
        maxWidth: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Future<Null> chooseImage1(ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxHeight: 800,
        maxWidth: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildAvater(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.6,
          child: file == null
              ? ShowImage(path: MyConstant.imageavatar)
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
      ],
    );
  }

  Row buildProfile(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => chooseImage1(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.6,
          child: file == null
              ? ShowImage(path: MyConstant.imageavatar)
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage1(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
      ],
    );
  }

  ShowTitle buildSubTitle(String title) {
    return ShowTitle(
      title: title,
      textStyle: MyConstant().h3Style(),
    );
  }

  Row buildRadioMan(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'ชาย',
            groupValue: sex,
            onChanged: (value) {
              setState(() {
                sex = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ชาย',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadiofemale(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'หญิง',
            groupValue: sex,
            onChanged: (value) {
              setState(() {
                sex = value as String?;
              });
            },
            title: ShowTitle(
              title: 'หญิง',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: usernameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Username ด้วย';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Username :',
              prefixIcon: Icon(
                Icons.account_circle,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Password ด้วย';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Password :',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildFirstName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: firstnameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก ขื่อ ด้วย';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'ชื่อ : ',
              prefixIcon: Icon(
                Icons.account_circle,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก ขื่อเล่น ด้วย';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'ชื่อเล่น : ',
              prefixIcon: Icon(
                Icons.account_circle,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildNameStore(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: namestoreController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก ขื่อร้านค้า ด้วย';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'ชื่อร้านค้า : ',
              prefixIcon: Icon(
                Icons.account_circle,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildLastName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: lastnameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก นามสกุล ด้วย';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'นามสกุล : ',
              prefixIcon: Icon(
                Icons.account_circle,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildEmail(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Email ด้วย';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Email : ',
              prefixIcon: Icon(
                Icons.email,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก เบอร์โทรศัพท์ ด้วย';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'เบอร์โทรศัพท์ : ',
              prefixIcon: Icon(
                Icons.phone_android,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ShowTitle buildTildTitle(String title) {
    return ShowTitle(
      title: title,
      textStyle: MyConstant().h2Style(),
    );
  }
}
