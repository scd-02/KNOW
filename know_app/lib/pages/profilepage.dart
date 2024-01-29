import 'package:flutter/material.dart';
import 'package:know/components/commonWidgets/app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  // This method is called when the StatefulWidget is created.
  // It returns the mutable state for the class ProfilePage.
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  //Initial data for the user profile
  String name = 'Xyz Abc';
  String email = 'xyz@gmail.com';
  String dateOfBirth = 'xx yy zz';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar at the top of the screen
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Profile'),
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            //Align column's Children to center vertically
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Implementation of profile picture
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(
                    'assets/images/2141010002.jpg',
                  ),
                ),
              ),

              //User information displayed in a Column
              Column(
                //Align column's Children to start horizontally
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Displaying Name
                  Text(
                    'Name : $name',
                    style: const TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  //vertical spacing
                  const SizedBox(height: 20.0),
                  // Displaying Email
                  Text(
                    'Email : $email',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                    ),
                  ),
                  //vertical spacing
                  const SizedBox(height: 20.0),
                  // Displaying Date of Birth
                  Text(
                    'Date of Birth : $dateOfBirth',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              //vertical spacing
              const SizedBox(height: 100.0),
              // Update button
              ElevatedButton(
                onPressed: () async {
                  // Navigate to the form page and wait for the result

                  // var result = await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const FormsPage()));

                  // Uncomment these line when formpage is completed

                  // // Update the data if the result is not null
                  // if (result != null && result is Map<String, String>) {
                  //   setState(() {
                  //     name = result['name'] ?? name;
                  //     email = result['email'] ?? email;
                  //     dateOfBirth = result['dob'] ?? dateOfBirth;
                  //   });
                  // }
                },
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
