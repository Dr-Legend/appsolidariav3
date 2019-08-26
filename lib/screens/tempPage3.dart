import 'package:appsolidariav3/model/polizaModel.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';


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
  DateTime initialDate = DateTime.now();

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
    listPorcentajeTEC.map((tec) {
      tec.dispose();
    });
    listVlrAmparoTEC.map((tec) {
      tec.dispose();
    });
    /*
    listInitialDateTEC.map((tec){
      tec.dispose();
    });
    */
    listFinalDateTEC.map((tec) {
      tec.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var polizaObj = Provider.of<Poliza>(context);
    Poliza poliza = Poliza();

    print("Poliza en pagina 3: ${polizaObj.toString()}");

    return Container(
      child: Card(
          margin: const EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: polizaObj.covers != null ? polizaObj.covers.length : 0, itemBuilder: (BuildContext context, int index)
              {listPorcentajeTEC = polizaObj.covers.map((a) {
                return TextEditingController();
              }).toList();
              /*
                    listInitialDateTEC = polizaObj.covers.map((a){
                      return TextEditingController();
                    }).toList();
                    */

              listPorcentajeTEC[index].text = polizaObj.covers[index].porcentage.toString();
              //listInitialDateTEC[index].text = polizaObj.policyInitialDate;
              polizaObj.covers[index].initialDate = polizaObj.policyInitialDate;

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
                  child: SizedBox(
                    width: double.infinity,
                    child: ExpansionTile(
                      key: ValueKey(polizaObj.covers[index].coverName),
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
                              polizaObj.covers[index].porcentage =
                                  double.parse(val);
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            //controller: listVlrAmparoTEC.length >0 ? listVlrAmparoTEC[index]: vlrAmparoTEC,
                            decoration: InputDecoration(
                                labelText: "Vlr. Asegurado amparo:",
                                icon: Icon(Icons.assessment)),
                            initialValue: polizaObj.treatyValue != null ? (polizaObj.covers[index].porcentage * polizaObj.treatyValue).toString() : "",
                            onChanged: (val){
                              polizaObj.covers[index].insuredValue = double.parse(val);
                            },
                            onSaved: (val){
                              polizaObj.covers[index].insuredValue = double.parse(val);
                              polizaObj.notifyListeners();
                            },
                          ),
                        ),

                        ///Initial Date Field
                        DateTimeField(
                          format: dateFormat,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate:
                                currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
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
                          },
                          autovalidate: false,
                          //validator: (date) => date == null ? 'Invalid date' : null,
                          validator: (date) {
                            if (date == null) {
                              return 'Debe ingresar una fecha inicial valida';
                            } else if (minDate.isAfter(date)) {
                              return 'Retroactividad máxima superada';
                            }
                            return null;
                          },
                          initialValue: initialDate,
                          onChanged: (date) => setState(() {
                            if (date != null) {
                              print("MinDate $minDate");
                              if (minDate.isAfter(date)) {
                                print("Fecha invalida ${date}");
                              } else {
                                polizaObj.covers[index].initialDate =
                                    date.toString();
                                print(
                                    "Fecha en objeto ${polizaObj.covers[index].initialDate}");
                              }
                            }
                          }),
                          onSaved: (date) => setState(() {
                            polizaObj.covers[index].initialDate =
                                date.toString();
                          }),
                          resetIcon: Icon(Icons.delete),
                          readOnly: false,
                        ),
                        //initialValue: polizaObj.policyInitialDate != null ? DateTime.parse(((int.parse(polizaObj.policyInitialDate.substring(6, 10)) + polizaObj.excecutionTime + polizaObj.covers[index].additionalTerm).toString() + polizaObj.policyInitialDate.substring(3, 5) + polizaObj.policyInitialDate.substring(0, 2))) : null,

                        ///Final Date Field
                        DateTimeField(
                          format: dateFormat,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate:
                                currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
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
                          },
                          autovalidate: false,
                          //validator: (date) => date == null ? 'Invalid date' : null,
                          validator: (date) {
                            if (date == null) {
                              return 'Debe ingresar una fecha inicial valida';
                            } else if (minDate.isAfter(date)) {
                              return 'Retroactividad máxima superada';
                            }
                            return null;
                          },
                          initialValue: initialDate,
                          onChanged: (date) => setState(() {
                            if (date != null) {
                              print("MinDate $minDate");
                              if (minDate.isAfter(date)) {
                                print("Fecha invalida ${date}");
                              } else {
                                polizaObj.covers[index].finalDate =
                                    date.toString();
                                print(
                                    "Fecha en objeto ${polizaObj.covers[index].initialDate}");
                              }
                            }
                          }),
                          onSaved: (date) => setState(() {
                            polizaObj.covers[index].finalDate =
                                date.toString();
                          }),
                          resetIcon: Icon(Icons.delete),
                          readOnly: false,
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