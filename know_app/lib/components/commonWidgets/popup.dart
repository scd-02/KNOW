import 'package:flutter/material.dart';

class ShowPopup extends StatelessWidget {
  final String btn1;
  final String btn2;
  final Function(String) onButtonPressed;

  const ShowPopup({
    Key? key,
    required this.btn1,
    required this.btn2,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: AlertDialog(
        alignment: Alignment.bottomLeft,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        content: SizedBox(
          height: 150,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Call the callback with the appropriate button text
                  onButtonPressed(btn1);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 25,
                  ),
                ),
                child: Text(
                  btn1,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Call the callback with the appropriate button text
                  onButtonPressed(btn2);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 25,
                  ),
                ),
                child: Text(
                  btn2,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
