import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/section.dart';
import 'package:flutter_app/models/student.dart';
import 'package:flutter_app/utils/database_helper.dart';
import 'package:intl/intl.dart';

import 'absence_list.dart';

class SectionDetail extends StatefulWidget {

	final String appBarTitle;
	final Section section;

	SectionDetail(this. section, this.appBarTitle);

	@override
  State<StatefulWidget> createState() {

    return SectionDetailState(this.section, this.appBarTitle);
  }
}

class SectionDetailState extends State<SectionDetail> {

	static var _priorities = ['High', 'Low'];

	DatabaseHelper helper = DatabaseHelper();

	String appBarTitle;
	Section section;

	TextEditingController nameController = TextEditingController();

	SectionDetailState(this.section, this.appBarTitle);

	@override
  Widget build(BuildContext context) {

		TextStyle textStyle = Theme.of(context).textTheme.headline6;

		nameController.text = section.name;

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
							    labelText: 'Section name',
							    labelStyle: textStyle,
							    border: OutlineInputBorder(
								    borderRadius: BorderRadius.circular(5.0)
							    )
						    ),
					    ),
				    ),

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

			    ],
		    ),
	    ),

    ));
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

	// Update the title of Note object
  void updateName() {
    section.name = nameController.text;
  }


	// Save data to database
	void _save() async {

		moveToLastScreen();

		//note.date = DateFormat.yMMMd().format(DateTime.now());
		int result;
		if (section.id != null) {  // Case 1: Update operation
			result = await helper.updateSection(section);
		} else { // Case 2: Insert Operation
			result = await helper.insertSection(section);
		}

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Section Saved Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Section');
		}

	}

	void _delete() async {

		moveToLastScreen();
		if (section.id == null) {
			_showAlertDialog('Status', 'No Section was deleted');
			return;
		}

		// Case 2: User is trying to delete the old note that already has a valid ID.
		int result = await helper.deleteSection(section.id);
		if (result != 0) {
			_showAlertDialog('Status', 'Section Deleted Successfully');
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










