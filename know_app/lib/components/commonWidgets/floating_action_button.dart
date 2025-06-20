import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'popup.dart';

class MyFloatingActionButton extends StatelessWidget {
  final String btn1;
  final String btn2;
  final Function(String) onButtonPressed; // Correct function type

  const MyFloatingActionButton({
    Key? key,
    required this.btn1,
    required this.btn2,
    required this.onButtonPressed, // Pass the callback as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ShowPopup(
                btn1: btn1,
                btn2: btn2,
                onButtonPressed:
                    onButtonPressed, // Pass the callback to the ShowPopup
              );
            },
            barrierColor: Colors.black.withOpacity(0.5),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(10),
        ),
        child: SvgPicture.asset(
          'assets/icons/plus.svg',
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}
