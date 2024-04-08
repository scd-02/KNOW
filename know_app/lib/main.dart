// Importing necessary packages and libraries
import 'package:flutter/material.dart';


// Importing the custom home page widget
import 'pages/home.dart';

// Main function, entry point of the application
void main() {
  // Running the application with the MyApp widget as the root
  runApp(const MyApp());
}

// Definition of the main application widget, MyApp
class MyApp extends StatelessWidget {
  // Constructor for the MyApp widget
  const MyApp({super.key});

  // Build method to create the widget's UI
  @override
  Widget build(BuildContext context) {
    // const keyword is used when the value of the variable is known at compile time and never changes
    return MaterialApp(
      // To remove the Flutter default banner from the screen
      debugShowCheckedModeBanner: false,
      // Setting the theme for the entire application
      theme: ThemeData(fontFamily: 'Poppins'),
      // Setting the home page of the application
      home: const HomePage(),
    );
  }
}
