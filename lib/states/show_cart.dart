import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/sqlite_model.dart';
import 'package:flutter_application_1/utility/sqliteHelper.dart';

class ShowCart extends StatefulWidget {
  const ShowCart({Key? key}) : super(key: key);

  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<SQLiteModel> sqliteModels = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processReadSQlit();
  }

  Future<Null> processReadSQlit() async {
    await SQLiterHelper().readSQLite().then((value) {
      setState(() {
        sqliteModels = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShowCart'),
      ),
    );
  }
}
