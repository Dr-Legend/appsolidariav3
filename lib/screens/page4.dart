import 'package:appsolidariav3/model/polizaModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    var polizaObj = Provider.of<Poliza>(context);
    return Container(
      child: Text(polizaObj.toString()),
    );
  }
}
