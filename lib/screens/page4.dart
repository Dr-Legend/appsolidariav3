import 'package:appsolidariav3/model/polizaModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TitleTextValue extends StatelessWidget {
  TitleTextValue({this.title, this.value});

  final String title;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text("$title: ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        Text("$value", style: TextStyle(fontSize: 15)),
      ],
    );
  }
}

class SectionText extends StatelessWidget {
  SectionText({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20,),
        Text("$title",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Theme.of(context).hintColor)),
        Text("----------------",style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.bold, fontSize: 20),),
      ],
    );
  }
}

class Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    var polizaObj = Provider.of<Poliza>(context);
    return polizaObj.filledState == 1 ? Column(
      children: <Widget>[
        SectionText(title: "Lista de fechas"),
        TitleTextValue(title: "Lista de fechas", value: polizaObj.listDatesCovers.toString()),
        SectionText(title: "Tipo de Poliza"),
        TitleTextValue(title: "Tipo de póliza", value: polizaObj.polizaType),
        TitleTextValue(title: "Clausulado", value: polizaObj.productConditions),
        TitleTextValue(title: "Texto", value: polizaObj.textProdConditions),
        SectionText(title: "Información de Terceros"),
        //TODO Bug for some reason surname is called on null the other fields don't have the problem
        polizaObj.policyBuyer != null ? TitleTextValue(title: "Afinazado", value: polizaObj.policyBuyer.surname): null,
        TitleTextValue(title: "Nit", value: polizaObj.policyBuyer.id),
        polizaObj.contractor.surname != null ? TitleTextValue(title: "Tomador/Asegurado", value: polizaObj.contractor.surname) : null,
        TitleTextValue(title: "Nit", value: polizaObj.contractor.id),
        polizaObj.beneficiary.surname != null ? TitleTextValue(title: "Beneficiario", value: polizaObj.beneficiary.surname) : null,
        TitleTextValue(title: "Nit", value: polizaObj.contractor.id),
        SectionText(title: "Vigencia de la póliza"),
        TitleTextValue(title: "Fecha desde", value: polizaObj.policyInitialDate),
        TitleTextValue(title: "Fecha hasta", value: polizaObj.policyFinalDate),
        SectionText(title: "Información del contrato"),
        TitleTextValue(title: "Tipo de Negocio", value: polizaObj.businessType),
        TitleTextValue(
            title: "Objeto del seguro", value: polizaObj.insuranceObject),
        TitleTextValue(title: "Texto", value: polizaObj.objectText),
        TitleTextValue(
            title: "Texto Aclaratorio", value: polizaObj.aclaratoryText),
        TitleTextValue(title: "# Contrato", value: polizaObj.treatyNumber),
        TitleTextValue(title: "Valor Contrato", value: polizaObj.treatyValue),
        SectionText(title: "Detalle Amparos"),
        Column(
          children: polizaObj.covers.map((a) {
            return Column(
              children: <Widget>[
                Text("${a.coverName}", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                TitleTextValue(title: "Porcentaje",value: a.porcentage),
                TitleTextValue(title: "Fecha desde",value: a.initialDate),
                TitleTextValue(title: "Fecha hasta",value: a.finalDate),
                TitleTextValue(title: "Valor Asegurado",value: a.insuredValue),
                TitleTextValue(title: "Tasa",value: a.coverRate),
                TitleTextValue(title: "Prima Amparo",value: a.insurancePremium),
              ],
            );
          }).toList(),
        ),
      ],
    ) : Center(child: Text("No info yet"));
  }
}
