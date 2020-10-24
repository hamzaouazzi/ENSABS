import 'package:flutter/material.dart';
import '../models/student.dart';
import 'package:intl/intl.dart';
import '../models/absence.dart';
import 'dart:async';
import '../utils/database_helper.dart';
 
class AbsenceList extends StatefulWidget {
 // final String title;
  final Student student;
 
  AbsenceList(this.student) ;
 
  @override
  State<StatefulWidget> createState() {
    return _AbsenceListState(this.student);
  }
}
 
class _AbsenceListState extends State<AbsenceList> {
  //
  Future<List<Absence>> absences;
  TextEditingController controller = TextEditingController();
  String observation;
  int curAbsenceId;
  Student student;
 
  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  _AbsenceListState(this.student);
 
  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    isUpdating = false;
    refreshList();
  }
 
  refreshList() {
    setState(() {
      absences = dbHelper.getAbsenceList(student);
    });
  }
 
  clearName() {
    controller.text = '';
  }
 
  validate() {
    print('current StdID');
    print(this.student.id);
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      String dateAbsence = DateFormat.yMMMd().format(DateTime.now());
      if (isUpdating) {
        Absence absence = Absence.withAll(curAbsenceId,dateAbsence,observation,this.student.id);
        dbHelper.updateAbsence(absence,student);
        setState(() {
          isUpdating = false;
        });
      } else {
        Absence absence = Absence.withStdId(dateAbsence,observation,this.student.id);
        dbHelper.insertAbsence(absence,student);
      }
      clearName();
      refreshList();
    }
  }
 
  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Absence Comment'),
              validator: (val) => val.length == 0 ? 'Enter comment' : null,
              onSaved: (val) => observation = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: Text('CANCEL'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
 
  SingleChildScrollView dataTable(List<Absence> absences) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("DATE"),
            numeric: false,
            tooltip: "Date of absence",
          ),
          DataColumn(
            label: Text("COMMENT"),
            numeric: false,
            tooltip: "This is Justification",
          ),
          DataColumn(
            label: Text('DELETE'),
          )
        ],
        rows: absences
            .map(
              (absence) => DataRow(cells: [
                    DataCell(
                      Text(absence.dateAbsence),
                      onTap: () {
                        setState(() {
                          isUpdating = true;
                          curAbsenceId = absence.id;
                        });
                        controller.text = absence.dateAbsence;
                      },
                    ),
                    DataCell(
                      Text(absence.observation),
                      onTap: () {
                        setState(() {
                          isUpdating = true;
                          curAbsenceId = absence.id;
                        });
                        controller.text = absence.observation;
                      },
                    ),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        dbHelper.deleteAbsence(absence.id);
                        refreshList();
                      },
                    )),
                  ]),
            )
            .toList(),
      ),
    );
  }
 
  list() {
    return Expanded(
      child: FutureBuilder(
        future: absences,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
 
          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No Data Found");
          }
 
          return CircularProgressIndicator();
        },
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(student.fullName +' Absences')
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }
}