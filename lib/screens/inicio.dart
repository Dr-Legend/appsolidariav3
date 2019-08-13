import 'package:flutter/material.dart';
import 'package:appsolidariav3/theme/style.dart';

class MenuRoute {
  const MenuRoute(this.name, this.route, this.widget);

  final widget;
  final String name;
  final String route;
}

class PaginaInicio extends StatelessWidget {
  final List<MenuRoute> menu = <MenuRoute>[
    MenuRoute("Poliza Nueva", '/poliza',
        Icon(Icons.add, size: 60.0, color: amarilloSolidaria1)),
    MenuRoute("Terceros", '/terceros',
        Icon(Icons.person_add, size: 60.0, color: amarilloSolidaria1)),
    MenuRoute("PDF", '/pdfdemo',
        Icon(Icons.picture_as_pdf, size: 60.0, color: amarilloSolidaria1)),
    MenuRoute("ML Kit", '/mlKit',
        Icon(Icons.add_circle_outline, size: 60.0, color: amarilloSolidaria1)),
/*
    menuRoute("Temporarios", '/polizas',
        Icon(Icons.list, size: 60.0, color: amarilloSolidaria1)),
    menuRoute("Conocimiento Cliente", '/auxiliares',
        Icon(Icons.people, size: 60.0, color: amarilloSolidaria1)),
    menuRoute("g_Registro", '/gregistro',
        Icon(Icons.ac_unit, size: 60.0, color: amarilloSolidaria1)),
    menuRoute("CRUD firebase", '/crudFB',
        Icon(Icons.check_circle, size: 60.0, color: amarilloSolidaria1))
        */
  ];

  @override
  Widget build(BuildContext context) {
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
                      onTap: () =>
                          Navigator.pushNamed(context, entry.route),
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
}
