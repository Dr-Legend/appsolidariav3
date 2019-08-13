import 'dart:async';
import 'package:flutter/widgets.dart' as fw;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

const PdfColor green = PdfColor.fromInt(0xff9ce5d0);
const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
const PdfColor black = PdfColor.fromInt(0x000000);
const PdfColor grey = PdfColor.fromInt(0xA9A9A9);

class MyPage extends Page {
  MyPage(
      {PdfPageFormat pageFormat = PdfPageFormat.a4,
        BuildCallback build,
        EdgeInsets margin})
      : super(pageFormat: pageFormat, margin: margin, build: build);

  @override
  void paint(Widget child, Context context) {
    context.canvas;

    super.paint(child, context);
  }
}

class Block extends StatelessWidget {
  Block({this.title, this.amount});

  final String title;
  final String amount;

  @override
  Widget build(Context context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(title, style: TextStyle(color: black, fontSize: 6)),
          ),
          Container(
              margin: EdgeInsets.only(top: 3),
              alignment: Alignment.center,
              child: Text(amount,
                  style: TextStyle(
                      color: black, fontSize: 10, fontWeight: FontWeight.bold)))
        ]);
  }
}

class Category extends StatelessWidget {
  Category({this.title});

  final String title;

  @override
  Widget build(Context context) {
    return Container(
        decoration: const BoxDecoration(color: lightGreen, borderRadius: 6),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
        child: Text(title, textScaleFactor: 1.5));
  }
}

class TitleText extends StatelessWidget {
  TitleText({this.title});

  final String title;

  @override
  Widget build(Context context) {
    return Text(title, style: TextStyle(fontSize: 8));
  }
}

class TitleTextValue extends StatelessWidget {
  TitleTextValue({this.title});

  final String title;

  @override
  Widget build(Context context) {
    return Text(title,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold));
  }
}

class BlackBoldText extends StatelessWidget {
  BlackBoldText({this.title});

  final String title;

  @override
  Widget build(Context context) {
    return Text(title,
        style:
        TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: black));
  }
}

class NormalText extends StatelessWidget {
  NormalText({this.title});

  final String title;

  @override
  Widget build(Context context) {
    return Text(title, style: TextStyle(fontSize: 8, color: black));
  }
}

class PdfData {
  final String AGENCIA_EXPEDIDORA;
  final int COD_AGENCIA;
  final int RAMO;
  final String TIPO_DE_MOVIMIENTO;
  final String TIPO_DE_IMPRESION;

  final int FECHA_DIA;
  final int FECHA_MES;
  final int FECHA_ANO;

  final int IMPRESION_DIA;
  final int IMPRESION_MES;
  final int IMPRESION_ANO;

  final String VALOR_ASEGURADO_TOTAL;
  final String VALOR_PRIMA;
  final String GASTOS_EXPEDICION;
  final String IVA;
  final String TOTAL_A_PAGAR;

  PdfData(
      this.AGENCIA_EXPEDIDORA,
      this.COD_AGENCIA,
      this.RAMO,
      this.TIPO_DE_MOVIMIENTO,
      this.TIPO_DE_IMPRESION,
      this.FECHA_DIA,
      this.FECHA_MES,
      this.FECHA_ANO,
      this.IMPRESION_DIA,
      this.IMPRESION_MES,
      this.IMPRESION_ANO,
      this.VALOR_ASEGURADO_TOTAL,
      this.VALOR_PRIMA,
      this.GASTOS_EXPEDICION,
      this.IVA,
      this.TOTAL_A_PAGAR);
}

Future<Document> generateDocument(PdfPageFormat format) async {
  PdfData tempObject = PdfData(
    "BOGOTÁ CALLE 100",
    376,
    45,
    "EXPEDICION",
    "REIMPRESION",
    23,
    05,
    2017,
    23,
    05,
    2017,
    "****12,000,000.00",
    "***********18,000",
    "*****9,000.00",
    "********5,130",
    "***********32,130",
  );

  final PdfDoc pdf = PdfDoc(title: 'Chimbi Pdf', author: 'Chimbi');

  final PdfImage profileImage = await pdfImageFromImageProvider(
      pdf: pdf.document,
      image:
      const fw.NetworkImage('https://i.ibb.co/dQDz2ys/logo-Solidaria.png'),
      onError: (dynamic exception, StackTrace stackTrace) {
        print('Unable to download image');
      });

  pdf.addPage(
    MyPage(
      pageFormat: format.applyMargin(
          left: 0.3 * PdfPageFormat.cm,
          top: 0.3 * PdfPageFormat.cm,
          right: 0.3 * PdfPageFormat.cm,
          bottom: 0.3 * PdfPageFormat.cm),
      build: (Context context) => Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10),
          height: 55,
          alignment: Alignment.centerLeft,
          child: Image(profileImage, fit: BoxFit.contain),
        ),
        Container(
            margin: EdgeInsets.all(10),
            decoration: const BoxDecoration(
                border: BoxBorder(
                    left: true,
                    top: true,
                    bottom: true,
                    right: true,
                    color: grey,
                    width: 1),
                borderRadius: 16),
            padding: const EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: <Widget>[
                      TitleText(title: "AGENCIA EXPEDIDORA:  "),
                      TitleTextValue(title: tempObject.AGENCIA_EXPEDIDORA)
                    ]),
                    Row(children: <Widget>[
                      Row(children: <Widget>[
                        TitleText(title: "COD. AGENCIA:  "),
                        TitleText(title: tempObject.COD_AGENCIA.toString())
                      ]),
                      Container(width: 10),
                      Row(children: <Widget>[
                        TitleText(title: "RAMO:"),
                        TitleText(title: "  45")
                      ]),
                      Container(width: 100),
                    ]),
                  ]),
              Container(height: 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: <Widget>[
                      TitleText(title: "TIPO DE MOVIMIENTO:  "),
                      TitleTextValue(title: tempObject.TIPO_DE_MOVIMIENTO)
                    ]),
                    Row(children: <Widget>[
                      TitleText(title: "TIPO DE IMPRESIÓN:  "),
                      TitleText(title: tempObject.TIPO_DE_IMPRESION)
                    ]),
                    Row(children: <Widget>[
                      Row(children: <Widget>[
                        Column(children: <Widget>[
                          Row(children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              width: 22,
                              child: NormalText(title: 'DIA'),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 20,
                              child: NormalText(title: 'MES'),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 33,
                              child: NormalText(title: 'AÑO'),
                            ),
                          ]),
                          Container(margin: EdgeInsets.only(bottom: 2)),
                          Row(children: <Widget>[
                            Container(width: 1, height: 11, color: black),
                            Container(
                              alignment: Alignment.center,
                              width: 20,
                              child: BlackBoldText(
                                  title: tempObject.FECHA_DIA.toString()),
                            ),
                            Container(height: 11, width: 1, color: black),
                            Container(
                              alignment: Alignment.center,
                              width: 20,
                              child: BlackBoldText(
                                  title: tempObject.FECHA_MES.toString()),
                            ),
                            Container(height: 11, width: 1, color: black),
                            Container(
                              alignment: Alignment.center,
                              width: 31,
                              child: BlackBoldText(
                                  title: tempObject.FECHA_ANO.toString()),
                            ),
                            Container(height: 11, width: 1, color: black),
                          ]),
                          Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              height: 1,
                              width: 75,
                              color: black),
                          Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Text("FECHA DE EXPEDICIÓN",
                                style: TextStyle(fontSize: 5)),
                          )
                        ]),
                      ]),
                      Container(width: 10),
                      Row(children: <Widget>[
                        Column(children: <Widget>[
                          Row(children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              width: 22,
                              child: NormalText(title: 'DIA'),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 20,
                              child: NormalText(title: 'MES'),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 33,
                              child: NormalText(title: 'AÑO'),
                            ),
                          ]),
                          Container(margin: EdgeInsets.only(bottom: 2)),
                          Row(children: <Widget>[
                            Container(width: 1, height: 11, color: black),
                            Container(
                              alignment: Alignment.center,
                              width: 20,
                              child: BlackBoldText(
                                  title:
                                  tempObject.IMPRESION_DIA.toString()),
                            ),
                            Container(height: 11, width: 1, color: black),
                            Container(
                              alignment: Alignment.center,
                              width: 20,
                              child: BlackBoldText(
                                  title:
                                  tempObject.IMPRESION_MES.toString()),
                            ),
                            Container(height: 11, width: 1, color: black),
                            Container(
                              alignment: Alignment.center,
                              width: 31,
                              child: BlackBoldText(
                                  title:
                                  tempObject.IMPRESION_ANO.toString()),
                            ),
                            Container(height: 11, width: 1, color: black),
                          ]),
                          Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              height: 1,
                              width: 75,
                              color: black),
                          Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Text("FECHA DE IMPRESIÓN",
                                style: TextStyle(fontSize: 5)),
                          )
                        ]),
                      ]),
                    ])
                  ]),
            ])),
        Container(
            margin: EdgeInsets.all(10),
            decoration: const BoxDecoration(
                border: BoxBorder(
                    left: true,
                    top: true,
                    bottom: true,
                    right: true,
                    color: grey,
                    width: 1),
                borderRadius: 16),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Block(
                          title: "VALOR ASEGURADO TOTAL:",
                          amount: tempObject.VALOR_ASEGURADO_TOTAL),
                      flex: 1),
                  Container(height: 40, width: 1, color: grey),
                  Expanded(
                      child: Block(
                          title: "VALOR PRIMA:",
                          amount: tempObject.VALOR_PRIMA),
                      flex: 1),
                  Container(height: 40, width: 1, color: grey),
                  Expanded(
                      child: Block(
                          title: "GASTOS EXPEDICION:",
                          amount: tempObject.GASTOS_EXPEDICION),
                      flex: 1),
                  Container(height: 40, width: 1, color: grey),
                  Expanded(
                      child: Block(title: "IVA:", amount: tempObject.IVA),
                      flex: 1),
                  Container(height: 40, width: 1, color: grey),
                  Expanded(
                      child: Block(
                          title: "TOTAL A PAGAR:",
                          amount: tempObject.TOTAL_A_PAGAR),
                      flex: 1),
                ])),
      ]),
    ),
  );
  return pdf;
}
