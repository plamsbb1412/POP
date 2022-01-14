import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/utility/my_dialog.dart';
import 'package:flutter_application_1/widgets/show_image.dart';
import 'package:flutter_application_1/widgets/show_progress.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:image_picker/image_picker.dart';
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

  final formKey = GlobalKey<FormState>();
  File? file;

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
        '${MyConstant.domain}/Project/StoreRMUTL/API/getUserWhereUser.php?isAdd=true&username=$user';
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
          actions: [
            IconButton(
              onPressed: () => processEditProfileSeller(),
              icon: Icon(Icons.edit),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Form(
              key: formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  buildTitle('รูปโปรไฟล์  :'),
                  buildAvatar(constraints),
                  buildTitle('ข้อมูลทั่วไป :'),
                  buildName(constraints),
                  buildfirstName(constraints),
                  buildlastName(constraints),
                  buildDetails(constraints),
                  buildemail(constraints),
                  buildPhone(constraints),
                  buildTitle('รูปหน้าร้าน  :'),
                  buildAvatar(constraints),
                  buildButtonEditProfile()
                ],
              ),
            ),
          ),
        ));
  }

  Future<Null> processEditProfileSeller() async {
    print('processEditProfileSeller work');
    MyDialog().showProgressDialog(context);

    if (formKey.currentState!.validate()) {
      if (file == null) {
        print('## User Current Avatar');
        editValueToMySQL(userModel!.avater);
      } else {
        String apiSaveAvatar =
            '${MyConstant.domain}/shoppingmall/saveAvatar.php';

        List<String> nameAvatars = userModel!.avater.split('/');
        String nameFile = nameAvatars[nameAvatars.length - 1];
        nameFile = 'edit${Random().nextInt(100)}$nameFile';

        print('## User New Avatar nameFile ==>>> $nameFile');

        Map<String, dynamic> map = {};
        map['file'] =
            await MultipartFile.fromFile(file!.path, filename: nameFile);
        FormData formData = FormData.fromMap(map);
        await Dio().post(apiSaveAvatar, data: formData).then((value) {
          print('Upload Succes');
          String pathAvatar = '/shoppingmall/avatar/$nameFile';
          editValueToMySQL(pathAvatar);
        });
      }
    }
  }

  Future<Null> editValueToMySQL(String pathAvatar) async {
    print('## pathAvatar ==> $pathAvatar');
    String apiEditProfile =
        '${MyConstant.domain}/Project/StoreRMUTL/API/editProfileSellerWhereid.php?isAdd=true&id=${userModel!.id}&name=${userModel!.name}&firstName=${userModel!.firstName}&lastName=${userModel!.lastName}&name_store=${userModel!.name_store}&details=${userModel!.details}&email=${userModel!.email}&phone=${userModel!.phone}&avater=${userModel!.avater}&profile_store=${userModel!.profile_store}';
    await Dio().get(apiEditProfile).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  ElevatedButton buildButtonEditProfile() {
    return ElevatedButton.icon(
      onPressed: () => processEditProfileSeller(),
      icon: Icon(Icons.edit),
      label: Text('แก้ไขข้อมูล'),
    );
  }

  Future<Null> createAvatar({ImageSource? source}) async {
    try {
      var result = await ImagePicker().getImage(
        source: source!,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildAvatar(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Row(
            children: [
              IconButton(
                  onPressed: () => createAvatar(source: ImageSource.camera),
                  icon: Icon(
                    Icons.add_a_photo,
                    color: MyConstant.dark,
                  )),
              Container(
                width: constraints.maxWidth * 0.6,
                height: constraints.maxWidth * 0.6,
                child: userModel == null
                    ? ShowProgress()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: userModel!.avater == null
                            ? ShowImage(path: MyConstant.imageavatar)
                            : file == null
                                ? buildShowImageNetwork()
                                : Image.file(file!),
                      ),
              ),
              IconButton(
                  onPressed: () => createAvatar(source: ImageSource.gallery),
                  icon: Icon(
                    Icons.add_photo_alternate,
                    color: MyConstant.dark,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  CachedNetworkImage buildShowImageNetwork() {
    return CachedNetworkImage(
      imageUrl:
          '${MyConstant.domain}/Project/StoreRMUTL/API${userModel!.avater}',
      placeholder: (context, url) => ShowProgress(),
    );
  }

  Row buildProfile(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_a_photo,
                    color: MyConstant.dark,
                  )),
              Container(
                width: constraints.maxWidth * 0.6,
                height: constraints.maxWidth * 0.6,
                child: userModel == null
                    ? ShowProgress()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: userModel!.avater == null
                            ? ShowImage(path: MyConstant.imageavatar)
                            : CachedNetworkImage(
                                imageUrl:
                                    '${MyConstant.domain}/Project/StoreRMUTL/API${userModel!.profile_store}',
                                placeholder: (context, url) => ShowProgress(),
                              ),
                      ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_photo_alternate,
                    color: MyConstant.dark,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Name';
              } else {
                return null;
              }
            },
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill firstName';
              } else {
                return null;
              }
            },
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill lastName';
              } else {
                return null;
              }
            },
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill NameStore';
              } else {
                return null;
              }
            },
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Details';
              } else {
                return null;
              }
            },
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill email';
              } else {
                return null;
              }
            },
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
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Phone';
              } else {
                return null;
              }
            },
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
