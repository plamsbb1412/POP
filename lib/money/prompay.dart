import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/utility/my_dialog.dart';
import 'package:flutter_application_1/widgets/show_progress.dart';
import 'package:flutter_application_1/widgets/show_title.dart';

class Prompay extends StatefulWidget {
  const Prompay({Key? key}) : super(key: key);

  @override
  _PrompayState createState() => _PrompayState();
}

class _PrompayState extends State<Prompay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildTitle(),
            builCopyPrompay(),
            buildQRcodePrompay(),
            buildDownload(),
          ],
        ),
      ),
    );
  }

  ElevatedButton buildDownload() => ElevatedButton(
        onPressed: () async {
          String path = '/sdcard/download';
          try {
            await FileUtils.mkdir([path]);
            await Dio()
                .download(MyConstant.urlPrompay, '$path/prompay.png')
                .then((value) => MyDialog().normalDialog(
                    context,
                    'Download Prompay Finish',
                    'กรุณาไปที่แอพธนาคาร เพื่ออ่าน QR code ที่โหลดมา'));
          } catch (e) {
            print('## error ==>> ${e.toString()}');
            MyDialog().normalDialog(context, 'Storage Permission Denied',
                'กรุณาเปิด Permission Storage ด้วยคะ');
          }
        },
        child: Text('Download QRcode'),
      );

  Container buildQRcodePrompay() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: CachedNetworkImage(
        imageUrl: MyConstant.urlPrompay,
        placeholder: (context, url) => ShowProgress(),
      ),
    );
  }

  Widget builCopyPrompay() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: Colors.lime.shade100,
        child: ListTile(
          title: ShowTitle(
            title: '087-6586332',
            textStyle: MyConstant().h1Style(),
          ),
          subtitle: ShowTitle(
            title: 'บัญชี Prompay',
          ),
          trailing: IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: '0876586332'));
                MyDialog().normalDialog(context, 'Copy Prompay',
                    'Copy Prompay เรียบร้อยแล้วกรุณาไปที่ แอพธนาคารของ ท่าน เพื่อโอนเงิน ผ่าน Prompay ได้เลย น๊าบบบบ');
              },
              icon: Icon(
                Icons.copy,
                color: MyConstant.dark,
              )),
        ),
      ),
    );
  }

  ShowTitle buildTitle() {
    return ShowTitle(
      title: 'การโอนเงิน Prompay',
      textStyle: MyConstant().h2Style(),
    );
  }
}
