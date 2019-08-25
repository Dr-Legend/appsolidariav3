import 'package:appsolidariav3/model/polizaModel.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> with AutomaticKeepAliveClientMixin {
  TextEditingController periodoController = TextEditingController();
  TextEditingController treatyValueTEC = TextEditingController();

  String objetoValue;

  bool loading = false;
  final _poliza = Poliza();

  List<String> objetoSeg = [
    "Contrato",
    "Orden compra",
    "Orden servicio",
    "Orden suministro",
    "Factura venta",
    "Pliego condiciones",
  ];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var polizaObj = Provider.of<Poliza>(context);

    return Container(
      child: Card(
          child: Column(
        children: <Widget>[
          ///Campo objeto seguro
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText: "Objeto del seguro", icon: Icon(Icons.store)),
              value: objetoValue,
              onChanged: (String newValue) {
                setState(() {
                  objetoValue = newValue;
                  polizaObj.insuranceObject = newValue;
                });
              },
              validator: (String value) {
                if (value?.isEmpty ?? true) {
                  return 'Favor ingrese el tipo de negocio';
                }
                return null;
              },
              items: objetoSeg.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onSaved: (val) => setState(() => polizaObj.insuranceObject = val),
            ),
          ),
          ///Campo numero de contrato
          //TODO ver si funciona sin controlador
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              //controller: cupoController,
              decoration: InputDecoration(
                  labelText: 'Numero de contrato',
                  icon: Icon(Icons.folder_shared)),
              enabled: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Favor ingresar numero de contrato';
                }
                return null;
              },
              onSaved: (val) => setState(() {
                polizaObj.treatyNumber = val;
              }),
            ),
          ),

          ///Campo valor del contrato
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: treatyValueTEC,
              onChanged: (val) {
                setState(() => polizaObj.treatyValue = double.parse(val));
                polizaObj.notifyListeners();
              },
              onFieldSubmitted: (_) {
                polizaObj.notifyListeners();
              },
              decoration: InputDecoration(
                  labelText: 'Valor del contrato',
                  icon: Icon(Icons.attach_money)),
              enabled: true,
              onEditingComplete: () {
                print("Termine de editar");
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Favor ingresar valor del contrato";
                }
                return null;
              },
              onSaved: (val) =>
                  setState(()
                  {
                    polizaObj.treatyValue = double.parse(val);
                    polizaObj.notifyListeners();
                  })
              ,
            ),
          ),

          ///Campo Plazo ejecución
          Padding(
            //TODO Make it optional
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: periodoController,
              decoration: InputDecoration(
                  labelText: 'Plazo de ejecución',
                  icon: Icon(Icons.folder_shared)),
              enabled: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingresar plazo de ejecución';
                }
                return null;
              },
              onChanged: (val) {
                setState(() {
                  polizaObj.excecutionTime = int.parse(val);
                  //polizaObj.notifyListeners();
                });
              },
              onSaved: (val) =>
                  setState(() => polizaObj.excecutionTime = int.parse(val)),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}


