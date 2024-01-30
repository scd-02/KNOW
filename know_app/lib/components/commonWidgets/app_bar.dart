import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:know/pages/home.dart';
import 'package:know/pages/profilepage.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Title of the app bar
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
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
              color: const Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10)),
          // GestureDetector for handling taps on the leading widget
          child: GestureDetector(
            onTap: () {
              // Navigate to the HomePage when the leading widget is clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
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
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              // Circular profile image in the app bar
              child: CircleAvatar(
                radius: 20, // Adjust the radius based on your design
                backgroundImage: AssetImage('assets/images/2141010002.jpg'),
              )),
        ),
      ],
    );
  }
}
