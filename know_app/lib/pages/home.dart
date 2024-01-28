// Importing necessary packages and libraries
import 'package:flutter/material.dart';
import 'package:know/pages/travelpage.dart';
import 'package:know/templates/forms.dart';

// Definition of a stateless widget for the HomePage
class HomePage extends StatelessWidget {
  // Constructor for the HomePage widget
  const HomePage({super.key});

  // Build method to create the widget's UI
  @override
  Widget build(BuildContext context) {
    // Scaffold widget for the overall structure of the page
    return Scaffold(
      // AppBar at the top of the page
      appBar: AppBar(
        // Title of the app bar
        title: const Text('Know App',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        // Background color of the app bar
        backgroundColor: Colors.white,
        // Elevation to remove shadow in the app bar
        elevation: 0.0,
        // Center the title in the app bar
        centerTitle: true,
        // Leading widget in the app bar
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          // GestureDetector for handling taps on the leading widget
          child: GestureDetector(
            onTap: () {
              // Navigate to the TravelPage when the leading widget is clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TravelPage()),
              );
            },
            // Circular profile image in the app bar
            child: ClipOval(
              child: Image.asset(
                'assets/images/2141010002.jpg',
                width: 40,
                height: 40,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
      ),
      body: Column(children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FormsPage()),
            );
          },
          child: const Text("Form Page"),
        )
      ]),
    );
  }
}
