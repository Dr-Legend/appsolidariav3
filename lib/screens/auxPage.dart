import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:appsolidariav3/model/auxiliarModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

class AuxiliarPage extends StatefulWidget {
  @override
  _AuxiliarPageState createState() => _AuxiliarPageState();
}

class _AuxiliarPageState extends State<AuxiliarPage> {
  final formKey = GlobalKey<FormState>();

  Agencia agenciaValue;

  List<Genero> generos = [
    Genero.withId(1, "Femenino"),
    Genero.withId(2, "Masculino")
  ];

  List<EstadoCivil> estadoCiviles = [
    EstadoCivil.withId(1, "Soltero"),
    EstadoCivil.withId(2, "Casado"),
    EstadoCivil.withId(3, "Divorciado"),
    EstadoCivil.withId(4, "Unión Libre")
  ];
  List<Tipo> tipos = [
    Tipo.withId(1, "Nit"),
    Tipo.withId(2, "Nit Persona natural"),
    Tipo.withId(3, "Cédula de ciudadanía"),
    Tipo.withId(4, "Cédula de extranjería"),
  ];
  List<Clasificacion> clasificaciones = [
    Clasificacion.withId(1, "Persona natural"),
    Clasificacion.withId(2, "Persona jurídica"),
    Clasificacion.withId(3, "Consorcio"),
    Clasificacion.withId(4, "Unión Temporal"),
    Clasificacion.withId(5, "Cooperativa"),
    Clasificacion.withId(6, "PreCooperativa"),
    Clasificacion.withId(7, "Asociación")
  ];

  List<String> tipoTercero = ["Intermediario", "Afianzado", "Contratante"];

  List<Agencia> agencias = [
    Agencia.withId(1, "Agencia Bogota"),
    Agencia.withId(1, "Agencia Medellin"),
    Agencia.withId(2, "Agencia Cali"),
  ];

  List<Ubicacion> ubicaciones = List();

  var _genero = null;
  var _estadoCivil = null;
  var _tipo;
  var _clasificacion = null;
  var _tercero = null;

  Auxiliar auxObj;
  AuxBasico auxBasicoObj;

  //---AutoComplete variables

  var intermedList = <String>[];

  //GlobalKey<AutoCompleteTextFieldState<String>> autoCompKey = new GlobalKey();

  //AutoCompleteTextField searchTextField;

  //Se crea la instancia
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ubicacionRef;
  DatabaseReference terceroRef;
  DatabaseReference terceroBasicoRef;
  DatabaseReference rootRef;

  //Define TextEdintingController important for Android to work fine
  var birthDateTEC = TextEditingController();
  var _ubicacion = TextEditingController();
  var cupoOperativoTEC = TextEditingController();
  var identificacionTEC = TextEditingController();
  var razonSocialTEC = TextEditingController();
  var direccionTEC = TextEditingController();
  var celularTEC = TextEditingController();
  var fijoTEC = TextEditingController();
  var correoTEC = TextEditingController();
  var puntoVentaTEC = TextEditingController();
  var claveTEC = TextEditingController();
  var comisionCumpTEC = TextEditingController();
  var delegacionCumpTEC = TextEditingController();
  var cumuloActualTEC = TextEditingController();
  var cupoDisponibleTEC = TextEditingController();
  var segundoApellidoTEC = TextEditingController();
  var primerNombreTEC = TextEditingController();
  var segundoNombreTEC = TextEditingController();


  //TODO update the focus nodes
  final FocusNode _idFocus = FocusNode();
  FocusNode _municipioFocus;
  FocusNode _fijoFocus; 
  FocusNode _correoFocus;
  FocusNode _claveFocus;
  FocusNode _comCumpFocus;
  FocusNode _delegaCumpFocus;
  FocusNode _cumActualFocus;
  FocusNode _cupoDispFocus;

  DateTime nacimiento;

  DateFormat dateFormat;
  DateTime initialBirth = DateTime(2000);

  Ubicacion selectedPlace;

  @override
  void initState() {

    //Initialize date formats
    initializeDateFormatting();
    dateFormat = new DateFormat('dd-MM-yyyy'); //new DateFormat.yMMMMd('es');

    //Init Objects

    auxObj = Auxiliar();
    auxBasicoObj = AuxBasico();

    _municipioFocus = FocusNode();
    //_movilFocus = FocusNode();
    _fijoFocus = FocusNode();
    _correoFocus = FocusNode();
    _claveFocus = FocusNode();
    _comCumpFocus = FocusNode();
    _delegaCumpFocus = FocusNode();
    _cumActualFocus = FocusNode();
    _cupoDispFocus = FocusNode();

    //Start listening for changes on controllers
    cumuloActualTEC.addListener(_calcCupoDisp);

    initializeDateFormatting();
    dateFormat = new DateFormat('dd-MM-yyyy'); //new DateFormat.yMMMMd('es');

    ubicacionRef = database.reference().child("ubicacion");

    terceroRef = database.reference().child("terceros");
    terceroBasicoRef = database.reference().child("terceroBasico");

    //Root ref
    rootRef = database.reference();

    //Initialize the list of nits from Firebase /auxCont/keys
    ubicacionRef.onChildAdded.listen(_onAdded);
  }


  @override
  void dispose() {

    birthDateTEC.dispose();
    _ubicacion.dispose();
    cupoOperativoTEC.dispose();
    identificacionTEC.dispose();
    razonSocialTEC.dispose();
    direccionTEC.dispose();
    celularTEC.dispose();
    fijoTEC.dispose();
    correoTEC.dispose();
    puntoVentaTEC.dispose();
    claveTEC.dispose();
    comisionCumpTEC.dispose();
    delegacionCumpTEC.dispose();
    cumuloActualTEC.dispose();
    cupoDisponibleTEC.dispose();
    segundoApellidoTEC.dispose();
    primerNombreTEC.dispose();
    segundoNombreTEC.dispose();

    _idFocus.dispose();
    _municipioFocus.dispose();
    _fijoFocus.dispose();
    _correoFocus.dispose();
    _claveFocus.dispose();
    _comCumpFocus.dispose();
    _delegaCumpFocus.dispose();
    _cumActualFocus.dispose();
    _cupoDispFocus.dispose();

    //TODO 15/08/2019 se agrego posterior a que funcionara!! BORRAR
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget datosPersonaNatural = Container(
      child: Column(
        children: [
          SizedBox(height: 12.0),
          Text("Datos persona natural",
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0)),
          //Segundo Apellido
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: segundoApellidoTEC,
              decoration: InputDecoration(
                  labelText: 'Segundo Apellido',
                  icon: Icon(Icons.person_outline)),
              enabled: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Campo obligatorio';
                }
                return null;
              },
              onChanged: (val){
                auxObj.segundoApellido = val;
            },
              onSaved: (val) => setState(() {
                auxObj.segundoApellido = val;
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: primerNombreTEC,
              decoration: InputDecoration(
                  labelText: 'Primer Nombre',
                  icon: Icon(
                    Icons.filter_1,
                  )),
              enabled: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Campo obligatorio';
                }
                return null;
              },
              onChanged: (val){
                auxObj.primerNombre = val;
                auxBasicoObj.primerNombre = val;
              },
              onSaved: (val) => setState(() {
                auxObj.primerNombre = val;
                auxBasicoObj.primerNombre = val;
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: segundoNombreTEC,
              decoration: InputDecoration(
                  labelText: 'Segundo Nombre',
                  icon: Icon(Icons.filter_2)),
              enabled: true,
              onChanged: (val){
                auxObj.segundoNombre = val;
              },
              onSaved: (val) => setState(() {
                auxObj.segundoNombre = val;
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<Genero>(
              decoration: InputDecoration(
                  labelText: 'Genero', icon: Icon(Icons.wc)),
              value: _genero,
              onChanged: (Genero newValue) {
                setState(() {
                  _genero = newValue;
                  auxObj.descGenero = newValue.descripcion;
                  auxObj.genero = newValue.registro;
                  //print("Nuevo genero seleccionado ${newValue.descripcion}");
                });
              },
              items: generos.map((Genero genero) {
                return DropdownMenuItem<Genero>(
                  value: genero,
                  child: Text(
                    genero.descripcion,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
          DateTimeField(
            format: dateFormat,
            controller: birthDateTEC,
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
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
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
              }
              return null;
            },
            initialValue: initialBirth,
            onChanged: (date) => setState(() {
              auxObj.nacimiento = date.toString();
            }),
            onSaved: (DateTime date) {
              setState(() {
                auxObj.nacimiento = date.toString();
              });
            },
            resetIcon: Icon(Icons.delete),
            readOnly: false,
            decoration: InputDecoration(
                icon: Icon(Icons.date_range), labelText: 'Fecha de nacimiento'),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<EstadoCivil>(
              decoration: InputDecoration(
                  labelText: 'Estado Civil', icon: Icon(Icons.contacts)),
              value: _estadoCivil,
              onChanged: (EstadoCivil newValue) {
                setState(() {
                  _estadoCivil = newValue;
                  auxObj.descEstadoCivil = newValue.descripcion;
                  auxObj.estadoCivil = newValue.registro;
                  //print("Nuevo genero seleccionado ${newValue.descripcion}");
                });
              },
              items: estadoCiviles.map((EstadoCivil ecivil) {
                return DropdownMenuItem<EstadoCivil>(
                  value: ecivil,
                  child: Text(
                    ecivil.descripcion,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );

    Widget datosIdentificacion = ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Identificación",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        //Tipo de documento [Nit,Nit persona natural, cedula, cedula de extrangeria]
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
                labelText: "Tipo de tercero", icon: Icon(Icons.person_pin)),
            value: _tercero,
            onChanged: (String newValue) {
              setState(() {
                _tercero = newValue;
                auxObj.tipoTercero = newValue;
              });
            },
            onSaved: (String value){
              auxObj.tipoTercero = value;
            },
            items: tipoTercero.map((String tipo) {
              return new DropdownMenuItem<String>(
                value: tipo,
                child: Text(
                  tipo,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<Tipo>(
            decoration: InputDecoration(
                labelText: "Tipo Documento", icon: Icon(Icons.person)),
            value: _tipo,
            onChanged: (Tipo newValue) {
              setState(() {
                _tipo = newValue;
                auxObj.descTipo = newValue.descripcion;
                auxObj.tipo = newValue.registro;
                print("Nuevo genero seleccionado ${newValue.descripcion}");
              });
            },
            onSaved: (Tipo newValue) {
              setState(() {
                _tipo = newValue;
                auxObj.descTipo = newValue.descripcion;
                auxObj.tipo = newValue.registro;
                print("Nuevo genero guardado ${newValue.descripcion}");
              });
            },
            items: tipos.map((Tipo tipo) {
              return new DropdownMenuItem<Tipo>(
                value: tipo,
                child: new Text(
                  tipo.descripcion,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
        //Número de identificación
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: identificacionTEC,
            decoration: InputDecoration(
                labelText: 'Número identificación',
                icon: Icon(Icons.check)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onChanged: (val){
              auxObj.identificacion = int.parse(val);
              auxBasicoObj.identificacion = int.parse(val);
            },
            onSaved: (val) => setState(() {
              auxObj.identificacion = int.parse(val);
              auxBasicoObj.identificacion = int.parse(val);
            }),
          ),
        ),
        //Tipo de cliente - Clasificaciones
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<Clasificacion>(
            decoration: InputDecoration(
                labelText: "Tipo de cliente", icon: Icon(Icons.person_add)),
            value: _clasificacion,
            onChanged: (Clasificacion newValue) {
              setState(() {
                _clasificacion = newValue;
                auxObj.descClasificacion = newValue.descripcion;
                auxObj.clasificacion = newValue.registro;
                print("Nuevo tipo de cliente seleccionado ${newValue.descripcion}");
              });
            },
            onSaved: (Clasificacion newValue) {
              setState(() {
                _clasificacion = newValue;
                auxObj.descClasificacion = newValue.descripcion;
                auxObj.clasificacion = newValue.registro;
              });
            },
            items: clasificaciones.map((Clasificacion clasificacion) {
              return new DropdownMenuItem<Clasificacion>(
                value: clasificacion,
                child: new Text(
                  clasificacion.descripcion,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),

        //Primer Apellido/Razon social

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: razonSocialTEC,
            decoration: InputDecoration(
                labelText: 'Primer Apellido/Razón Social',
                icon: Icon(Icons.filter_1)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onChanged: (val){
              setState(() {
                auxObj.primerApellido = val;
                auxBasicoObj.primerApellido = val;
                //TODO make this work with listners on _tercero
                _tercero.text == "Intermediario" ? puntoVentaTEC.text = razonSocialTEC.text : "";
              });
            },
            onSaved: (val) => setState(() {
              auxObj.primerApellido = val;
              auxBasicoObj.primerApellido = val;
            }),
          ),
        ),

        _tipo != null
            ? (_tipo.descripcion != "Nit" ? datosPersonaNatural : Container())
            : Container(),

        SizedBox(
          height: 30,
        ),
      ], // children principal
    );

    Widget datosContacto = ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Contacto",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: direccionTEC,
            decoration:
                InputDecoration(labelText: 'Dirección', icon: Icon(Icons.home)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onFieldSubmitted: (_){
              FocusScope.of(context).requestFocus(_municipioFocus);
            },
            onSaved: (val) => setState(() {
              auxObj.direccion = val;
              auxBasicoObj.direccion = val;
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SimpleAutocompleteFormField<Ubicacion>(
            //TODO Freelancer - Capitalize the first letter with inputFormatters: [],
            focusNode: _municipioFocus,
            controller: _ubicacion,
            decoration: InputDecoration(
                labelText: 'Ciudad/Municipio', icon: Icon(Icons.search),),
            suggestionsHeight: 120.0,
            itemBuilder: (context, ubicacion) => Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ubicacion.municipio,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(ubicacion.departamento),
                    Text(ubicacion.region)
                  ]),
            ),
            onSearch: (search) async => ubicaciones
                .where((ubicacion) =>
                    ubicacion.municipio
                        .toLowerCase()
                        .contains(search.toLowerCase()) ||
                    ubicacion.departamento
                        .toLowerCase()
                        .contains(search.toLowerCase()) ||
                    ubicacion.region
                        .toLowerCase()
                        .contains(search.toLowerCase()))
                .toList(),
            itemFromString: (string) => ubicaciones.singleWhere(
                (ubicacion) =>
                    ubicacion.municipio.toLowerCase() == string.toLowerCase(),
                orElse: () => null),
            onChanged: (value) {
              setState(() {
                selectedPlace = value;
                //auxObj.c_digo_dane_del_departamento = int.parse(value.c_digo_dane_del_departamento);
                if (value != null) {
                  _ubicacion.text = value.municipio;
                  print(
                      "Selected ubicacion departamento: ${auxObj.departamento},municipio: ${auxObj.municipio}");
                  print("${auxObj.c_digo_dane_del_departamento}");
                }
              });
            },
            onSaved: (value) => setState(() {
              selectedPlace = value;
              auxObj.municipio = value.municipio;
              auxObj.departamento = value.departamento;
              auxBasicoObj.municipio = value.municipio;
              auxBasicoObj.departamento = value.departamento;
              //TODO Freelancer - Remove comments on the ubication codes
              auxObj.c_digo_dane_del_municipio = int.parse(value.c_digo_dane_del_municipio);
              auxObj.c_digo_dane_del_departamento = int.parse(value.c_digo_dane_del_departamento);
            }),
            autofocus: false,
            validator: (user) => user == null ? 'Campo obligatorio.' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: celularTEC,
            decoration: InputDecoration(
                labelText: 'Telefono celular', icon: Icon(Icons.phone_iphone)),
            enabled: true,
            //Not required
            onSaved: (val) => setState(() {
              auxObj.movil = int.parse(val);
            }),
            onChanged: (val){
              auxObj.movil = int.parse(val);
            },
            onFieldSubmitted: (_){
              FocusScope.of(context).requestFocus(_fijoFocus);
            },
            keyboardType: TextInputType.phone,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: fijoTEC,
            focusNode: _fijoFocus,
            decoration: InputDecoration(
                labelText: 'Telefono fijo', icon: Icon(Icons.phone)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onChanged: (val){
              auxObj.fijo = int.parse(val);
              auxBasicoObj.fijo = int.parse(val);
            },
            onSaved: (val) => setState(() {
              auxObj.fijo = int.parse(val);
              auxBasicoObj.fijo = int.parse(val);
            }),
            keyboardType: TextInputType.phone,
            onFieldSubmitted:(_){
              FocusScope.of(context).requestFocus(_correoFocus);
            },
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            focusNode: _correoFocus,
            controller: correoTEC,
            decoration: InputDecoration(
                labelText: 'Correo electrónico', icon: Icon(Icons.alternate_email)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onChanged: (val){
              auxObj.correo = val;
            },
            onSaved: (val) {
              auxObj.correo = val;
            },
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );

    Widget datosIntermediario = ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Datos Intermediario",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<Agencia>(
            decoration: InputDecoration(
                labelText: "Agencia", icon: Icon(Icons.account_balance)),
            value: agenciaValue,
            onChanged: (Agencia newValue) {
              setState(() {
                agenciaValue = newValue;
                //print("Agencia value ${agenciaValue.descripcion}");
              });
            },
            validator: (Agencia value) {
              if (value == null ?? true) {
                return 'Campo obligatorio';
              }
              return null;
            },
            items: agencias.map((Agencia value) {
              return DropdownMenuItem<Agencia>(
                value: value,
                child: Text(value.descripcion),
              );
            }).toList(),
            onSaved: (val) => setState(() {
              auxObj.descAgencia = val.descripcion;
              auxObj.agencia = val.registro;
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: puntoVentaTEC,
            decoration: InputDecoration(
                labelText: 'Punto de venta', icon: Icon(Icons.business_center)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onFieldSubmitted: (_){
              FocusScope.of(context).requestFocus(_claveFocus);
            },
            onChanged: (val){
              auxObj.descPuntoVenta = val;
            },
            onSaved: (val) => setState(() {
              auxObj.descPuntoVenta = val;
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            focusNode: _claveFocus,
            controller: claveTEC,
            decoration:
                InputDecoration(labelText: 'Clave', icon: Icon(Icons.vpn_key)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onFieldSubmitted: (_){
              FocusScope.of(context).requestFocus(_comCumpFocus);
            },
            onChanged: (val){
              auxObj.clave = int.parse(val);
            },
            onSaved: (val) => setState(() {
              auxObj.clave = int.parse(val);
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            focusNode: _comCumpFocus,
            controller: comisionCumpTEC,
            decoration: InputDecoration(
                labelText: 'Comision Cumplimiento %', icon: Icon(Icons.account_circle)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onFieldSubmitted: (_){
              FocusScope.of(context).requestFocus(_delegaCumpFocus);
            },
            onChanged: (val){
              auxObj.comCumplimiento = double.parse(val) / 100;
            },
            onSaved: (val) => setState(() {
              auxObj.comCumplimiento = double.parse(val) / 100;
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            focusNode:_delegaCumpFocus,
            controller: delegacionCumpTEC,
            decoration: InputDecoration(
                labelText: 'Delegacion Cumplimiento', icon: Icon(Icons.attach_money)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onChanged: (val){
              auxObj.delegacionCumpl = int.parse(val);
            },
            onSaved: (val) => setState(() {
              auxObj.delegacionCumpl = int.parse(val);
            }),
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );

    Widget datosAfianzado = ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Datos Afianzado",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: cupoOperativoTEC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Cupo Operativo', icon: Icon(Icons.monetization_on)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onFieldSubmitted: (v){
              FocusScope.of(context).requestFocus(_cumActualFocus);
            },
            onChanged: (val){
              auxObj.cupoOperativo = int.parse(val);
            },
            onSaved: (val) => setState(() {
              auxObj.cupoOperativo = int.parse(val);
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            focusNode: _cumActualFocus,
            controller: cumuloActualTEC,
            decoration: InputDecoration(
                labelText: 'Cumulo Actual', icon: Icon(Icons.touch_app)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onFieldSubmitted: (v){
              FocusScope.of(context).requestFocus(_cupoDispFocus);
            },
            onChanged: (val){
              auxObj.cumuloActual = int.parse(val);
            },
            onSaved: (val) => setState(() {
              auxObj.cumuloActual = int.parse(val);
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            readOnly: true,
            focusNode: _cupoDispFocus,
            controller: cupoDisponibleTEC,
            decoration: InputDecoration(
                labelText: 'Cupo Disponible', icon: Icon(Icons.tag_faces)),
            enabled: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
            onChanged: (val){
              auxObj.cupoDisponible = int.parse(val);
            },
            onSaved: (val) => setState(() {
              auxObj.cupoDisponible = int.parse(val);
            }),
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
          title: Text(_tercero != null
              ? "Creación $_tercero"
              : "Creacion de terceros")),
      body: Form(
        key: formKey,
        // Antes SafeArea
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          children: <Widget>[
            SizedBox(height: 12.0),
            datosIdentificacion,

            SizedBox(height: 18.0),
            datosContacto,

            SizedBox(height: 12.0),
            _tercero == "Intermediario" ? datosIntermediario : Container(),

            SizedBox(height: 12.0),
            _tercero == "Afianzado" ? datosAfianzado : Container(),

//            new Container(
//                padding: const EdgeInsets.only(left: 0.0, top: 0.0),
//                child: new RaisedButton(
//                  child: const Text('Grabar'),
//                  onPressed: null,
//                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: Icon(
          Icons.update,
          color: Colors.white,
        ),
        onPressed: () {
          final form = formKey.currentState;
          if (form.validate()) {
            form.save();
            //Firestore.instance.collection("terceros").add({"Chao":"Andy"});
            //Firestore.instance.document("terceros/${auxObj.identificacion}").setData(auxObj.toMap());
            print("Identificacion despuès de validad ${auxObj.identificacion}");
            saveToFirebase();
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Tercero creado exitosamente!!'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                            'El ${auxObj.tipoTercero} ${auxObj.primerNombre != null ? auxObj.primerNombre : ""} ${auxObj.primerApellido}'),
                        Text(
                            'con identificación ${auxObj.identificacion} ha sido creado exitosamente'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Aceptar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        //Navigator.pushNamed(context, '/');
                      },
                    ),
                    FlatButton(
                      child: Text('Nueva Póliza'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/poliza');
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Formulario incompleto'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Para crear el tercero correctamente'),
                        Text(
                            'agradecemos diligenciar el formulario en su totalidad'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Aceptar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  _onAdded(Event event) {
    setState(() {
      ubicaciones.add(Ubicacion.fromMapObject(
          event.snapshot.value.cast<String, dynamic>()));
      //print("Add ${event.snapshot.key}");
    });
  }

  void _calcCupoDisp() {
    if(cupoOperativoTEC.text != "" && cumuloActualTEC.text != "") {
      var cupoOper = int.parse(cupoOperativoTEC.text);
      var cumuloAct = int.parse(cumuloActualTEC.text);
      if(cumuloAct>cupoOper){
        cupoDisponibleTEC.text = "0";
      } else{
        cupoDisponibleTEC.text = (cupoOper - cumuloAct).toString();
      }
    }else{
      cupoDisponibleTEC.text = cupoOperativoTEC.text;
    }

  }

  void saveToFirebase() {
    terceroRef
        .child("${auxObj.tipoTercero}")
        .child("${auxObj.identificacion}")
        .set(auxObj.toMap());
    terceroBasicoRef
        .child("${auxObj.tipoTercero}")
        .child("${auxObj.identificacion}")
        .set(auxBasicoObj.toMap());
  }
}
