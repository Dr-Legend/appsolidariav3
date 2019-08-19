import 'dart:convert';
import 'package:appsolidariav3/model/amparoModel.dart';
import 'package:appsolidariav3/model/auxiliarModel.dart';
import 'package:flutter/foundation.dart';

Poliza polizaFromJson(String str) {
  final jsonData = json.decode(str);
  return Poliza.fromMap(jsonData);
}

String polizaToJson(Poliza data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Poliza with ChangeNotifier{

  ///NOT IN THE FORM
  Auxiliar intermediario;
  Auxiliar afianzado;
  Auxiliar contratante;
  Auxiliar beneficiario;

  
  //version 1: 1 Intermediario version2: varios intermediarios
  //double comision;  //Porcentaje de comisión se utiliza cuando hay varios intermediarios

  //Ramo comercial
  String descRamo = "Cumplimiento";


  //Tipo de movimiento: Tipos de anexos. Espedicion
  //TODO definir que campos van a nivel de anexo y separarlos en un objeto aparte

  //Afianzado afianzado;
  //version 1: 1 Afianzado version2: varios afianzados


//TODO Añadir mas tomadores para Consorcio o temporal. el de mayor participacion es el tomador si no hay nit ni nombre

  ///title: Caracteristicas de la póliza
  String fechaEmision = DateTime.now().toString(); //Not in the form
  String vigDesde; //In the form as Date field Vigencia desde hora desde 00:00
  String vigHasta;  //Not in the form TODO 1. Calcular con la máxima fecha de los amparos
  int cupoDisponible;

  String tipoCambio = "Pesos"; //Not in the form
  //Cobra iva siempre
  String productoClausulado; //Dropdown in the form "Clausulado1: "Lorem ipsum", "Clausulado2":"Lorem ipsum2", "Clausuado3":"Lorem ipsum3"
  String textoClausulado;
  String descTipoOperacion = "100% Compañia";  //NOT IN THE FORM 100% Compañia, Coaseguro Cedido, Coaseguro Aceptado //Incluir en el modelo List<CiasSeguros>
  String descTipoPoliza;  // DropdownFormField "Particular, Estatal, Servicios Publicos Domiciliarios, Poliza Ecopetrol, Empresas públicas con régimen privado"
  String descTipoNegocio;
  //Tipo de Negocio: Contrato, contrato de arrendamiento, contrato de consultoria,
  //contrato de ejecucion de obra, contrato de interventoria, contrato de prestacion de servicios

//--------  Se notifica el temporario con esta informacion ---------------------------------------

  int temporario = 5678; //TODO Revisar la cantidad the caracteres
  int numPoliza = 1234; //TODO Revisar la cantidad the caracteres

  ///Información del riesgo
  int nitContratante;
  String numeroContrato;
  double valorContrato;  //Nivel anexo
  int plazoEjecucion;   //En años
  String fechaFinContrato;  //Asignar a vigDesde
  String objetoSeguro;  //Contrato, Orden compra, Orden servicio, Orden suministro, Factura venta, Pliego condiciones
  String textoAclaratorio; //Ver como funciona con un texto largo TODO crear en formulario

  ///Coberturas

  List<Amparo> amparos = [];
  List<DateTime> vigAmparos = List();


  //int poliza;  //Consecutivo sistema, revisar si se necesita
  int estado = 1; //1 Borrador 2. Revision 3. Emision


  //int retroactividad;

  ///Valores totales de la póliza
  int valAsegTotal;
  double primaTotal;
  double valComision;

  Poliza({this.vigAmparos, this.intermediario,this.afianzado,this.contratante,this.beneficiario,
    this.cupoDisponible,this.descRamo, this.fechaEmision, this.vigDesde, this.vigHasta,
    this.tipoCambio, this.productoClausulado, this.textoClausulado, this.descTipoOperacion,
    this.descTipoPoliza, this.descTipoNegocio, this.temporario,
    this.numPoliza, this.nitContratante, this.numeroContrato,
    this.valorContrato, this.plazoEjecucion, this.fechaFinContrato,
    this.objetoSeguro, this.textoAclaratorio, this.amparos, this.estado,
    this.valAsegTotal, this.primaTotal, this.valComision});

  factory Poliza.fromMap(Map<String, dynamic> json) => new Poliza(
      intermediario: json["intermediario"], afianzado:  json["afianzado"], contratante:  json["contratante"],
      cupoDisponible: json["cupoDisponible"], beneficiario: json["beneficiario"], descRamo: json["descRamo"], fechaEmision: json["fechaEmision"],
      vigDesde: json["vigDesde"], vigHasta: json["vigHasta"], tipoCambio: json["tipoCambio"],
      productoClausulado: json["productoClausulado"],textoClausulado: json["textoClausulado"],
      descTipoOperacion: json["descTipoOperacion"], descTipoPoliza: json["descTipoPoliza"],
      descTipoNegocio: json["descTipoNegocio"], temporario: json["temporario"], numPoliza: json["numPoliza"],
      nitContratante: json["nitContratante"], numeroContrato: json["numeroContrato"],
      valorContrato: json["valorContrato"], plazoEjecucion: json["plazoEjecucion"], fechaFinContrato: json["fechaFinContrato"],
      objetoSeguro: json["objetoSeguro"], textoAclaratorio: json["textoAclaratorio"],
      amparos: json["amparos"], estado: json["estado"], valAsegTotal: json["valAsegTotal"],
      primaTotal: json["primaTotal"], valComision: json["valComision"]
  );

  Map<String, dynamic> toMap() => {

    "intermediario" : intermediario, "afianzado" : afianzado, "contratante" : contratante,
    "cupoDisponible": cupoDisponible,"beneficiario": beneficiario, "descRamo" : descRamo ,
    "fechaEmision": fechaEmision, "vigDesde": vigDesde, "vigHasta": vigHasta,
    "tipoCambio": tipoCambio, "productoClausulado": productoClausulado, "textoClausulado":textoClausulado, "descTipoOperacion": descTipoOperacion,
    "descTipoPoliza": descTipoPoliza, "descTipoNegocio": descTipoNegocio, "temporario": temporario,
    "numPoliza": numPoliza, "nitContratante": nitContratante, "numeroContrato": numeroContrato,
    "valorContrato": valorContrato, "plazoEjecucion": plazoEjecucion, "fechaFinContrato": fechaFinContrato,
    "objetoSeguro": objetoSeguro, "textoAclaratorio": textoAclaratorio, "amparos": amparos, "estado": estado,
    "valAsegTotal": valAsegTotal, "primaTotal": primaTotal, "valComision": valComision,
  };



  @override
  String toString() {
    return 'VigDesde: $vigDesde, VigHasta $vigHasta, vigAmparos: ${vigAmparos.toString()}, Intermediario: $intermediario, Afianzado: $afianzado, Contratante: $contratante, Beneficiario: $beneficiario,'
    'CupoDisp: $cupoDisponible, Ramo: $descRamo, FechaEmision: $fechaEmision, TipoCambio: $tipoCambio, ProdClausulado: $productoClausulado, TextoClaus: $textoClausulado, TipoOperacion: $descTipoOperacion,'
    'TipoPoliza: $descTipoPoliza, TipoNegocio: $descTipoNegocio, Temporario: $temporario,'
    'NumPoliza: $numPoliza, NitContratante: $nitContratante, NumeroContrato: $numeroContrato,'
    'ValorContrato: $valorContrato, PlazoEjecucion: $plazoEjecucion, FinContrato: $fechaFinContrato,'
    'ObjetoSeguro: $objetoSeguro, TextoAclarat: $textoAclaratorio, Amparos:---$amparos, Estado: $estado,'
    'VlrAsegTotal: $valAsegTotal, PrimaTotal: $primaTotal, ValComision: $valComision';
  }

}

