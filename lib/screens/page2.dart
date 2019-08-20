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
                  keyboardType: TextInputType.number,
                ),
              ),

              ///Campo valor del contrato
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  //controller: cupoController,
                  onChanged: (val) {
                    setState(() => polizaObj.treatyValue = double.parse(val));
                    //polizaObj.notifyListeners();
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
                  keyboardType: TextInputType.number,
                  onSaved: (val) =>
                      setState(() => polizaObj.treatyValue = double.parse(val)),
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
                      polizaObj.notifyListeners();
                    });
                  },
                  keyboardType: TextInputType.number,
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

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> with AutomaticKeepAliveClientMixin {
  TextEditingController porcentajeTEC;
  TextEditingController vlrAmparoTEC;
  List<TextEditingController> listPorcentajeTEC;
  List<TextEditingController> listVlrAmparoTEC;
  List<TextEditingController> listInitialDateTEC;
  List<TextEditingController> listFinalDateTEC;

  TextEditingController initialDateTEC;
  TextEditingController finalDateTEC;
  DateFormat dateFormat;

  DateTime _fechaEmision = DateTime.now();
  DateTime minDate;

  @override
  void initState() {
    porcentajeTEC = TextEditingController();
    vlrAmparoTEC = TextEditingController();

    initializeDateFormatting();
    dateFormat = new DateFormat('dd-MM-yyyy'); //new DateFormat.yMMMMd('es');
    ///Define fecha mínima como control del sistema.
    minDate = DateTime(
        _fechaEmision.year, _fechaEmision.month - 5, _fechaEmision.day);

    super.initState();
  }

  @override
  void dispose() {
    porcentajeTEC.dispose();
    vlrAmparoTEC.dispose();
    listPorcentajeTEC.map((tec){
      tec.dispose();
    });
    listVlrAmparoTEC.map((tec){
      tec.dispose();
    });
    listInitialDateTEC.map((tec){
      tec.dispose();
    });
    listFinalDateTEC.map((tec){
      tec.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var polizaObj = Provider.of<Poliza>(context);
    return Container(
      child: Card(
          margin: const EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                  polizaObj.covers != null ? polizaObj.covers.length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    listPorcentajeTEC = polizaObj.covers.map((a){
                      return TextEditingController();
                    }).toList();
                    listVlrAmparoTEC = polizaObj.covers.map((a){
                      return TextEditingController();
                    }).toList();
                    listInitialDateTEC = polizaObj.covers.map((a){
                      return TextEditingController();
                    }).toList();
                    listFinalDateTEC = polizaObj.covers.map((a){
                      return TextEditingController();
                    }).toList();


                    listPorcentajeTEC[index].text = polizaObj.covers[index].porcentage.toString();
                    listVlrAmparoTEC[index].text = (polizaObj.covers[index].porcentage * polizaObj.treatyValue).toString();
                    listInitialDateTEC[index].text = polizaObj.policyInitialDate; //DateTime.parse((polizaObj.policyInitialDate.substring(6, 10) + polizaObj.policyInitialDate.substring(3, 5) + polizaObj.policyInitialDate.substring(0, 2))).toString();
                              listFinalDateTEC[index].text = dateFormat.format(DateTime.parse(((int.parse(polizaObj.policyInitialDate.substring(6, 10)) + polizaObj.excecutionTime + polizaObj.covers[index].additionalTerm).toString() + polizaObj.policyInitialDate.substring(3, 5) + polizaObj.policyInitialDate.substring(0, 2))));
                    /*
                    listVlrAmparoTEC[index] = TextEditingController();
                    listInitialDateTEC[index] = TextEditingController();
                    listFinalDateTEC[index] = TextEditingController();
                    */
                    //listPorcentajeTEC[index].text = polizaObj.amparos[index].porcentaje.toString();



                    ///Campo amparos -------------------------------------------------------
                    return Dismissible(
                        key: UniqueKey(),
                        //confirmDismiss: ,
                        background: Container(
                          padding: EdgeInsets.all(12.0),
                          color: Colors.green,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              Padding(padding: EdgeInsets.all(4.0)),
                              Text(
                                "Confirmar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        secondaryBackground: Container(
                          padding: EdgeInsets.all(12.0),
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              Padding(padding: EdgeInsets.all(4.0)),
                              Text(
                                "Eliminar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            if (direction == DismissDirection.endToStart) {
                              polizaObj.covers.removeAt(index);
                            } else {
                              print("Amparo confirmado");
                            }
                          });
                        },

                        ///Porcentage Field
                        child: SizedBox(
                          width: double.infinity,
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            title: Text(polizaObj.covers[index].coverName),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: listPorcentajeTEC[index],
                                  decoration: InputDecoration(
                                      labelText: "Porcentaje:",
                                      icon: Icon(Icons.assessment)),
                                  //initialValue: polizaObj.amparos[index].porcentaje.toString(),
                                  onChanged: (val) {
                                    polizaObj.covers[index].porcentage = double.parse(val);
                                    /*
                                    Future.delayed(const Duration(seconds: 3)).then((val){
                                      polizaObj.notifyListeners();
                                    });
                                    */
                                  },
                                  onFieldSubmitted: (_) {
                                    polizaObj.notifyListeners();
                                  },
                                  onSaved: (val) {
                                    polizaObj.covers[index].porcentage = double.parse(val);
                                  },
                                ),
                              ),

                              ///Cover Insured Value Field
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: listVlrAmparoTEC[index],
                                  decoration: InputDecoration(
                                      labelText: "Vlr. Asegurado amparo:",
                                      icon: Icon(Icons.assessment)),
                                  onChanged: (val){
                                    listVlrAmparoTEC[index].text = val;
                                  },
                                  onSaved: (val){
                                    polizaObj.covers[index].insuredValue = double.parse(val);
                                  },
                                  //initialValue: polizaObj.treatyValue != null ? (polizaObj.covers[index].porcentage * polizaObj.treatyValue).toString() : "",
                                ),
                              ),

                              ///Initial Date Cover Field
                              DateTimeField(
                                format: dateFormat,
                                controller: listInitialDateTEC[index],
                                //Lo agregue ver si es necesario
                                onShowPicker: (context, currentValue) async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate: currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                  /*
                                  if (date != null) {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          currentValue ?? DateTime.now()),
                                    );
                                    return DateTimeField.combine(date, time);
                                  } else {
                                    return currentValue;
                                  }
                                  */
                                  return date;
                                },
                                autovalidate: true,
                                //TODO FIX Validator
                    /*
                    validator: (value) {
                                  print("Value in fecha Inicial $value");
                                  if (value == null) {
                                    return 'Debe ingresar una fecha inicial valida';
                                  } else if (minDate.isAfter(value)) {
                                    return 'Retroactividad máxima superada';
                                  }
                                  return "";
                                },
                                */
                                //initialValue: (polizaObj.policyInitialDate != null && polizaObj.policyInitialDate.length == 10) ? DateTime.parse((polizaObj.policyInitialDate.substring(6, 10) + polizaObj.policyInitialDate.substring(3, 5) + polizaObj.policyInitialDate.substring(0, 2))) : DateTime.now(),
                                onChanged: (date){
                                  listInitialDateTEC[index].text = dateFormat.format(date);
                                },
                                onSaved: (DateTime date) {
                                  print("InitialDate: $date");
                                    listInitialDateTEC[index].text = dateFormat.format(date);
                                    polizaObj.covers[index].inicialDate = listInitialDateTEC[index].text;
                                },
                                onFieldSubmitted: (val){
                                  polizaObj.notifyListeners();
                                },
                                resetIcon: Icon(Icons.delete),
                                readOnly: false,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.date_range),
                                    labelText: 'Vigencia Desde amparo'),
                              ),

                              ///Final Date Cover Field
                              DateTimeField(
                                format: dateFormat,
                                controller: listFinalDateTEC[index],
                                onShowPicker: (context, currentValue) async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate: currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                  /*
                                  if (date != null) {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          currentValue ?? DateTime.now()),
                                    );
                                    return DateTimeField.combine(date, time);
                                  } else {
                                    return currentValue;
                                  }
                                  */
                                  return date;
                                },
                                autovalidate: true,
                                /*
                                validator: (value) {
                                  if (value == null) {
                                    return 'Debe ingresar una fecha inicial valida';
                                  } else if (minDate.isAfter(value)) {
                                    return 'Retroactividad máxima superada';
                                  }
                                  return null;
                                },
                                */
                                //initialValue: polizaObj.policyInitialDate != null ? DateTime.parse(((int.parse(polizaObj.policyInitialDate.substring(6, 10)) + polizaObj.excecutionTime + polizaObj.covers[index].additionalTerm).toString() + polizaObj.policyInitialDate.substring(3, 5) + polizaObj.policyInitialDate.substring(0, 2))) : null,
                                onChanged: (date) {
                                  listFinalDateTEC[index].text = dateFormat.format(date);
                                  polizaObj.covers[index].finalDate = dateFormat.format(date);
                                },
                                onSaved: (val) {
                                  print("FinalDate: ${listFinalDateTEC[index].text}");
                                    polizaObj.covers[index].finalDate = listFinalDateTEC[index].text;
                                },
                                onFieldSubmitted: (_){
                                  polizaObj.covers[index].finalDate = listFinalDateTEC[index].text;
                                  polizaObj.notifyListeners();
                                },
                                resetIcon: Icon(Icons.delete),
                                readOnly: false,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.date_range),
                                    labelText: 'Vigencia Hasta amparo'),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ));
                  }),
            ],
          )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}