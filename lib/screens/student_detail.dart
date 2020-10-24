import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/section.dart';
import 'package:flutter_app/models/student.dart';
import 'package:flutter_app/utils/database_helper.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'absence_list.dart';

class StudentDetail extends StatefulWidget {

	final String appBarTitle;
	final Student student;
  final Section section;

	StudentDetail(this.student,this.section,this.appBarTitle);

	@override
  State<StatefulWidget> createState() {

    return StudentDetailState(this.student,this.section, this.appBarTitle);
  }
}

class StudentDetailState extends State<StudentDetail> {

	static var _priorities = ['High', 'Low'];

	DatabaseHelper helper = DatabaseHelper();

	String appBarTitle;
	Student student;
  Section section;

	TextEditingController nameController = TextEditingController();
	TextEditingController codeController = TextEditingController();

	StudentDetailState(this.student,this.section, this.appBarTitle);

	@override
  Widget build(BuildContext context) {

		TextStyle textStyle = Theme.of(context).textTheme.headline6;
    Size size = MediaQuery.of(context).size;

		nameController.text = student.fullName;
		codeController.text = student.cne;

    return WillPopScope(

	    onWillPop: () {
	    	// Write some code to control things, when user press Back navigation button in device navigationBar
		    moveToLastScreen();
	    },

	    child: Scaffold(
	    appBar: AppBar(
		    title: Text(appBarTitle),
		    leading: IconButton(icon: Icon(
				    Icons.arrow_back),
				    onPressed: () {
		    	    // Write some code to control things, when user press back button in AppBar
		    	    moveToLastScreen();
				    }
		    ),
	    ),

	    body: Padding(
		    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
		    child: ListView(
			    children: <Widget>[
            Padding(
					    padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
					    child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //SizedBox(height: size.height * 0.05),
            SvgPicture.asset(
              "assets/images/student.svg",
              height: 150,
            ),
           // SizedBox(height: size.height * 0.05),
          ],
        ),
				    ),
				    // Second Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: nameController,
						    style: textStyle,
						    onChanged: (value) {
						    	debugPrint('Something changed in Name Text Field');
						    	updateName();
						    },
						    decoration: InputDecoration(
							    labelText: 'Full name',
							    labelStyle: textStyle,
							    border: OutlineInputBorder(
								    borderRadius: BorderRadius.circular(5.0)
							    )
						    ),
					    ),
				    ),

				    // Third Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: codeController,
						    style: textStyle,
						    onChanged: (value) {
							    debugPrint('Something changed in CNE Text Field');
							    updateCode();
						    },
						    decoration: InputDecoration(
								    labelText: 'CNE',
								    labelStyle: textStyle,
								    border: OutlineInputBorder(
										    borderRadius: BorderRadius.circular(5.0)
								    )
						    ),
					    ),
				    ),

				    // Fourth Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: Row(
						    children: <Widget>[
						    	Expanded(
								    child: RaisedButton(
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Save',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
									    	setState(() {
									    	  debugPrint("Save button clicked");
									    	  _save();
									    	});
									    },
								    ),
							    ),

							    Container(width: 5.0,),

							    Expanded(
								    child: RaisedButton(
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Delete',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
										    setState(() {
											    debugPrint("Delete button clicked");
											    _delete();
										    });
									    },
								    ),
							    ),

						    ],
					    ),
				    ),

             Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: Row(
						    children: <Widget>[
							    Container(width: 5.0,),
							    Expanded(
								    child: FlatButton(
                      shape: RoundedRectangleBorder(side: BorderSide(
                        color: Colors.purple[800],
                        width: 2,
                        style: BorderStyle.solid
                      ),),
									   // color: Colors.indigoAccent,
									    textColor: Colors.purple[800],
									    child: Text(
										    'Manage Absences ',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
										    setState(() {
											    debugPrint("Absence button clicked");
                          navigateToDetail(this.student);
                          print('Student ID:');
                          print(this.student.id);
											    //_delete();
										    });
									    },
								    ),
							    ),

						    ],
					    ),
				    ),

			    ],
		    ),
	    ),

    ));
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

  void navigateToDetail(Student student) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return AbsenceList(this.student);
	  }));

	  if (result == true) {
	     moveToLastScreen();
	  }
  }


	// Update the title of Note object
  void updateName(){
    student.fullName = nameController.text;
  }

	// Update the description of Note object
	void updateCode() {
		student.cne = codeController.text;
	}

	// Save data to database
	void _save() async {

		moveToLastScreen();

		//note.date = DateFormat.yMMMd().format(DateTime.now());
		int result;
		if (student.id != null) {  // Case 1: Update operation
			result = await helper.updateStudent(student,section);
		} else { // Case 2: Insert Operation
			result = await helper.insertStudent(student,section);
		}

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Student Saved Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Student');
		}

	}

	void _delete() async {

		moveToLastScreen();

		// Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
		// the detail page by pressing the FAB of NoteList page.
		if (student.id == null) {
			_showAlertDialog('Status', 'No Student was deleted');
			return;
		}

		// Case 2: User is trying to delete the old note that already has a valid ID.
		int result = await helper.deleteStudent(student.id);
		if (result != 0) {
			_showAlertDialog('Status', 'Student Deleted Successfully');
		} else {
			_showAlertDialog('Status', 'Error Occured while Deleting Student');
		}
	}

	void _showAlertDialog(String title, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}

}










