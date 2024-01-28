// Import necessary packages and files
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:know/pages/home.dart';

// Define a stateless widget for the TravelPage
class FormsPage extends StatefulWidget {
  // Constructor for the TravelPage widget
  const FormsPage({super.key});
  State<StatefulWidget> createState() {
    return FormsPageState();
  }
}

class FormsPageState extends State<FormsPage> {
  TimeOfDay time = const TimeOfDay(hour: 10, minute: 30);

  Widget build(BuildContext context) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    // Scaffold widget for the overall structure of the page
    return Scaffold(
      // AppBar at the top of the page
      appBar: AppBar(
        // Title of the app bar
        title: const Text('Travels',
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
        // Leading widget in the app bar (usually the back button)
        leading: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            // Decoration for the leading container
            decoration: BoxDecoration(
                color: Color(0xffF7F8F8),
                borderRadius: BorderRadius.circular(10)),
            // GestureDetector for handling taps on the leading widget
            child: GestureDetector(
              onTap: () {
                // Navigate to the HomePage when the leading widget is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              // SVG icon for the leading widget
              child: SvgPicture.asset(
                'assets/icons/arrow-left.svg',
                height: 20,
                width: 20,
              ),
            )),
        // Actions on the right side of the app bar
        actions: [
          // GestureDetector for handling taps on the profile image
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to the TravelPage when the profile image is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
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
        ],
      ),
      // Body of the page
      body: Column(
        children: [
          const Row(
            children: [
              Text("Enter Text : "),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your email or username'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Set Time : "),
              Text(
                '$hours : $minutes',
                style: const TextStyle(fontSize: 32),
              ),
              ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? newTime = await showTimePicker(
                        context: context, initialTime: time);
                    if (newTime == null) return;
                    setState(() {
                      time = newTime;
                    });
                  },
                  child: Text("Select Time"))
            ],
          ),
        ],
      ),
      // Location of the floating action button on the screen
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // Configuration for the floating action button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          // Widget for the floating action button
          child: SizedBox(
            height: 50,
            width: 50,
            // Elevated button for the floating action button
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              // SVG icon for the floating action button
              child: SvgPicture.asset(
                'assets/icons/plus.svg',
                height: 30,
                width: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
