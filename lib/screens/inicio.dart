import 'package:appsolidariav3/model/auxiliarModel.dart';
import 'package:appsolidariav3/model/polizaModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:appsolidariav3/theme/style.dart';
import 'package:provider/provider.dart';

class MenuRoute {
  const MenuRoute(this.name, this.route, this.widget);

  final widget;
  final String name;
  final String route;
}

class PaginaInicio extends StatefulWidget {
  @override
  _PaginaInicioState createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio>{
  final List<MenuRoute> menu = <MenuRoute>[
    MenuRoute("Poliza Nueva", '/poliza',
        Icon(Icons.add, size: 60.0, color: amarilloSolidaria1)),
    MenuRoute("Terceros", '/terceros',
        Icon(Icons.person_add, size: 60.0, color: amarilloSolidaria1)),
    MenuRoute("PDF", '/pdfdemo',
        Icon(Icons.picture_as_pdf, size: 60.0, color: amarilloSolidaria1)),
    MenuRoute("ML Kit", '/mlKit',
        Icon(Icons.add_circle_outline, size: 60.0, color: amarilloSolidaria1)),
  ];
  //Crear instancia de Base de datos de firebase
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference intermediarioRef;


  @override
  void initState(){
    intermediarioRef = database.reference().child("terceros").child("Intermediario");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var polizaObj = Provider.of<Poliza>(context);

    //Init polizaObj with intermediario id 1234

    //print("PolizaObj After init: ${polizaObj.toString()}");

    return Scaffold(
      appBar: AppBar(
        title: Text("Menú Inicio"),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0.0,60.0,0.0,8.0),
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/logo1.png",
                scale: 0.9,
              ),
            ),
            Container(
              //alignment: AlignmentDirectional(0.0, 0.0),
              margin: EdgeInsets.only(top: 190.0),
              child: GridView(
                physics: BouncingScrollPhysics(),
                // if you want IOS bouncing effect, otherwise remove this line
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                //change the number as you want
                children: menu.map((entry) {
                  if (entry != null) {
                    return InkWell(
                      onTap: () async {
                        Navigator.pushNamed(context, entry.route);
                        if(entry.route == "/poliza"){
                          polizaObj.intermediary = await intermediarioInit(intermediarioRef, 1234);
                          polizaObj.notifyListeners();
                          print("PolizaObj en ruta ${polizaObj.toString()}");
                        }
                      },
                      child: Card(
                          margin: EdgeInsets.all(5.0),
                          color: azulSolidaria2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ListTile(
                                title: Center(
                                  child: Text(
                                    "${entry.name}",
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: entry.widget,
                              ),
                            ],
                          )),
                    );
                  } else
                    return null;
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Auxiliar> intermediarioInit(DatabaseReference dbRef, int idInterm) async {
    Auxiliar intermediario;
    intermediario = await dbRef.child("$idInterm").once().then((val){
      if(val.value != null){
        return Auxiliar.fromMap(val.value.cast<String, dynamic>());
      } else{
        return null;
      }
    });
    return intermediario;
  }
}

