import 'package:appsolidariav3/model/polizaModel.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DatesTest extends StatefulWidget {
  @override
  _DatesTestState createState() => _DatesTestState();
}

class _DatesTestState extends State<DatesTest> {
  List<DateTime> dates = [DateTime(2019), DateTime(2018), DateTime(2017)];

  DateFormat dateFormat = new DateFormat('dd-MM-yyyy');

  TextEditingController firstController = TextEditingController();

  TextEditingController secondController = TextEditingController();

  TextEditingController thirdController = TextEditingController();

  TextEditingController fourthController = TextEditingController();

  List<TextEditingController> controllers = [];

  DateTime initialDate = DateTime.now();

  final GlobalKey<FormState> formKey = GlobalKey();

  DateTime minDate;
  DateTime _fechaEmision = DateTime.now();

  @override
  void initState() {
    minDate = DateTime(_fechaEmision.year, _fechaEmision.month - 5, _fechaEmision.day);

    /*
    controllers = [
      firstController,
      secondController,
      thirdController,
      fourthController
    ];
    */
    controllers = dates.map((e) {
      return TextEditingController();
    }).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var polizaObj = Provider.of<Poliza>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: dates.length,
                itemBuilder: (BuildContext context, int index) {
                  return DateTimeField(
                    format: dateFormat,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
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
                      if(date!=null){
                        print("MinDate $minDate");
                        if(minDate.isAfter(date)){
                          print("Fecha invalida ${date}");
                        } else{
                          polizaObj.covers[index].initialDate = date.toString();
                          print("Fecha en objeto ${polizaObj.covers[index].initialDate}");
                        }
                      }
                    }),
                    onSaved: (date) => setState(() {
                      polizaObj.covers[index].initialDate = date.toString();
                    }),
                    resetIcon: Icon(Icons.delete),
                    readOnly: false,
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                child: Text("${polizaObj.listDatesCovers}"),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      final form = formKey.currentState;
                      if (form.validate()) {
                        print(polizaObj.covers.toList());
                      }
                    },
                    child: Text("Submit"),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      polizaObj.listDatesCovers = List();
                    },
                    child: Text("Clear"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
