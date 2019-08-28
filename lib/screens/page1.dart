import 'dart:convert';

import 'package:appsolidariav3/model/amparoModel.dart';
import 'package:appsolidariav3/model/auxiliarModel.dart';
import 'package:appsolidariav3/model/polizaModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';


class Clausulado {
  String prodClausulado;
  String textoClausulado;

  Clausulado(this.prodClausulado, this.textoClausulado);
}

class Page0 extends StatefulWidget {
  @override
  _Page0State createState() => _Page0State();
}

class _Page0State extends State<Page0> with AutomaticKeepAliveClientMixin {
  TextEditingController auxBasicoController = TextEditingController();
  TextEditingController afianzadoController = TextEditingController();
  TextEditingController tomadorController = TextEditingController();
  TextEditingController beneficiarioController = TextEditingController();

  TextEditingController asegBasicoController = TextEditingController();

  List<AuxBasico> afianzados = List();
  List<AuxBasico> contratantes = List();

  AuxBasico selectedAuxBasico;
  AuxBasico selectedAsegBasico;

  AuxBasico auxObj;

  //Se crea la instancia
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference terceroRef;
  DatabaseReference afianzadoRef;
  DatabaseReference contratanteRef;
  DatabaseReference afianzadoBasicoRef;
  DatabaseReference contratanteBasicoRef;
  DatabaseReference rootRef;

  var loading = true;
  bool _isSelected = false;

  @override
  void initState() {
    //Inicializar objeto
    auxObj = AuxBasico();

    //Inicializar referencias de RealTimeDatabase firebase
    terceroRef = database.reference().child("terceros");
    afianzadoRef = database.reference().child("terceros").child("Afianzado");
    contratanteRef = database.reference().child("terceros").child("Contratante");
    afianzadoBasicoRef = database.reference().child("terceroBasico").child("Afianzado");
    contratanteBasicoRef = database.reference().child("terceroBasico").child("Contratante");
    rootRef = database.reference();

    //Initialize the list of Afianzados from Firebase /auxCont/keys
    afianzadoBasicoRef.onChildAdded
        .listen(_onAddedAfianzado)
        .onDone(loadingFunc());
    //Initialize the list of Contratante from Firebase /auxCont/keys
    contratanteBasicoRef.onChildAdded.listen(_onAddedContratante);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var polizaObj = Provider.of<Poliza>(context);

    return Column(
      children: <Widget>[
        Card(
          elevation: 8.0,
          child: Column(
            children: <Widget>[
              CheckboxListTile(
                value: _isSelected,
                title: Text("Asegurado = Beneficiario"),
                onChanged: (bool newValue) {
                  setState(() {
                    _isSelected = newValue;
                  });
                },
              ),
              ///Campo Afianzado
              //TODO Importante!!! PostVenta Debe guardarse la fecha de consulta del cupo disponible
              loading
                  ? CircularProgressIndicator()
                  : SimpleAutocompleteFormField<AuxBasico>(
                controller: afianzadoController,
                decoration: InputDecoration(
                    labelText: 'Afianzado', icon: Icon(Icons.search)),
                suggestionsHeight: 120.0,
                itemBuilder: (context, auxbasico) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(auxbasico.primerApellido,
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                        Text(auxbasico.identificacion.toString())
                      ]),
                ),
                //Bug solved.
                //Can't search for primerNombre because Nit don't have primerNombre
                onSearch: (search) async => afianzados
                    .where((aux) =>
                aux.primerApellido
                    .toLowerCase()
                    .contains(search.toLowerCase()) ||
                    aux.identificacion.toString().contains(search))
                    .toList(),
                itemFromString: (string) => afianzados.singleWhere(
                        (auxbasico) =>
                    auxbasico.primerApellido.toLowerCase() ==
                        string.toLowerCase(),
                    orElse: () => null),
                onChanged: (AuxBasico value) async {

                  //TODO Importante!!! Debe ser actualizado con el servidor para traer los ultimos valores de Cumulo

                  ///Get All the info for the policyBuyer / Afianzado
                  if (value != null) {
                    polizaObj.policyBuyer = await afianzadoRef.child("${value.identificacion}").once().then((val){
                      return Auxiliar.fromMap(val.value.cast<String, dynamic>());
                    });
                  }
                    selectedAuxBasico = value;
                    if (value != null) {
                      auxBasicoController.text = polizaObj.policyBuyer.surname;
                      //print("Selected ubicacion departamento: ${auxObj.departamento},municipio: ${auxObj.municipio}");
                    }
                },
                onSaved: (value) async {
                    //TODO AFR Evaluar si es necesario guardar algo en este punto. Ej. Realizar la consulta del nit nuevamente
                    selectedAuxBasico = value;
                    ///Get All the info for the policyBuyer / Afianzado
                    if (value != null) {
                      polizaObj.policyBuyer = await afianzadoRef.child("${value.identificacion}").once().then((val){
                        return Auxiliar.fromMap(val.value.cast<String, dynamic>());
                      });
                    }
                },
                onFieldSubmitted: (_){
                  polizaObj.notifyListeners();
                },
                autofocus: false,
                validator: (user) =>
                user == null ? 'Campo obligatorio.' : null,
              ),
              ///Campo Tomador / Asegurado - Contratante
              loading
                  ? CircularProgressIndicator()
                  : SimpleAutocompleteFormField<AuxBasico>(
                controller: tomadorController,
                decoration: InputDecoration(
                    labelText: 'Tomador/Asegurado', icon: Icon(Icons.search)),
                suggestionsHeight: 120.0,
                itemBuilder: (context, auxbasico) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(auxbasico.primerApellido,
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                        Text(auxbasico.identificacion.toString())
                      ]),
                ),
                //Bug solved.
                //Can't search for primerNombre because Nit don't have primerNombre
                onSearch: (search) async => contratantes
                    .where((aux) =>
                aux.primerApellido
                    .toLowerCase()
                    .contains(search.toLowerCase()) ||
                    aux.identificacion.toString().contains(search))
                    .toList(),
                itemFromString: (string) => contratantes.singleWhere(
                        (auxbasico) =>
                    auxbasico.primerApellido.toLowerCase() ==
                        string.toLowerCase(),
                    orElse: () => null),
                onChanged: (value) async {
                  //TODO Importante!!! Debe ser actualizado con el servidor para traer los ultimos valores de Cumulo

                  ///Get All the info for the Contractor
                  if (value != null) {
                    polizaObj.contractor = await contratanteRef.child("${value.identificacion}").once().then((val){
                      return Auxiliar.fromMap(val.value.cast<String, dynamic>());
                    });
                  }
                    selectedAsegBasico = value;
                    if (value != null) {
                      auxBasicoController.text = value.primerApellido;
                      //print("Selected ubicacion departamento: ${auxObj.departamento},municipio: ${auxObj.municipio}");
                    }
                },
                onSaved: (value) async {
                    selectedAsegBasico = value;

                    ///Get All the info for the Contractor
                    if (value != null) {
                      polizaObj.contractor = await contratanteRef.child("${value.identificacion}").once().then((val){
                        return Auxiliar.fromMap(val.value.cast<String, dynamic>());
                      });
                      if(_isSelected){
                        polizaObj.beneficiary = polizaObj.contractor;
                        polizaObj.notifyListeners();
                      }
                    }
                },
                onFieldSubmitted: (_){
                  polizaObj.notifyListeners();
                },
                autofocus: false,
                validator: (user) =>
                user == null ? 'Campo obligatorio.' : null,
              ),
              ///Campo Beneficiario
              _isSelected == false ? loading
                  ? CircularProgressIndicator()
                  : SimpleAutocompleteFormField<AuxBasico>(
                controller: beneficiarioController,
                decoration: InputDecoration(
                    labelText: 'Beneficiario', icon: Icon(Icons.search)),
                suggestionsHeight: 120.0,
                itemBuilder: (context, auxbasico) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(auxbasico.primerApellido,
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                        Text(auxbasico.identificacion.toString())
                      ]),
                ),
                //Bug solved.
                //Can't search for primerNombre because Nit don't have primerNombre
                onSearch: (search) async => afianzados
                    .where((aux) =>
                aux.primerApellido
                    .toLowerCase()
                    .contains(search.toLowerCase()) ||
                    aux.identificacion.toString().contains(search))
                    .toList(),
                itemFromString: (string) => contratantes.singleWhere(
                        (auxbasico) => auxbasico.primerApellido.toLowerCase() == string.toLowerCase(),
                    orElse: () => null),
                onChanged: (value) async {
                  //TODO Importante!!! Debe ser actualizado con el servidor para traer los ultimos valores de Cumulo

                  ///Get All the info for the beneficiary
                  if (value != null) {
                    polizaObj.beneficiary = await afianzadoRef.child("${value.identificacion}").once().then((val){
                      //polizaObj.beneficiary.thirdPartyType = "Beneficiario";

                      selectedAsegBasico = value;
                      auxBasicoController.text = value.primerApellido;
                      //print("Selected ubicacion departamento: ${auxObj.departamento},municipio: ${auxObj.municipio}");
                      return Auxiliar.fromMap(val.value.cast<String, dynamic>());
                    });
                  }

                },
                onSaved: (value) async{
                    selectedAsegBasico = value;

                    ///Get All the info for the beneficiary
                    if (value != null) {
                      polizaObj.beneficiary = await afianzadoRef.child("${value.identificacion}").once().then((val){
                        return Auxiliar.fromMap(val.value.cast<String, dynamic>());
                      });
                    }
                    polizaObj.beneficiary.thirdPartyType = "Beneficiario" ;
                },
                onFieldSubmitted: (_){
                  polizaObj.notifyListeners();
                },
                autofocus: false,
                validator: (user) =>
                user == null ? 'Campo obligatorio.' : null,
              ) : Container(),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _onAddedAfianzado(Event event) {
    setState(() {
      afianzados.add(AuxBasico.fromMapObject(
          event.snapshot.value.cast<String, dynamic>()));
      print("Add ${event.snapshot.key}");
    });
  }

  _onAddedContratante(Event event) {
    setState(() {
      contratantes.add(AuxBasico.fromMapObject(
          event.snapshot.value.cast<String, dynamic>()));
      print("Add ${event.snapshot.key}");
    });
  }

  void Function() loadingFunc() {
    loading = false;
  }
}

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> with AutomaticKeepAliveClientMixin {
  //Se crea la instancia
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference terceroRef;
  DatabaseReference afianzadoRef;
  DatabaseReference contratanteRef;
  DatabaseReference rootRef;

  String tipoPolizaValue;
  String tipoNegocioValue = null;
  Clausulado clausuladoValue;

  DateFormat
  dateFormat; //DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"); //DateFormat('dd-MM-yyyy'); DateFormat.yMMMd()

  TextEditingController initialDate = TextEditingController();
  TextEditingController finalDate = TextEditingController();
  TextEditingController prueba = TextEditingController();
  TextEditingController periodoController = TextEditingController();
  TextEditingController cupoController = TextEditingController();

  DateTime _fechaEmision = DateTime.now();
  DateTime _fromDate1;
  DateTime minDate;

  //TODO Definir Listado Producto Clausulado
  List<Clausulado> prodClausulado = <Clausulado>[
    Clausulado("Decreto123", "Lorem ipsum1"),
    Clausulado("Decreto456", "Lorem ipsum2")
  ];

  List<String> tipoPoliza = [
    "Particular",
    "Estatal",
    "Servicios Publicos",
    "Poliza Ecopetrol",
    "E.Publicas R.Privado"
  ];
  List<String> tipoNeg = [
    "Prestación de servicios",
    "Suministro",
    "Consultoría",
    "Interventoría",
    "Obra",
    "Suministro Repuestos",
  ];

  bool loading = true;
  final _poliza = Poliza();

  List<Amparo> amparos = List();
  DocumentSnapshot amparosMap;

  @override
  void initState() {
    initializeDateFormatting();
    dateFormat = new DateFormat('dd-MM-yyyy'); //new DateFormat.yMMMMd('es');
    ///Define fecha mínima como control del sistema.
    minDate = DateTime(
        _fechaEmision.year, _fechaEmision.month - 5, _fechaEmision.day);
    periodoController.text = "1";

    //Inicializar referencias de RealTimeDatabase firebase
    terceroRef = database.reference().child("terceros");
    afianzadoRef = database.reference().child("terceros").child("Afianzado");
    contratanteRef =
        database.reference().child("terceros").child("Contratante");
    rootRef = database.reference();

    super.initState();
  }


  @override
  void dispose() {
   //TODO dispose Controlladores y FocusNodes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var polizaObj = Provider.of<Poliza>(context);

    //TODO Freelancer verify if this is the right place to put this. What happen if afianzado==null?

    /*
      if(polizaObj.policyBuyer != null){
        print("Cupo disponible ${polizaObj.policyBuyer.cupoDisponible}");
        cupoController.text = polizaObj.policyBuyer.cupoDisponible.toString();
        //polizaObj.notifyListeners();
      }
*/

    return Card(
      elevation: 8.0,
      child: Column(
        children: <Widget>[
          Center(
              child: Text(
                "Datos Básicos",
                style: TextStyle(fontSize: 16.0, color: Colors.blue),
              )),
          ///Campo Vigencia Desde
          DateTimeField(
            decoration: InputDecoration(
                icon: Icon(Icons.date_range),
                labelText: 'Vigencia Desde /From'),
            format: dateFormat,
            controller: initialDate,
            //Lo agregue ver si es necesario
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
              /*
              Used to return time as well
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
            validator: (value) {
              if (value == null) {
                return 'Debe ingresar una fecha inicial valida';
              } else if (minDate.isAfter(value)) {
                return 'Retroactividad máxima superada';
              }
              return null;
            },
            //TODO Revisar Se cambia de "" a null 06 Agosto 2019
            onChanged: (DateTime date) {
              setState(() {
                polizaObj.policyInitialDate = dateFormat.format(date);
              });
            },
            onSaved: (DateTime date) {
              polizaObj.policyInitialDate = dateFormat.format(date);
            },
            onFieldSubmitted: (_){
              polizaObj.notifyListeners();
            },
            resetIcon: Icon(Icons.delete),
            readOnly: false,
          ),

          ///Campo Clausulado
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<Clausulado>(
              value: clausuladoValue,
              decoration: InputDecoration(
                  labelText: "Clausulado", icon: Icon(Icons.text_fields)),
              onChanged: (Clausulado newValue) {
                setState(() {
                  clausuladoValue = newValue;
                  cupoController.text = polizaObj.policyBuyer.cupoDisponible.toString();
                });
                  polizaObj.notifyListeners();
                  print("clausulado value ${clausuladoValue.textoClausulado}");
              },
              validator: (Clausulado value) {
                if (value == null ?? true) {
                  return 'Favor seleccione un clausulado';
                }
                return null;
              },
              items: prodClausulado.map((Clausulado value) {
                return DropdownMenuItem<Clausulado>(
                  value: value,
                  child: Text(value.prodClausulado),
                );
              }).toList(),
              onSaved: (val) {
                polizaObj.textProdConditions = val.textoClausulado;
                polizaObj.productConditions = val.prodClausulado;
                polizaObj.notifyListeners();
              },
            ),
          ),
          ///Campo Tipo de Póliza
          //TODO PostVenta - Verificar con IT si el campo está codificado
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText: "Tipo de poliza", icon: Icon(Icons.book)),
              value: tipoPolizaValue,
              onChanged: (String newValue) {
                setState(() {
                  tipoPolizaValue = newValue;
                });
              },
              validator: (String value) {
                if (value?.isEmpty ?? true) {
                  return 'Favor ingrese el tipo de poliza';
                }
                return null;
              },
              items: tipoPoliza.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onSaved: (val) => setState(() => polizaObj.polizaType = val),
            ),
          ),
          ///Campo Tipo de Negocio, guarda poliza.amparos
          //TODO PostVenta - Verificar con IT si el campo está codificado
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText: "Tipo de negocio", icon: Icon(Icons.store)),
              value: tipoNegocioValue,
              onChanged: (String newValue) async {
                amparos = List();
                await getAmparos(newValue).then((value){
                  value.data.forEach((key, value) {
                    amparos.add(Amparo.fromMap(value.cast<String, dynamic>()));
                  });
                });
                /*
                amparosMap.data.forEach((key, value) {
                  amparos.add(Amparo.fromMap(value.cast<String, dynamic>()));
                });
                */
                setState(() {
                  tipoNegocioValue = newValue;

                  //Asign amparos list to the object
                  polizaObj.covers = amparos;
                  //Notify listeners updates the object and refresh all the UI
                  polizaObj.notifyListeners();
                });
              },
              validator: (String value) {
                if (value?.isEmpty ?? true) {
                  return 'Favor ingrese el tipo de negocio';
                }
                return null;
              },
              items: tipoNeg.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onSaved: (val) {
                setState(() {
                  polizaObj.businessType = val;
                });
              },
            ),
          ),
          ///Campo cupo disponible Read only
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: cupoController,
              decoration: InputDecoration(
                  labelText: 'Budget /Cupo Disponible',
                  icon: Icon(Icons.attach_money)),
              readOnly: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Debe verificarse el cupo';
                }
                return null;
              },
              onSaved: (val) =>
                  setState(() => polizaObj.avaliableQuota = int.parse(val)),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Future<DocumentSnapshot> getAmparos(String newValue) async {
    return Firestore.instance.collection("tipoNeg").document("$newValue").get();
  }
}
