import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/section.dart';
import 'package:flutter_app/models/student.dart';
import 'package:flutter_app/utils/database_helper.dart';
import 'package:flutter_app/screens/student_detail.dart';
import 'package:sqflite/sqflite.dart';


class StudentList extends StatefulWidget {

  final Section section;

  StudentList(this.section);

	@override
  State<StatefulWidget> createState() {

    return StudentListState(this.section);
  }
}

class StudentListState extends State<StudentList> {

	DatabaseHelper databaseHelper = DatabaseHelper();
	List<Student> studentList;
	int count = 0;
  Section section;

  StudentListState(this.section);

	@override
  Widget build(BuildContext context) {

		if (studentList == null) {
			studentList = List<Student>();
			updateListView();
		}

    return Scaffold(

	    appBar: AppBar(
		    title: Text('Students List'),
        centerTitle: true,
	    ),

	    body: getStudentListView(),

	    floatingActionButton: FloatingActionButton(
		    onPressed: () {
		      debugPrint('FAB clicked');
		      navigateToDetail(Student('', ''),this.section, 'Add Student');
		    },

		    tooltip: 'Add Student',

		    child: Icon(Icons.add),

	    ),
    );
  }

  ListView getStudentListView() {

		TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

		return ListView.builder(
			itemCount: count,
			itemBuilder: (BuildContext context, int position) {
				return Card(
					color: Colors.white,
					elevation: 2.0,
					child: ListTile(

						leading: CircleAvatar(
							backgroundImage: AssetImage('assets/images/student-detail.png') ,
							backgroundColor: Colors.white,
						),

						title: Text(this.studentList[position].fullName, style: titleStyle,),

						subtitle: Text(this.studentList[position].cne),

						trailing: GestureDetector(
							child: Icon(Icons.delete, color: Colors.grey,),
							onTap: () {
								_delete(context, studentList[position]);
							},
						),


						onTap: () {
							debugPrint("ListTile Tapped");
							navigateToDetail(this.studentList[position],this.section,'Edit Student');
						},

					),
				);
			},
		);
  }

  // Returns the priority color
	Color getPriorityColor(int priority) {
		switch (priority) {
			case 1:
				return Colors.red;
				break;
			case 2:
				return Colors.yellow;
				break;

			default:
				return Colors.yellow;
		}
	}

	// Returns the priority icon
	Icon getPriorityIcon(int priority) {
		switch (priority) {
			case 1:
				return Icon(Icons.play_arrow);
				break;
			case 2:
				return Icon(Icons.keyboard_arrow_right);
				break;

			default:
				return Icon(Icons.keyboard_arrow_right);
		}
	}

	void _delete(BuildContext context, Student student) async {

		int result = await databaseHelper.deleteStudent(student.id);
		if (result != 0) {
			_showSnackBar(context, 'Student Deleted Successfully');
			updateListView();
		}
	}

	void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
	}

  void navigateToDetail(Student student,Section section, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return StudentDetail(student,section, title);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  void updateListView() {

		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Student>> studentListFuture = databaseHelper.getStudentList(this.section);
			studentListFuture.then((studentList) {
				setState(() {
				  this.studentList = studentList;
				  this.count = studentList.length;
				});
			});
		});
  }
}







