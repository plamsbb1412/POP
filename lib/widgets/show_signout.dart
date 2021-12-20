import 'package:flutter/material.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear().then(
                  (value) => Navigator.pushNamedAndRemoveUntil(
                      context, MyConstant.routeLogin, (route) => false),
                );
          },
          tileColor: Colors.red.shade900,
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          title: ShowTitle(
            title: 'Sign Out',
            textStyle: MyConstant().h2whistStyle(),
          ),
          subtitle: ShowTitle(
              title: 'Sign Out And Go to Login',
              textStyle: MyConstant().h3whisStyle()),
        ),
      ],
    );
  }
}
