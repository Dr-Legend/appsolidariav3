import 'dart:convert';

import 'package:flutter/foundation.dart';

Auxiliar auxiliarFromJson(String str) {
  final jsonData = json.decode(str);
  return Auxiliar.fromMap(jsonData);
}

String auxiliarToJson(Auxiliar data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Auxiliar with ChangeNotifier{
  String thirdPartyType;
  int clasification;
  String descClasification;
  int type;
  String descTypo;
  int id;
  String firstName;
  String lastName;
  String surname;
  String secondSurname;
  String favourite;

  String birthDate;
  int stateCode;
  String state; //State as location
  int genderCode;
  String gender;
  int civilStatusCode;
  String civilStatus;

  String address;
  int cityCode;
  String city;
  int movilPhone;
  int phone;
  String email;

  String document;

  //Intermediary
  int agencyCode;
  String agency;

  int pointOfSaleCode;
  String pointOfSale;
  int companyKey;
  double cumplimientoComision;
  int authorizedIssueQuota;

  //Policy Buyer - Afianzado

  int cupoOperativo;
  int cumuloActual;
  int cupoDisponible;


  @override
  String toString() {
    return 'Auxiliar {tipoTercero: $thirdPartyType, identificacion: $id} ';
  }

  Auxiliar(
      {this.thirdPartyType,
        this.clasification,
        this.descClasification,
        this.type,
        this.descTypo,
        this.id,
        this.firstName,
        this.lastName,
        this.surname,
        this.secondSurname,
        this.favourite,
        this.birthDate,
        this.stateCode,
        this.state,
        this.genderCode,
        this.gender,
        this.civilStatusCode,
        this.civilStatus,
        this.address,
        this.cityCode,
        this.city,
        this.movilPhone,
        this.phone,
        this.email,
        this.document,
        this.agencyCode,
        this.agency,
        this.pointOfSaleCode,
        this.pointOfSale,
        this.companyKey,
        this.cumplimientoComision,
        this.authorizedIssueQuota,
        this.cupoOperativo,
        this.cumuloActual,
        this.cupoDisponible});


  factory Auxiliar.fromMap(Map<String, dynamic> json) => new Auxiliar(
      thirdPartyType: json["auxiliar"],
      clasification: json["clasificacion"],
      descClasification: json["descClasificacion"],
      type: json["tipo"],
      descTypo: json["descTipo"],
      id: json["identificacion"],
      firstName: json["primerNombre"],
      lastName: json["segundoNombre"],
      surname: json["primerApellido"],
      secondSurname: json["segundoApellido"],
      favourite: json["favorito"],
      birthDate: json["nacimiento"],
      stateCode: json["c_digo_dane_del_departamento"],
      state: json["departamento"],
      genderCode: json["genero"],
      gender: json["descGenero"],
      civilStatusCode: json["estadoCivil"],
      civilStatus: json["descEstadoCivil"],
      address: json["direccion"],
      cityCode: json["c_digo_dane_del_municipio"],
      city: json["municipio"],
      movilPhone: json["movil"],
      phone: json["fijo"],
      email: json["correo"],
      document: json["documento"],
      agencyCode: json["agencia"],
      agency: json["descAgencia"],
      pointOfSaleCode: json["puntoVenta"],
      pointOfSale: json["descPuntoVenta"],
      companyKey: json["clave"],
      cumplimientoComision: json["comCumplimiento"],
      authorizedIssueQuota: json["delegacionCumpl"],
      cupoOperativo: json["cupoOperativo"],
      cumuloActual: json["cumuloActual"],
      cupoDisponible: json["cupoDisponible"]);

  Map<String, dynamic> toMap() => {
    "clasificacion": clasification,
    "descClasificacion": descClasification,
    "tipo": type,
    "descTipo": descTypo,
    "auxiliar": thirdPartyType,
    "identificacion": id,
    "primerNombre": firstName,
    "segundoNombre": lastName,
    "primerApellido": surname,
    "segundoApellido": secondSurname,
    "favorito": favourite,
    "nacimiento": birthDate,
    "c_digo_dane_del_departamento": stateCode,
    "departamento": state,
    "genero": genderCode,
    "descGenero": gender,
    "estadoCivil": civilStatusCode,
    "descEstadoCivil": civilStatus,
    "direccion": address,
    "c_digo_dane_del_municipio": cityCode,
    "municipio": city,
    "movil": movilPhone,
    "fijo": phone,
    "correo": email,
    "documento": document,
    "agencia": agencyCode,
    "descAgencia": agency,
    "puntoVenta": pointOfSaleCode,
    "descPuntoVenta": pointOfSale,
    "clave": companyKey,
    "comCumplimiento": cumplimientoComision,
    "delegacionCumpl": authorizedIssueQuota,
    "cupoOperativo": cupoOperativo,
    "cumuloActual": cumuloActual,
    "cupoDisponible": cupoDisponible,
  };
}

class AuxBasico {
  String primerNombre;
  String primerApellido;
  int identificacion;
  String direccion;
  String municipio;
  String departamento;
  int fijo;

  AuxBasico({this.primerNombre, this.primerApellido, this.identificacion});

  //This function is to convert Genero Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['primerNombre'] = primerNombre;
    map['primerApellido'] = primerApellido;
    map['identificacion'] = identificacion;
    map['direccion'] = direccion;
    map['municipio'] = municipio;
    map['departament'] = departamento;
    map['fijo'] = fijo;
    return map;
  }

  AuxBasico.fromMapObject(Map<String, dynamic> map) {
    this.primerNombre = map['primerNombre'];
    this.primerApellido = map['primerApellido'];
    this.identificacion = map['identificacion'];
    this.direccion = map['direccion'];
    this.municipio = map['municipio'];
    this.departamento = map['departamento'];
    this.fijo = map['fijo'];
  }

  @override
  String toString() {
    return '$primerApellido';
  }


}

class Genero {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Genero.withId(this._registro, this._descripcion);

  Genero(this._descripcion);

  int get registro => _registro;

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Genero Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Genero.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}

class EstadoCivil {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  EstadoCivil.withId(this._registro, this._descripcion);

  EstadoCivil(this._descripcion);

  int get registro => _registro;

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert EstadoCivil Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  EstadoCivil.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}

class Tipo {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Tipo.withId(this._registro, this._descripcion);

  Tipo(this._descripcion);

  int get registro => _registro;

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Tipo Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Tipo.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}

class Ubicacion {
  String c_digo_dane_del_departamento;
  String c_digo_dane_del_municipio;
  String departamento;
  String municipio;
  String region;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['c_digo_dane_del_departamento'] = c_digo_dane_del_departamento;
    map['c_digo_dane_del_municipio'] = c_digo_dane_del_municipio;
    map['departamento']=departamento;
    map['municipio']=municipio;
    map['region'] = region;
    return map;
  }

  Ubicacion.fromMapObject(Map<String, dynamic> map) {
    this.c_digo_dane_del_departamento = map['c_digo_dane_del_departamento'];
    this.c_digo_dane_del_municipio = map['c_digo_dane_del_municipio'];
    this.departamento = map['departamento'];
    this.municipio = map['municipio'];
    this.region = map['region'];
  }


}

class Clasificacion {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Clasificacion.withId(this._registro, this._descripcion);

  Clasificacion(this._descripcion);

  //Clasificacion();

  int get registro {
    if(_registro == null){
      return _registro = 0;
    } else{
      return _registro;
    }
  }

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Clasificacion Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Clasificacion.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}

class Agencia {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Agencia.withId(this._registro, this._descripcion);

  Agencia(this._descripcion);

  int get registro => _registro;

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Agencia Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Agencia.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}


class PuntoVenta {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  PuntoVenta.withId(this._registro, this._descripcion);

  PuntoVenta(this._descripcion);

  int get registro => _registro;

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Agencia Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  PuntoVenta.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}




class Lugar {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Lugar.withId(this._registro, this._descripcion);

  Lugar(this._descripcion);

  int get registro => _registro;

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Lugar Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Lugar.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}

class Municipio {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Municipio.withId(this._registro, this._descripcion);

  Municipio(this._descripcion);

  int get registro {
    if(_registro == null){
      return _registro = 0;
    } else{
      return _registro;
    }
  }

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Municipio Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Municipio.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}

class Documento {
  // fixCombo (16 feb 2019): Nueva clase para el combo

  int _registro;
  String _descripcion;
  String _parametro0;

  Documento.withId(this._registro, this._descripcion);

  Documento(this._descripcion);

  int get registro {
    if(_registro == null){
      print("Registro en Documento = null $_registro");
      return _registro = 0;
    } else{
      return _registro;
    }
  }

  String get descripcion => _descripcion;

  String get parametro0 => _parametro0;

  set descripcion(String value) {
    _descripcion = value;
  }

  set parametro0(String value) {
    _parametro0 = value;
  }

  //This function is to convert Municipio Object to Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (registro != null) {
      map['registro'] = _registro;
    }
    map['descripcion'] = _descripcion;
    map['parametro0'] = _parametro0;
    return map;
  }

  Documento.fromMapObject(Map<String, dynamic> map) {
    this._registro = map['registro'];
    this._descripcion = map['descripcion'];
    this._parametro0 = map['parametro0'];
  }
}