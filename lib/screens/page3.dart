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
  List<TextEditingController> listTasaAmparoTEC;
  List<TextEditingController> listPrimaAmparoTEC;
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
    minDate = DateTime(_fechaEmision.year, _fechaEmision.month - 5, _fechaEmision.day);

    super.initState();
  }

  @override
  void dispose() {
    porcentajeTEC.dispose();
    vlrAmparoTEC.dispose();

    //Include the ? to not execute map if TEC == null
    listPorcentajeTEC?.map((tec) {
      tec.dispose();
    });
    listVlrAmparoTEC?.map((tec) {
      tec.dispose();
    });
    listTasaAmparoTEC?.map((tec) {
      tec.dispose();
    });
    listPrimaAmparoTEC?.map((tec) {
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
                  itemCount:
                      polizaObj.covers != null ? polizaObj.covers.length : 0,
                  itemBuilder: (BuildContext context, int index) {

                    //Initialice TextEditingControllers lists
                    listPorcentajeTEC = polizaObj.covers.map((a) {
                      return TextEditingController();
                    }).toList();
                    listVlrAmparoTEC = polizaObj.covers.map((a) {
                      return TextEditingController();
                    }).toList();
                    listTasaAmparoTEC = polizaObj.covers.map((a) {
                      return TextEditingController();
                    }).toList();
                    listPrimaAmparoTEC = polizaObj.covers.map((a) {
                      return TextEditingController();
                    }).toList();
                    /*
                    listInitialDateTEC = polizaObj.covers.map((a){
                      return TextEditingController();
                    }).toList();
                    */

                    if(polizaObj!=null) {

                      //Inicialize percentage and insured value TEC
                      listPorcentajeTEC[index].text = polizaObj.covers[index].porcentage.toString();
                      listVlrAmparoTEC[index].text = (polizaObj.covers[index].porcentage * polizaObj.treatyValue).toStringAsFixed(2);

                      //Inicialize cover premium rate TEC
                      listTasaAmparoTEC[index].text = polizaObj.covers[index].coverRate.toString();

                      //Inicialize cover premium TEC with object values
                      listPrimaAmparoTEC[index].text = (polizaObj.covers[index].coverRate * polizaObj.covers[index].porcentage * polizaObj.treatyValue).toStringAsFixed(2);

                      //Inicialize insured value TEC

                      polizaObj.covers[index].insuredValue = polizaObj.covers[index].porcentage * polizaObj.treatyValue;

                      //TODO initialize the cover object insured premium

                      //listInitialDateTEC[index].text = polizaObj.policyInitialDate;
                      //polizaObj.covers[index].insuredValue = double.parse(listVlrAmparoTEC[index].text);

                      if(polizaObj.covers[index].finalDate == null){
                        polizaObj.covers[index].finalDate = dateFormat.format(DateTime.parse(((int.parse(polizaObj.policyInitialDate.substring(6, 10)) + polizaObj.excecutionTime + polizaObj.covers[index].additionalTerm).toString() + polizaObj.policyInitialDate.substring(3, 5) + polizaObj.policyInitialDate.substring(0, 2))));
                      }
                      if(polizaObj.covers[index].initialDate == null){
                        polizaObj.covers[index].initialDate = polizaObj.policyInitialDate;
                      }


                    }
                    /*
                    listVlrAmparoTEC[index] = TextEditingController();
                    listInitialDateTEC[index] = TextEditingController();
                    listFinalDateTEC[index] = TextEditingController();
                    */
                    //listPorcentajeTEC[index].text = polizaObj.amparos[index].porcentaje.toString();

                    ///Campo amparos -------------------------------------------------------
                    return Dismissible(
                      key: ValueKey(polizaObj.covers[index].coverName),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        padding: EdgeInsets.all(12.0),
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30.0,
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
                          polizaObj.covers.removeAt(index);
                        });
                      },
                      child: ExpansionTile(
                        title: Text("${polizaObj.covers[index].coverName}"),
                        children: <Widget>[

                          ///Initial Date Field
                          DateTimeField(
                            decoration: InputDecoration(
                                labelText: "Fecha Desde Amparo",
                                icon: Icon(Icons.date_range)),
                            format: dateFormat,
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
                            initialValue: (polizaObj.policyInitialDate != null && polizaObj.policyInitialDate.length == 10) ? DateTime.parse((polizaObj.policyInitialDate.substring(6, 10) + polizaObj.policyInitialDate.substring(3, 5) + polizaObj.policyInitialDate.substring(0, 2))) : DateTime.now(),
                            onChanged: (date) => setState(() {
                              if (date != null) {
                                print("MinDate $minDate");
                                if (minDate.isAfter(date)) {
                                  print("Fecha invalida ${date}");
                                } else {
                                  polizaObj.covers[index].initialDate = dateFormat.format(date);
                                  print(
                                      "Fecha en objeto ${polizaObj.covers[index].initialDate}");
                                }
                              }
                            }),
                            onSaved: (date) => setState(() {
                              polizaObj.covers[index].initialDate = dateFormat.format(date);
                            }),
                            resetIcon: Icon(Icons.delete),
                            readOnly: false,
                          ),
                          //initialValue: polizaObj.policyInitialDate != null ? DateTime.parse(((int.parse(polizaObj.policyInitialDate.substring(6, 10)) + polizaObj.excecutionTime + polizaObj.covers[index].additionalTerm).toString() + polizaObj.policyInitialDate.substring(3, 5) + polizaObj.policyInitialDate.substring(0, 2))) : null,

                          ///Final Date Field
                          DateTimeField(
                            decoration: InputDecoration(
                                labelText: "Fecha Hasta Amparo",
                                icon: Icon(Icons.date_range)),
                            format: dateFormat,
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
                                  initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                );
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                              */
                              return date;
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
                            initialValue: polizaObj.policyInitialDate != null ? DateTime.parse(((int.parse(polizaObj.policyInitialDate.substring(6, 10)) + polizaObj.excecutionTime + polizaObj.covers[index].additionalTerm).toString() + polizaObj.policyInitialDate.substring(3, 5) + polizaObj.policyInitialDate.substring(0, 2))) : null,
                            onChanged: (date) => setState(() {
                              if (date != null) {
                                print("MinDate $minDate");
                                if (minDate.isAfter(date)) {
                                  print("Fecha invalida ${date}");
                                } else {
                                  polizaObj.covers[index].finalDate = dateFormat.format(date);
                                  print(
                                      "Fecha en objeto ${polizaObj.covers[index].initialDate}");
                                }
                              }
                            }),
                            onSaved: (date) => setState(() {
                              polizaObj.covers[index].finalDate = dateFormat.format(date);
                              polizaObj.notifyListeners();
                            }),
                            resetIcon: Icon(Icons.delete),
                            readOnly: false,
                          ),
                          ///Porcentage field
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: listPorcentajeTEC[index],
                              decoration: InputDecoration(
                                  suffixIcon: GestureDetector(child: Icon(Icons.update),onTap: (){
                                    polizaObj.notifyListeners();
                                  },),
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
                                //polizaObj.notifyListeners();
                              },
                              onSaved: (val) {
                                polizaObj.covers[index].porcentage =
                                    double.parse(val);
                              },
                            ),
                          ),

                          ///Vlr. Asegurado amparo
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              readOnly: true,
                              controller: listVlrAmparoTEC != null ? listVlrAmparoTEC[index]: vlrAmparoTEC,
                              decoration: InputDecoration(
                                  labelText: "Vlr. Asegurado amparo:",
                                  icon: Icon(Icons.assessment)),
                              //initialValue: polizaObj.treatyValue != null ? (polizaObj.covers[index].porcentage * polizaObj.treatyValue).toString() : "",
                              onChanged: (val){
                                polizaObj.covers[index].insuredValue = double.parse(val);
                              },
                              onSaved: (val){
                                polizaObj.covers[index].insuredValue = double.parse(val);
                              },
                            ),
                          ),

                          ///Cover premium rate
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: listTasaAmparoTEC[index],
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(child: Icon(Icons.update),onTap: (){
                                  polizaObj.notifyListeners();
                                },),
                                  labelText: "Tasa Amparo:",
                                  icon: Icon(Icons.assessment)),
                              //initialValue: polizaObj.treatyValue != null ? (polizaObj.covers[index].porcentage * polizaObj.treatyValue).toString() : "",
                              onChanged: (val){
                                polizaObj.covers[index].coverRate = double.parse(val);
                                listPrimaAmparoTEC[index].text = (double.parse(val) * polizaObj.covers[index].insuredValue).toStringAsFixed(2);

                              },
                              onSaved: (val){
                                polizaObj.covers[index].coverRate = double.parse(val);
                              },
                            ),
                          ),

                          ///Cover Premium field
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              readOnly: true,
                              controller: listPrimaAmparoTEC[index],
                              decoration: InputDecoration(
                                  labelText: "Prima amparo:",
                                  icon: Icon(Icons.assessment)),
                              //initialValue: polizaObj.treatyValue != null ? (polizaObj.covers[index].porcentage * polizaObj.treatyValue).toString() : "",
                              onChanged: (val){
                                polizaObj.covers[index].insurancePremium = double.parse(double.parse(val).toStringAsFixed(2)); //TODO Please simplify this
                              },
                              onSaved: (val){
                                polizaObj.covers[index].insurancePremium = double.parse(double.parse(val).toStringAsFixed(2)); //TODO Please simplify this
                              },
                            ),
                          ),



                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
