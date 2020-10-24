import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/section.dart';
import 'package:flutter_app/models/student.dart';
import 'package:flutter_app/screens/section_detail.dart';
import 'package:flutter_app/screens/student_list.dart';
import 'package:flutter_app/utils/database_helper.dart';
import 'package:flutter_app/screens/student_detail.dart';
import 'package:sqflite/sqflite.dart';


class SectionList extends StatefulWidget {

	@override
  State<StatefulWidget> createState() {

    return SectionListState();
  }
}

class SectionListState extends State<SectionList> {

	DatabaseHelper databaseHelper = DatabaseHelper();
	List<Section> sectionList;
	int count = 0;

	@override
  Widget build(BuildContext context) {

		if (sectionList == null) {
			sectionList = List<Section>();
			updateListView();
		}

    return Scaffold(

	    appBar: AppBar(
		    title: Text('Sections'),
        centerTitle: true,
	    ),

	    body: getSectionListView(),

	    floatingActionButton: FloatingActionButton(
		    onPressed: () {
		      debugPrint('FAB clicked');
		      navigateToDetail(Section(''), 'Add Section');
		    },

		    tooltip: 'Add Section',

		    child: Icon(Icons.add),

	    ),
    );
  }

  GridView getSectionListView() {

		TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

		return GridView.builder(
			itemCount: count,
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0),
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.deepPurple[200],
            
            elevation: 2.0,
            child: ListTile(

          title: new Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              GestureDetector(
                child: Icon(Icons.delete, color: Colors.blue[920],),
                onTap: () {
                  _delete(context, sectionList[position]);
                },
              ),
            ],
          ) ,
            subtitle: new Center(child: new Text(this.sectionList[position].name,
                                  
                      style: TextStyle(color: Colors.deepPurple[900],
                                       fontWeight: FontWeight.bold,
                                       fontSize: 18,
                                       ),) ,
                                       ) ,

              onTap: () {
                debugPrint("ListTile Tapped");
                navigateToListStd(this.sectionList[position]);
                print(this.sectionList[position]);
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

	void _delete(BuildContext context, Section section) async {

		int result = await databaseHelper.deleteSection(section.id);
		if (result != 0) {
			_showSnackBar(context, 'Section Deleted Successfully');
			updateListView();
		}
	}

	void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
	}

  void navigateToDetail(Section section, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return SectionDetail(section, title);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }
  void navigateToListStd(Section section) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return StudentList(section);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  void updateListView() {

		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Section>> sectionListFuture = databaseHelper.getSectionList();
			sectionListFuture.then((sectionList) {
				setState(() {
				  this.sectionList = sectionList;
				  this.count = sectionList.length;
				});
			});
		});
  }
}







