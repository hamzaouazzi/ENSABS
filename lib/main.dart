import 'package:flutter/material.dart';
import 'screens/Welcome/welcome_screen.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {

	@override
  Widget build(BuildContext context) {

    return MaterialApp(
	    title: 'Student Absence Management',
	    debugShowCheckedModeBanner: false,
	    theme: ThemeData(
		    primarySwatch: Colors.deepPurple
	    ),
	    home: WelcomeScreen(),
    );
  }
}