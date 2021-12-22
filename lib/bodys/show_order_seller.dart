import 'package:flutter/material.dart';

class ShowOrder extends StatefulWidget {
  const ShowOrder({Key? key}) : super(key: key);

  @override
  _ShowOrderState createState() => _ShowOrderState();
}

class _ShowOrderState extends State<ShowOrder> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('show order'),
    );
  }
}
